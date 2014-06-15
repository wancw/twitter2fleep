require 'twitter2fleep/bot'

require 'thor'
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
    t2f_config[:twitter] = t2f_config[:client]

    bot = Twitter2Fleep::Bot.new(t2f_config)
    bot.start
  end
end
