defmodule GameTest do
  use ExUnit.Case, async: true
  doctest Solitaire.Game

  alias Solitaire.Game, as: Game
  alias Solitaire.Foundation, as: Foundation
  alias Solitaire.Tableau, as: Tableau
  alias Solitaire.Deck, as: Deck
  alias Solitaire.Cards, as: Cards

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

  test "Can move an Ace from a tableau to foundation" do
     game = test_game()

     moves = Game.possible_moves(game)

     assert length(moves) == 3
     assert List.first(moves) == {:tableau, 3, :foundation, 0, {:diamonds, 1}}
  end

  test "Move the Ace from tableau to foundation" do
     game = test_game()

     [move|_rest] = Game.possible_moves(game)
     game = Game.perform(game,move)

     first_foundation = List.first(Game.foundations(game))
     assert length(first_foundation) == 1
     assert List.first(Foundation.up(first_foundation)) == Cards.new(:diamonds,1)

     fourth_tableau = Enum.at(Game.tableaus(game),3)
     assert length(Tableau.down(fourth_tableau)) == 2
     assert Game.score(game) == 1
  end

  test "Can move cards between tableaus" do
     game = test_game()

     moves = Game.possible_moves(game)

     assert length(moves) == 3
     assert moves == [{:tableau, 3, :foundation, 0, {:diamonds, 1}}, # Ace of diamonds to empty foundation
                      {:tableau, 6, :tableau, 4, {:spades, 2}},      # 2 of spades to 3 of hearts
                      {:tableau, 3, :tableau, 6, {:diamonds, 1}}     # Ace of diamonds on 2 of spades
                     ] 
  end

  test "Move cards between tableaus" do
     game = test_game()

     moves = Game.possible_moves(game)
     spades2_to_hearts3 = Enum.at(moves,1)

     game = Game.perform(game,spades2_to_hearts3)

     fifth_tableau = Enum.at(Game.tableaus(game),4)
     seventh_tableau = Enum.at(Game.tableaus(game),6)

     assert length(Tableau.up(fifth_tableau)) == 2
     assert Tableau.bottom_card(seventh_tableau) == Cards.new(:spades,11)
  end

  test "Can move aces from deck to foundation" do
    game = test_game()
    moves = Game.possible_moves(game)

    game = Player.play(game,moves)

    assert length(Enum.at(Game.foundations(game),0)) == 1
    assert length(Enum.at(Game.foundations(game),1)) == 4
    assert length(Enum.at(Game.foundations(game),2)) == 5
  end

  test "Game doesn't get in loop moving cards back and forth between piles" do
    deck = Deck.shuffle(Deck.new,1)
    game = Game.new(deck)
    moves = Game.possible_moves(game)
    game = Player.play(game,moves)

    score = Game.score(game)
    assert score == 9
  end

  test "A game stays valid when making moves" do
    deck = Deck.shuffle(Deck.new,1)
    game = Game.new(deck)

    errors = Game.Debug.validate(game)
    assert errors == []

    moves = Game.possible_moves(game)
    game = Player.play(game,moves)

    errors = Game.Debug.validate(game)
    assert errors == []
  end

  test "Detect tableau mismatches" do
    deck = Deck.shuffle(Deck.new,1)
    game = Game.new(deck)

    game = Game.perform(game,{:deck , 0, :tableau, 0, {Cards.new(:diamonds,3)}})
    game = Game.turn(game)
    game = Game.perform(game,{:deck , 0, :tableau, 3, {Cards.new(:hearts,1)}})

    errors = Game.Debug.validate(game)
    assert errors == [{:tableau_mismatch, 0, Cards.new(:diamonds, 3), Cards.new(:diamonds, 1) },
                      {:tableau_mismatch, 3, Cards.new(:hearts, 1),   Cards.new(:spades, 1)}]
  end

  test "Detect foundation mismatches" do
    deck = Deck.shuffle(Deck.new,1)
    game = Game.new(deck)

    game = Game.turn(game)
    game = Game.perform(game,{:deck , 0, :foundation, 0, {Cards.new(:hearts,1)}})
    game = Game.perform(game,{:deck , 0, :foundation, 0, {Cards.new(:diamonds,3)}})

    errors = Game.Debug.validate(game)
    assert errors == [{:foundation_mismatch, 0, Cards.new(:diamonds, 3), Cards.new(:hearts, 1) }]
  end

  test "Detect foundations not built on ace" do
    deck = Deck.shuffle(Deck.new,1)
    game = Game.new(deck)

    game = Game.turn(game)
    game = Game.perform(game,{:deck , 0, :foundation, 0, {Cards.new(:hearts,1)}})
    game = Game.perform(game,{:deck , 0, :foundation, 1, {Cards.new(:diamonds,3)}})

    errors = Game.Debug.validate(game)
    assert errors == [{:foundation_base_mismatch, 1, Cards.new(:diamonds, 3), nil }]
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