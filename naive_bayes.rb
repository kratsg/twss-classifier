module NaiveBayes
  class NaiveBayes
    def initialize(positive_training_examples, negative_training_examples)
      #examples should just be a list of sentences, no more, no less
      @pos_tra_exa = positive_training_examples
      @neg_tra_exa = negative_training_examples
    end
  
    def train
      #generate histogram counts of the words in training sets
      @pos_counts = histogram @pos_tra_exa
      @neg_counts = histogram @neg_tra_exa
  
      #get total counts
      pos_total = @pos_counts.values.inject(0.0){ |sum,x| sum + x }
      neg_total = @neg_counts.values.inject(0.0){ |sum,x| sum + x }
  
      #generate probabilities - default is [0.5,0.5]
      @probs = Hash.new{ |h,k| h[k] = [0.5,0.5] }
      (@pos_counts.keys + @neg_counts.keys).uniq.each do |unigram|
        @probs[unigram] = [
          @pos_counts[unigram].to_f / pos_total.to_f,
          @neg_counts[unigram].to_f / neg_total.to_f
        ]
      end
    end
  
    def histogram(sentences)
      h = Hash.new{ |h,k| h[k] = 0.0 }
      sentences.each do |sentence|
        unigrams(sentence).each{ |unigram| h[unigram] += 1.0 }
      end
      h
    end
  
    def normalize(str)
      str.downcase.gsub(/[^a-z0-9\s]/,"").gsub(/\s+/, " ")
    end
  
    def unigrams(str)
      normalize(str).split
    end
  
    def classify(sentence)
      probs = unigrams(sentence).map{|w| @probs[w] || [0.5,0.5]}
      pos_probs = probs.map{|x| x[0]}.inject(1.0){ |s,t| s * t }
      neg_probs = probs.map{|x| x[1]}.inject(1.0){ |s,t| s * t }
      pos_probs / (pos_probs + neg_probs)
    end
  end
end
