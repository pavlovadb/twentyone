# 1. Initialize deck
#   -initialize constant variable of the 4 suits represented as strings in array (h, d, s, c)
#   -initialize constant variable of the card ranks represented as strings in an array (2-10, j, q, k, a)
#   - create a method that initializes the deck by:
#   - setting an empty array called new_deck
#   - loop through the suits array and loop through the card_ranks array and for each suit and each rank
#   add that to the new_deck array
#   - return new_deck
# 2. Deal cards to player and dealer
# 3. Player turn: hit or stay
# - repeat until bust or "stay"
# 4. If player bust, dealer wins.
#   5. Dealer turn: hit or stay
# - repeat until total >= 17
# 6. If dealer bust, player wins.
#   7. Compare cards and declare winner.

SUITS = ['H', 'D', 'S', 'C']
CARD_RANKS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

player_cards = [['H', 'A'], ['D', '9'], ['S', 'A']]
dealers_cards = []

def prompt(message)
  puts "=> #{message}"
end

def initialize_deck
  new_deck = []
  SUITS.each do |suit|
    CARD_RANKS.each do |rank|
      new_deck << [suit, rank]
    end
  end
  new_deck
end

# method takes in a hand of cards (nested array)
# for each array, check the second element (the rank)
#  convert the element to an integer to find its value
#   - for 2-10 the conversion gives the correct value
#   - for when the conversion returns 0 (j,q,k) set value to 10
#   - for ace value should be 1 for now

def find_hand_values(hand)
  hand.map do |_, rank|
    if rank.include?('A')
      11
    elsif rank.to_i.zero?
      10
    else
      rank.to_i
    end
  end
end

def calculate_total(hand)
  sum = find_hand_values(hand).sum

  # fixing calculation for aces - 10 (ace worth 1) for every time there's an ace in hand if the sum is less than 21
  hand.each { |_, rank| rank == 'A' }.count.times do
    sum -= 10 if sum > 21
  end
  sum
end


deck = initialize_deck



