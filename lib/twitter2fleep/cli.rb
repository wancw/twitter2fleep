require 'twitter2fleep/version'

require 'thor'
require 'twitter'
require 'http'
require 'yaml'

class Twitter2Fleep::CLI < Thor
  desc "start", "Start the bot"
  def start
    begin
      config_file = "#{Dir.home}/.twitter2fleep/config.yml"
      t2f_config = YAML::load_file(config_file)
    rescue Errno::ENOENT => exception
      puts "You need to create the config file ~/.twitter2fleep/config.yml"
      puts "See example at https://github.com/wancw/twitter2fleep/blob/master/config.yml.example"
      exit(-1)
    end

    client = Twitter::Streaming::Client.new do |client_config|
      client_config.consumer_key        = t2f_config[:client][:consumer_key]
      client_config.consumer_secret     = t2f_config[:client][:consumer_secret]
      client_config.access_token        = t2f_config[:client][:access_token]
      client_config.access_token_secret = t2f_config[:client][:access_token_secret]
    end

    $selected_user_ids = t2f_config[:selected_user_ids]

    fleep_hook_url = t2f_config[:fleep_hook_url]

    def should_post?(tweet)
      $selected_user_ids.nil? or (
        $selected_user_ids.include?(tweet.user.id) and (
          not tweet.reply? or $selected_user_ids.include?(tweet.in_reply_to_user_id)
        )
      )
    end

    client.user do |object|
      case object
      when Twitter::Tweet
        tweet = object
        author = tweet.user
        if should_post?(tweet)
          message = "@#{author.screen_name}:\n#{tweet.text}"

          response = HTTP.post(
            "#{fleep_hook_url}/#{author.screen_name}",
            :form => {:message => message}
          ).response

          puts message
          puts "----> #{response.status_code}"
        end
      when Twitter::Streaming::StallWarning
        warn "Falling behind!"
      end
    end
  end
end
