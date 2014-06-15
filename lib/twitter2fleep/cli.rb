require 'twitter2fleep/bot'

require 'thor'
require 'yaml'

class Twitter2Fleep::CLI < Thor
  desc "start", "Start the bot"
  option :config_file, :default => "#{Dir.home}/.twitter2fleep/config.yml"
  option :env_config, :type => :boolean, :default => false

  def start
    if options[:env_config]
      puts "Load config from environment variables."
      config = load_env_config
    else
      config_file = options[:config_file]
      puts "Load config from \`#{config_file}\`."
      config = load_config_file(config_file)
    end
    bot = Twitter2Fleep::Bot.new(config)
    bot.start
  end

  no_commands do
    def load_env_config
      {
        :twitter => {
          :consumer_key => ENV.fetch('TWITTER_CONSUMER_KEY', ''),
          :consumer_secret => ENV.fetch('TWITTER_CONSUMER_SECRET', ''),
          :access_token => ENV.fetch('TWITTER_ACCESS_TOKEN', ''),
          :access_token_secret => ENV.fetch('TWITTER_ACCESS_TOKEN_SECRET', ''),
        },
        :selected_user_ids => ENV.fetch('SELECTED_USER_IDS', '').split(',').map {|v| v.to_i},
        :fleep_hook_url => ENV.fetch('FLEEP_HOOK_URL', '')
      }
    end

    def load_config_file(filename)
      config_file = options[:config_file]

      begin
        config = YAML::load_file(config_file)
      rescue Errno::ENOENT => exception
        puts "You need to create the config file \`#{config_file}\`"
        puts "See example at https://github.com/wancw/twitter2fleep/blob/master/config.yml.example"
        exit(-1)
      end

      config[:twitter] = config[:client]
      config.delete :config

      return config
    end
  end

end
