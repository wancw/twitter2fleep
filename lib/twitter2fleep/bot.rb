require 'twitter'
require 'http'

class Twitter2Fleep::Bot
  def initialize(config)
    @twitter_client = Twitter::Streaming::Client.new(config[:twitter])
    @selected_user_ids = config[:selected_user_ids]
    @fleep_hook_url = config[:fleep_hook_url]
  end

  def start
    @twitter_client.user do |object|
      case object
      when Twitter::Tweet
        tweet = object
        author = tweet.user

        if should_post?(tweet)
          message = "@#{author.screen_name}: #{tweet.text}"

          response = post_to_fleep(author.screen_name, message)

          puts message
          puts "----> #{response.status_code}"
        end
      when Twitter::Streaming::StallWarning
        warn "Falling behind!"
      end
    end
  end

  private

  def should_post?(tweet)
    @selected_user_ids.nil? or (
      @selected_user_ids.include?(tweet.user.id) and (
        not tweet.reply? or @selected_user_ids.include?(tweet.in_reply_to_user_id)
      )
    )
  end

  def post_to_fleep(display_name, message)
    HTTP.post(
      "#{@fleep_hook_url}/#{display_name}",
      :form => {:message => message}
    ).response
  end
end