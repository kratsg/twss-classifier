require 'cinch'
require 'cinch/plugins/identify'
require_relative 'naive_bayes'

bot = Cinch::Bot.new do
  configure do |c|
    c.nick            = 'pervy'
    c.password        = ''
    c.server          = 'irc.oftc.net'
    #  c.port            = 7000
    #  c.ssl             = true
    c.verbose         = true
    c.channels        = ["#asl"]
    c.plugins.plugins = [Cinch::Plugins::Identify] # optioinally add more plugins
    c.plugins.options[Cinch::Plugins::Identify] = {
      :username => c.password,# oftc.net is backwards
      :password => c.nick,
      :type     => :nickserv,
    }
    @nb = ''
  end

  helpers do
    def initialize
      pos_data = IO.readlines("pos_data.txt")
      neg_data = IO.readlines("neg_data.txt")

      @nb ||= NaiveBayes::NaiveBayes.new(pos_data, neg_data)
      @nb.train
    end

  end

  on :connect do
    initialize
  end

  on :message, /^(.*)$/ do |m, sentence|
    prob = @nb.classify(sentence)
    m.reply("%s, that's what she said! (p=%0.4f)" % [m.user.nick, prob]) if prob > 0.9
  end

end

bot.start
