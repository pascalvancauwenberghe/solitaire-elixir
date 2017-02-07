defmodule GameTest do
  use ExUnit.Case
  doctest Solitaire.Game

  alias Solitaire.Game, as: Game
#  alias Solitaire.Foundation, as: Foundation
#  alias Solitaire.Tableau, as: Tableau
  alias Solitaire.Deck, as: Deck
#  alias Solitaire.Cards, as: Cards

  test "A new Game has 7 tableaus" do
    deck = Deck.shuffle(Deck.new,1234)
    game = Game.new(deck)

    assert length(Game.tableaus(game)) == 7
  end

  test "A Game has 4 foundations" do
    deck = Deck.shuffle(Deck.new,1234)
    game = Game.new(deck)

    assert length(Game.foundations(game)) == 4
  end

end