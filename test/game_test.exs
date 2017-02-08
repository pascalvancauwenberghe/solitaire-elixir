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

    Game.pretty_print(game)
  end

  test "Can move an Ace from a tableau to foundation" do
     game = test_game()

     moves = Game.possible_moves(game)
     IO.inspect moves
     assert length(moves) == 1
     assert moves == [{:tableau, 3, :foundation, 0}]
  end

  defp test_game() do
    deck = Deck.shuffle(Deck.new,1234)
    Game.new(deck)

    # This test game has the following structure
    # Deck: [clubs: 9, hearts: 7, hearts: 9, diamonds: 5, diamonds: 13, clubs: 10,
    #        spades: 1, clubs: 4, hearts: 1, diamonds: 7, diamonds: 12, diamonds: 4,
    #        diamonds: 9, hearts: 2, clubs: 5, diamonds: 10, diamonds: 3, hearts: 8,
    #        spades: 13, hearts: 5, hearts: 13, clubs: 2, hearts: 4, diamonds: 6]
    # Tableaus (down, up)
    # 0 => {[], [clubs: 8]}
    # 1 => {[spades: 6], [spades: 5]} 
    # 2 => {[spades: 7, clubs: 1], [clubs: 13]}
    # 3 => {[spades: 12, spades: 8, diamonds: 2], [diamonds: 1]}
    # 4 => {[clubs: 6, spades: 4, diamonds: 8, diamonds: 11], [hearts: 3]}
    # 5 => {[hearts: 10, hearts: 6, clubs: 7, hearts: 11, spades: 9], [spades: 10]}
    # 6 => {[spades: 11, spades: 3, clubs: 12, hearts: 12, clubs: 11, clubs: 3], [spades: 2]}
    # Foundations
    # 1 => []
    # 2 => []
    # 3 => []
    # 4 => []
  end

end