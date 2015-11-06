require "slack-ruby-client"
require_relative 'naive_bayes'

Slack.configure do |config|
    config.token = "xoxb-14001526022-oAjNI02QXScEUrAL1SyFPu0C"
end

def train
  pos_data = IO.readlines("pos_data.txt")
  neg_data = IO.readlines("neg_data.txt")

  @nb ||= NaiveBayes::NaiveBayes.new(pos_data, neg_data)
  @nb.train
end


client = Slack::RealTime::Client.new

train

client.on :hello do
  puts "Successfully connected, welcome '#{client.self['name']}' to the '#{client.team['name']}' team at https://#{client.team['domain']}.slack.com."
end

client.on :message do |data|
    case data['text']
    when /^(.*)$/ then
        prob = @nb.classify(data['text'])
        if prob > 0.9 then
            client.typing channel: data['channel']
            client.message channel: data['channel'], text: ("<@%s>, that's what she said! (p=%0.4f)" % [data['user'], prob])
        end
    end
end

client.start!
