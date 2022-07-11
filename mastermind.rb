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

        code_maker.compare_guess(guess)

      end

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
          code[index] = num
          break
        end
      end
    end
    return code
  end
end

Game.new(HumanPlayer,HumanPlayer).play