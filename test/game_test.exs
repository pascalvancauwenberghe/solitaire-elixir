defmodule GameTest do
  use ExUnit.Case
  doctest Solitaire.Game

  alias Solitaire.Game, as: Game
#  alias Solitaire.Foundation, as: Foundation
  alias Solitaire.Tableau, as: Tableau
  alias Solitaire.Deck, as: Deck
#  alias Solitaire.Cards, as: Cards

  test "A new Game has 7 tableaus" do
    game = test_game()

    assert length(Game.tableaus(game)) == 7
  end

  test "A Game has 4 foundations" do
    game = test_game()

    assert length(Game.foundations(game)) == 4
  end

  test "A Game distributes deck cards over the tableaus" do
    game = test_game()

    assert length(Game.cards(game)) == (52 - 1 - 2 - 3 - 4 - 5 - 6 - 7)
    assert_tableau_has_cards(Game.tableaus(game),1)
  end

  defp assert_tableau_has_cards([],_number) do
    
  end

  defp assert_tableau_has_cards([tableau|rest],number_of_cards) do
    assert length(Tableau.down(tableau)) + length(Tableau.up(tableau)) == number_of_cards
    assert_tableau_has_cards(rest,number_of_cards+1)
  end

  test "A new game has a score of 0 == number of cards on foundations" do
    game = test_game()

    assert Game.score(game) == 0
  end

  defp test_game() do
    deck = Deck.shuffle(Deck.new,1234)
    Game.new(deck)
  end

end