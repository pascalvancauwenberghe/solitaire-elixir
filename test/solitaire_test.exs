defmodule SolitaireTest do
  use ExUnit.Case
  doctest Solitaire.Cards
  doctest Solitaire.Deck

  test "there are four suits" do
    assert length(Solitaire.Cards.suits) == 4
  end

  test "there are 13 values" do
    assert length(Solitaire.Cards.values) == 13
  end

  test "create some cards" do
    card = Solitaire.Cards.new(:hearts,12)

    assert Solitaire.Cards.suit_of(card) == :hearts
    assert Solitaire.Cards.value_of(card) == 12
  end

  test "A suit has a colour" do
    assert Solitaire.Cards.colour_of(Solitaire.Cards.new(:hearts,1)) == :red
  end
  
  test "A deck of cards contains 52 cards" do
    deck = Solitaire.Deck.new

    assert length(deck) == 52
  end

  test "A deck can be shuffled deterministically" do
    
    deck = Solitaire.Deck.new

    assert Solitaire.Deck.shuffle(deck,12345) == Solitaire.Deck.shuffle(deck,12345)
    assert Solitaire.Deck.shuffle(deck,12345) != Solitaire.Deck.shuffle(deck,12346)
  end
end
 