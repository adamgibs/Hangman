class Hangman

	attr_accessor :dict

	def initialize
		@dict = File.open("5desk.txt", "r").map {|line| line}.select do 
		|word| word.length >= 5 && word.length <= 12
		end
	end

	def play
		word(dict)
	end

	 def word(dictionary)
	 	puts dictionary[rand(dictionary.length)]
	 end
end

Hangman.new.play