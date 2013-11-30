require_relative 'naive_bayes'

def raw_input(prompt='')
  p prompt unless prompt.empty?
  gets
end

pos_data = IO.readlines("pos_data.txt")
neg_data = IO.readlines("neg_data.txt")

naive_bayes = NaiveBayes::NaiveBayes.new(pos_data, neg_data)
naive_bayes.train
while true
  inp = raw_input.strip
  break if inp == 'end'
  prob = naive_bayes.classify(inp)
  puts "\t %s: %s = %0.3f" % [prob > 0.9, inp, prob] 
end
