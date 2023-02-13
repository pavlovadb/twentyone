

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
  calculate_total(hand) > 21
end

def display_dealer_card(hand)
  "#{hand[0]} + [hidden card]"
end

def play_again?
  display '--------'
  prompt 'Do you want to play agian? (y/n)'
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

loop do
  puts '---------This is Twenty-One. You and the dealer begin the game with two cards each.---------'

  player_cards = []
  dealers_cards = []
  deck = initialize_deck
  deck = deck.shuffle

  deal_card(deck, player_cards)
  deal_card(deck, dealers_cards)
  deal_card(deck, player_cards)
  deal_card(deck, dealers_cards)

  display "Here is your hand: #{player_cards}, for a total of #{calculate_total(player_cards)} "
  display "Dealer's cards are: #{display_dealer_card(dealers_cards)}"

  # player turn
  loop do
    answer = nil
    loop do
      prompt '[h]it or [s]tay?'
      answer = gets.chomp.downcase
      break if %w[h s].include?(answer)

      display "Must enter 'h' or 's'"
    end

    if answer == 'h'
      deal_card(deck, player_cards)
      display 'You chose to hit'
      display "Here are your cards: #{player_cards}"
      display "Current hand total: #{calculate_total(player_cards)}"
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

    prompt "It's the dealers turn"
    sleep(1)

    deal_card(deck, dealers_cards)
    puts "test dealers cards just for me: #{dealers_cards}"
  end

  display "Dealers total was: #{calculate_total(dealers_cards)}"
  display "Your total was: #{calculate_total(player_cards)}"

  break unless play_again?
end
