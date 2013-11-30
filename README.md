That's What She Said classifier
===============================

- Naive Bayes unigram classification scheme
- the IRC bot uses Cinch
- `ruby main.rb` for the command line version of it. It tells you whether or not a  sentence you enter passes the threshold or not and reports the probability.
- built with love in Ruby

Training Sets
-------------

Positive training data sets are from [TWSS Stories](http://www.twssstories.com/). Negative training data sets are from [FMyLife](http://www.fmylife.com/).

Naive Bayes
-----------
The code in the `naive_bayes.rb` is general enough that you can load up any other data set that you want to use a unigram model on, or for. `main.rb` presents an effective demo of how one might use it for TWSS Sentiment Classifier.

Cinch (IRCBot)
--------------
Running `ruby IRCBot.rb` works. All it does is take code in `main.rb` and apply it to a bot that listens and responds when appropriate (threshold = 0.9).
