class Hangman

	attr_accessor :dict, :turns, :board, :wrong_letters

	def initialize
		@dict = File.open("5desk.txt", "r").map {|line| line}.select do 
			|word| word.length >= 5 && word.length <= 12
		end
		
		@wrong_letters = []
	end

		def play
		welcome
		word = word(dict).downcase.chomp
		word_array = word.chomp.split("")
		board = ["_ "] * word.length
		turns = 5
		until turns == 0 do
			puts "The number of turns left is #{turns}"
			prompt_player
			guess = player_guess
			process_guess(guess, word_array, board, wrong_letters)
			display_board(board)
			display_wrong_letters
			unless word_array.include? guess
				turns -= 1
			end
			if won?(word_array, board, guess)
				won_message
				break
			end
		end
		unless won?(word_array, board, guess)
			loss_message(word)
		end
	end

	def won_message
		puts "Congratulations, you've won!"
	end

	def loss_message(word)
		puts "I'm sorry. You have lost."
		puts "The secret word was \'#{word}\'"
	end

	def won?(word_array, board, guess)
		word_array == board || guess == word_array
	end


	def turns_left(num)
		until num == 0 do
			p num
			num -= 1
		end
	end

	def display_board(board)
		p board.join("")
	end

	def welcome
		puts "Welcome to hangman!"
		puts "In this game, you get five turns to guess the secret word."
		puts "Everytime you guess an incorrect letter, you lose a turn."
		puts "You must guess the secret word before your turns equal zero. "
	end

	def display_wrong_letters
		puts "The incorrect letters you have chosen thus far are #{wrong_letters}"
		puts "-------------------------------------------------"
	end

	def word(dictionary)
	 	dictionary[rand(dictionary.length)]
	end

	def player_guess
		gets.chomp.downcase
	end
	def prompt_player
		puts "Please pick a letter or guess the word."
	end
	
	def process_guess(guess, word, board, wrong_letters)
		if word.include? guess
			word.each_with_index do |letter, index|
				if letter == guess
					board[index] = guess
				end
			end
		else
			wrong_letters << guess
		end
	end

end



Hangman.new.play