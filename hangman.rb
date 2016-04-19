require "yaml"

class Hangman

	attr_accessor :dict, :turns, :board, :wrong_letters, :downcase_word, :word_array, :default_data_hash

	def initialize
		@dict = File.open("5desk.txt", "r").map {|line| line}.select do 
			|word| word.length >= 5 && word.length <= 12
		end
		@downcase_word = word(dict).downcase.chomp
		@word_array = downcase_word.chomp.split("")
		@wrong_letters = []
		@board = ["_ "] * word_array.length
		@default_data_hash = {word_array: word_array, turns: 5, board: board, wrong_letters: wrong_letters}
	end

	def play
		welcome
		game_start
	end
	
	def game_play(*data_hash)
		turns = data_hash[0][:turns]
		word_array = data_hash[0][:word_array]
		board = data_hash[0][:board]
		wrong_letters = data_hash[0][:wrong_letters]
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
			puts "Would you like to save this game? y/n"
			answer = gets.chomp.downcase
			if answer == "y"
				save_game(word_array, turns, board, wrong_letters)
				puts "Your game has been saved."
				puts "\n"
			end
			if won?(word_array, board, guess)
				won_message
				break
			end
		end
		unless won?(word_array, board, guess)
			loss_message(downcase_word)
		end
	end

	def game_start
		p "If you would like to play a new game, select 1."
		p "If you would like to load your last saved game, select 2."
		user_choice = gets.chomp.to_i
		if user_choice == 1
			game_play(default_data_hash)
		else
			game_play(load_game)
		end
	end

	def won_message
		puts "Congratulations, you've won!"
	end

	def loss_message(word)
		puts "I'm sorry. You have lost."
		puts "The secret word was \'#{word}\'"
	end

	def save_game(word_array, turns, board, wrong_letters)
		data_hash = {word_array: word_array, turns: turns, board: board, wrong_letters: wrong_letters}
		f = File.open( 'save_game.yml', 'w' )
		YAML.dump( data_hash, f )
		f.close
	end

	def load_game
		YAML.load_file("save_game.yml")
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
