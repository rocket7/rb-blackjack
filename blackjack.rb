# Ruby Based Blackjack Program

#Refactor with COMMAND CLASS - https://refactoring.guru/design-patterns/command/ruby/example

require 'pry'

class Player
  
  attr_reader :cards
  attr_accessor :name
  attr_reader :count

  def initialize
    @name = ""
    @cards = []
    @count = 0
  end

  def get_name
    @name
  end

  def get_cards
    @cards
  end

  def get_count
    @count
  end

  def set_name(x)
    @name = x
  end

  def set_cards(x)
    @cards << x
  end

  def set_count(x)
    @count = x
  end
end

class Bettor < Player

  attr_accessor :cards
  attr_accessor :count
  attr_accessor :bet
  attr_accessor :balance

  def initialize()
    super()
    @name = "player"
    @cards = []
    @count = 0
    @bet = 0
    @balance = 100
  end

  # def deal(card)
  #   @cards << card
  # end


  def set_bet(x)
    @bet = x
  end

  def set_balance(x)
    @balance = x
  end

  def get_bet
    @bet
  end

  def get_balance
    @balance
  end


end

class Dealer < Player
  attr_accessor :count
  attr_accessor :cards
  attr_accessor :balance

  def initialize
    super()
    @name = "dealer"
    @cards = []
    @count = 0
    @balance = 0
  end

end



class Cards 

  attr_accessor :shuffled_deck

  def initialize 
    @suit = ["Spade", "Diamonds", "Hearts", "Clubs"]
    @number = %w[One Two Three Four Five Six Seven Eight Nine Ten Jack Queen King Ace]
    @points = %w[1 2 3 4 5 6 7 8 9 10 10 10 10 1] #STRING VALUES
    @hidden = %w[y y y y y y y y y y y y y y]
    @deck = []
    @shuffled_deck = []
    #@card = []
    @decks = 1
  end

# %w() array of strings
# %r() regular expression.
# %q() string
# %x() a shell command (returning the output string)
# %i() array of symbols (Ruby >= 2.0.0)
# %s() symbol
# %() (without letter) shortcut for %Q()

# ways to call shell commands from ruby
# using backtick => returns output to ruby - no stderr
# using system( cmd ) +> outputs to stdout
# using %x( cmd ) => no stderr
# using exec( cmd ) => does not return to ruby
# $?.exitstatus
# 2>&1 - for stderr and stdout
# 1> - stdout
# 2> - stderr


  # def deal_card x
  #   x.times do
  #     @card << @shuffled_deck.pop
  #   end
  #   return @card
  # end

  # Create an array to represent a deck of cards
  def create_deck
    @decks.times do
      @suit.each do |suit|
        @number.each_with_index do |num, index|
          @deck << [suit, num, @points[index], @hidden[index]]
          #puts "#{suit} #{num} #{@points[index]}"
        end
      end
    end
  end

  def shuffle_cards
    @shuffled_deck = @deck.shuffle
    #puts @shuffled_deck
  end


  def print_deck
    puts @shuffleddeck
    #puts @shuffleddeck[0][0] #Spade
  end
  
  def print_length
    puts @shuffled_deck.length
  end
end

class Blackjack < Cards
  attr_accessor :dealer
  attr_accessor :player

  $BLACKJACK = 21

  @@class_var = 21
  def initialize()
    super()
    @instance_variable = 1
    @dealer = Dealer.new
    @player = Bettor.new
    @deckofcards = Cards.new
    @hands_dealt = 0
    @cards_hand = 0
  end
  
  # def create_deck
  #   #To reinitialize deck after game
  #   @deckofcards = Cards.new
  # end

  # def shuffle_cards
  #   @deckofcards.shuffle_cards
  #   @deckofcards.print_deck
  # end


  def start_game
    @deckofcards.create_deck
    @deckofcards.shuffle_cards
  end

  def deal_cards(num_of_cards)
    num_of_cards.times do
      @player.cards << @deckofcards.shuffled_deck.pop 
      @dealer.cards << @deckofcards.shuffled_deck.pop 
      @player.count = count_cards(@player)
      @dealer.count = count_cards(@dealer)

      #@player.cards += @deckofcards.shuffled_deck.pop # THIS ADDS TO SINLGE DIMENSIONAL ARRAY
      #@dealer.cards += @deckofcards.shuffled_deck.pop # THIS ADDS TO SINLGE DIMENSIONAL ARRAY
    end
  end

  def hit_card()
    #player.cards << @deckofcards.deal_card(1)
    new_card = true
    while new_card == true do
      puts "[Player] Do you want to hit? [y|n]"
      player_input = gets.chomp
      if player_input.downcase == 'y'
        #@player.cards << @deckofcards.deal_card(1)
        @player.cards << @deckofcards.shuffled_deck.pop
        @player.count = count_cards(@player)
        puts "[Player] Card total count: #{@player.count}"
        new_card = true
      else
        new_card = false
        break
      end
    end
  end

  def dealer_hit_card
    while @dealer.count < 17
      #@dealer.cards.push(@deckofcards.deal_card(1))
      @dealer.cards << @deckofcards.shuffled_deck.pop
      @dealer.count = count_cards(@dealer)
      puts "[Dealer] Card total count: #{@dealer.count}"
    end
  end

  def count_cards(card_player)
    count = 0
    #puts player_hand[0].length #NEED TO GET ARRAYS INSIDE
    #binding.pry
    # THE WAY IT IS COUNTING ARRAYS IS WEIRD - [0][5] vs [1][2] and it is giving entire array instead of sub-arrays
    card_player.cards.each do |card|
      count += card[2].to_i
    end
    return count
  end

  def get_player_hand()
    p "Player #{@player.name} has following cards"
    p "Cards: #{@player.get_cards}"
    p "Count: #{@player.count}"

  end

  def get_dealer_hand()
    p "Dealer #{@dealer.name} has following cards"
    p "Cards: #{@dealer.get_cards}"
    p "Count: #{@dealer.count}"
  end

  def game_summary()
    puts "Dealer has #{@dealer.get_cards}\nCard count #{count_cards(@dealer)}"
    puts "Player has #{@player.get_cards}\nCard count #{count_cards(@player)}"
  end

  def check_scores()
    @winner = false
    while @winner == false do
      puts "[Player] Do you want to hit? [y|n]"
      player_input = gets.chomp
      if player_input.downcase == 'y'
        hit_card()
        puts game_summary
      elsif  @dealer.count < 17
        dealer_hit_card()
        puts game_summary
      elsif @player.count == 21 && @dealer.count == 21
        puts game_summary
        puts "Both player and dealer have Blackjack! Push!"
        @winner = true
      elsif @player.count == 21 && @dealer.count < 21 && @dealer.count >= 17
        puts game_summary
        puts "Player has Blackjack!"
        @winner = true
      elsif @player.count > 21 && @dealer.count <= 21
        puts game_summary
        puts "Dealer wins.  Player has more than 21 and losses!"
        @winner = true
      elsif @dealer.count > 21 && @player.count <= 21
        puts game_summary
        puts "Player wins.  Dealer has more than 21 and losses!"
        @winner = true
      elsif @dealer.count == 21 && @dealer.count > @player.count 
        puts game_summary
        puts "Dealer has Blackjack!"
        @winner = true
      end
    end
  end
end

################################

# Start Program
p "Would you like to play Blackjack? [y|n]"
play_cards = gets.chomp
if play_cards.downcase == "y"
  #Create Blackjack object
  bj = Blackjack.new
  bj.start_game
  bj.deal_cards(2)
  bj.get_player_hand
  bj.get_dealer_hand
  #puts bj.game_summary
  bj.check_scores
else
  puts "sorry - maybe next time"
end


