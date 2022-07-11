class Game
  COLORS = ["red","blue","yellow","green","white","black"]

  def initialize(player_1_class,player_2_class)
    @guesses = 0

    @code_maker_id = 0
    @code_breaker_id = 1
    @players = [player_1_class.new, player_2_class.new].shuffle
  end

  def play
    @players[0].ask_name
    @players[1].ask_name
    loop do
      @code = code_maker.create_code
      p @code
      10.times do 
        guess = code_breaker.make_guess

        return "#{code_breaker.name}, you cracked the code!" if guessed_code?(guess)

        code_maker.compare_guess(@code, guess)

      end

      puts "#{code_breaker.name}, you ran out of guesses! #{code_maker.name}, you win!"

      keep_playing?

      break if game_over
      switch_players!
    end
  end

  def code_maker
    @players[@code_maker_id]
  end

  def code_breaker
    @players[@code_breaker_id]
  end

  def switch_players!
    @code_breaker_id = @code_maker_id
    @code_maker_id = (@code_maker_id + 1) % 2
  end

  def guessed_code?(guess)
    @code == guess
  end

  def game_over
    puts "Would you like to switch roles and play again?"
    puts "'yes' or 'no'"
    response = gets.chomp
    response == "yes" ? false : true
  end

end

class HumanPlayer
  def ask_name
    puts "What is your name?"
    @name = gets.chomp
  end

  def create_code
    code = []
    puts "Please enter 4 numbers between 1 and 6"
    4.times do |index|
      loop do 
        num = gets.to_i
        if num >= 1 && num <= 6
          code.push(num)
          break
        end
      puts "Incorrect input! Please enter a valid number between 1 and 6"
      end
    end
    return code
  end

  def make_guess
    guess = []
    puts "#{@name}, guess the code! (4 digits between 1 and 6)"
    4.times do |index|
      loop do 
        num = gets.to_i
        if num >= 1 && num <= 6
          guess.push(num)
          break
        end
      puts "Incorrect input! Please enter a valid number between 1 and 6"
      end
    end
    return guess
  end

  def compare_guess(code, guess)
    # in response, 0 = correct color, correct place and 1 = correct color, wrong place
    response = []
    code.each_with_index do |val, i|
      if val == guess[i]
        response.push(0)
        guess[i] = nil
      elsif guess.include? val
        response.push(1)
        guess[guess.index(val)] = nil
      end
    end
    puts "Code maker's response:"
    p response.shuffle
  end

attr_reader :name
end

Game.new(HumanPlayer,HumanPlayer).play