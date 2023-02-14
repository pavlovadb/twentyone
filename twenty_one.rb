# frozen_string_literal: true

SUITS = %w[H D S C].freeze
CARD_RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze

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
  calculate_total(hand) > 21
end

def display_dealer_card(hand)
  "#{hand[0]} + [hidden card]"
end

def play_again?
  display '--------'
  prompt 'Do you want to play again? (y/n)'
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

def detect_winner(dealer_cards, player_cards)
  dealer_total = calculate_total(dealer_cards)
  player_total = calculate_total(player_cards)

  if player_total > 21
    'player bust'
  elsif dealer_total > 21
    'dealer bust'
  elsif dealer_total < player_total
    'player'
  elsif player_total < dealer_total
    'dealer'
  else
    'tie'
  end
end

def display_result(dealer_cards, player_cards)
  result = detect_winner(dealer_cards, player_cards)

  case result
  when 'player bust'
    display 'You busted! Dealer wins!'
  when 'dealer bust'
    display 'Dealer busted! You win!'
  when 'player'
    display 'You win!'
  when 'dealer'
    display 'Dealer wins!'
  when 'tie'
    display "It's a tie!"
  end
end
def hit_or_stay?(answer)
  %w[h s].include?(answer)
end

def deal_twice(deck, hand)
  2.times do
    deal_card(deck, hand)
  end
end

loop do
  display "---------This is Twenty-One. You and the dealer begin the game with two cards each.---------"

  player_cards = []
  dealers_cards = []
  deck = initialize_deck
  deck = deck.shuffle

  deal_twice(deck, dealers_cards)
  deal_twice(deck, player_cards)

  player_total = calculate_total(player_cards)
  dealer_total = calculate_total(dealers_cards)

  display "Here is your hand: #{player_cards}, for a total of #{player_total} "
  display "Dealer's cards are: #{display_dealer_card(dealers_cards)}"

  # player turn
  loop do
    answer = nil
    loop do
      prompt 'Do you want to [h]it or [s]tay?'
      answer = gets.chomp.downcase

      break if hit_or_stay?(answer)

      display "Must enter 'h' or 's'"
    end

    if answer == 'h'
      deal_card(deck, player_cards)
      player_total = calculate_total(player_cards)

      display 'You chose to hit'
      display "Here are your cards: #{player_cards}"

      display "Current hand total: #{player_total}"
    end

    break if answer == 's' || busted?(player_cards)
  end

  if busted?(player_cards)
    display 'Busted! Dealer won.'
    play_again? ? next : break
  else
    display 'You chose to stay!'
  end

  # dealer turn
  loop do
    break if calculate_total(dealers_cards) >= 17

    prompt "Dealer is hitting"
    sleep(1)

    deal_card(deck, dealers_cards)
    dealer_total = calculate_total(dealers_cards)
  end

  display "Dealer had #{dealers_cards}, their total was: #{dealer_total}"
  display "You had #{player_cards}, your total was: #{player_total}"

  puts '=============='
  display_result(dealers_cards, player_cards)
  puts '=============='

  break unless play_again?
end

display 'Bye.'
