require 'sinatra'
require 'json'
require_relative 'naive_bayes'

set :port, 3000
set :bind, '0.0.0.0'

pos_data = IO.readlines("pos_data.txt")
neg_data = IO.readlines("neg_data.txt")
naive_bayes = NaiveBayes::NaiveBayes.new(pos_data, neg_data)
naive_bayes.train

get '/' do
  erb :index
end

get '/:phrase' do |phrase|
  content_type :json
  prob = naive_bayes.classify(phrase)
  {prob: prob, twss: prob>0.9, phrase: phrase}.to_json
end
