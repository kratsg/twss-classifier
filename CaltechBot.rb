require 'cinch'
require_relative 'naive_bayes'

bot = Cinch::Bot.new do
  configure do |c|
    c.nick            = 'pervy_techer'
    c.password        = ''
    c.server          = 'irc.freenode.net'
    #  c.port            = 7000
    #  c.ssl             = true
    c.verbose         = true
    c.channels        = ["#caltech"]
    c.plugins.plugins = [] # optioinally add more plugins
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
