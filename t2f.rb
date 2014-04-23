#!/usr/bin/env ruby

require 'bundler/setup'

require 'twitter'
require 'http'
require 'yaml'

t2f_config = YAML::load_file('config.yml')

client = Twitter::Streaming::Client.new do |client_config|
  client_config.consumer_key        = t2f_config[:client][:consumer_key]
  client_config.consumer_secret     = t2f_config[:client][:consumer_secret]
  client_config.access_token        = t2f_config[:client][:access_token]
  client_config.access_token_secret = t2f_config[:client][:access_token_secret]
end

selected_user_ids = t2f_config[:selected_user_ids]

fleep_hook_url = t2f_config[:fleep_hook_url]

client.user do |object|
  case object
  when Twitter::Tweet
    tweet = object
    author = tweet.user
    if selected_user_ids.nil? or selected_user_ids.include?(author.id)
      response = HTTP.post(
        "#{fleep_hook_url}/#{author.screen_name}",
        :form => {:message => tweet.text}
      ).response

      puts "@#{author.screen_name}: #{tweet.text}"
      puts "----> #{response.status_code}"
    end
  when Twitter::Streaming::StallWarning
    warn "Falling behind!"
  end
end
