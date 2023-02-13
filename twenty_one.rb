# 2. Deal cards to player and dealer
# 3. Player turn: hit or stay
# - repeat until bust or "stay"
# 4. If player bust, dealer wins.
#   5. Dealer turn: hit or stay
# - repeat until total >= 17
#  ---do we see ONLY one card the entire time?
# 6. If dealer bust, player wins.
#   7. Compare cards and declare winner.

SUITS = ['H', 'D', 'S', 'C']
CARD_RANKS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

def prompt(message)
  puts "=> #{message}"
end

def display(message)
  puts "** #{message}"
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
  hand.select { |_, rank| rank == 'A' }.count.times do
    sum -= 10 if sum > 21
  end
  sum
end

def deal_card(deck, hand)
  hand << deck.pop
end

def busted?(hand)
  # if player > 21
  calculate_total(hand) > 21
  # if dealer hand is >= 17
end

def display_dealer_card(hand)
  "#{hand[0]} + [hidden card]"
end

player_cards = []
dealers_cards = []
deck = initialize_deck
deck = deck.shuffle

puts '---------Welcome to 21. You and the dealer begin the game with two cards each.---------'
deal_card(deck, player_cards)
deal_card(deck, dealers_cards)
deal_card(deck, player_cards)
deal_card(deck, dealers_cards)

display "Here is your hand: #{player_cards}"
display "Dealer's cards are: #{display_dealer_card(dealers_cards)}"

loop do
  display "Current hand total: #{calculate_total(player_cards)}"
  prompt 'hit or stay?'
  answer = gets.chomp

  deal_card(deck, player_cards)
  prompt player_cards

  display "Current hand total: #{calculate_total(player_cards)}"
  break if answer == 'stay' || busted?(player_cards)
end


if busted?(player_cards)
  display 'Busted! Dealer won.'
else
  display 'You chose to stay!'
end

loop do
  break if calculate_total(dealers_cards) >= 17
end

display 'Dealer busted. You win!'