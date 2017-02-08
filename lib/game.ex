defmodule Solitaire.Game do
  @moduledoc """
  A Solitaire Game

  ## Examples

      iex> deck = Solitaire.Deck.shuffle(Solitaire.Deck.new,1234)
      iex> game = Solitaire.Game.new(deck)
      iex> length(Solitaire.Game.tableaus(game))
      7



  """

  alias Solitaire.Game, as: Game
  alias Solitaire.Foundation, as: Foundation
  alias Solitaire.Tableau, as: Tableau
  alias Solitaire.Stock, as: Stock
  alias Solitaire.Deck, as: Deck
  alias Solitaire.Cards, as: Cards


  @opaque game :: { Stock.t  , [ Tableau.t] , [ Foundation.t ] }
  @type t :: game

  @type from_location :: :tableau | :foundation | :deck
  @type to_location :: :tableau | :foundation 
  @type move :: {from_location , non_neg_integer , to_location , non_neg_integer}

  @spec new(Deck.t) :: Game.t
  @doc "Create a new empty Game"
  def new(deck) do
    tableaus = create_tableaus(deck)
    foundations = create_foundations()
    deck = Enum.drop(deck,1+2+3+4+5+6+7)
    { Stock.turn(Stock.new(deck)) , tableaus , foundations }
  end
  
  @spec cards(Game.t) :: [ Cards.t]
  @doc "Returns the remaining cards in the game"
  def cards({stock,_tableaus,_foundations}=_game) do
    Stock.cards(stock)
  end

  @spec exhausted?(Game.t) :: boolean
  @doc "Returns whether stock is exhausted"
  def exhausted?({stock,_tableaus,_foundations}=_game) do
    Stock.exhausted?(stock)
  end

  @spec turn(Game.t) :: Game.t
  @doc "Turns over one card from down to up pile"
  def turn({stock,tableaus,foundations}=_game) do
    { Stock.turn(stock),tableaus,foundations }
  end

  @spec tableaus(Game.t) :: [ Tableau.t]
  @doc "Returns the list of 7 tableaus in the game"
  def tableaus({_stock,tableaus,_foundations}=_game) do
    tableaus
  end

  @spec foundations(Game.t) :: [ Foundation.t]
  @doc "Returns the list of 4 foundations in the game"
  def foundations({_stock,_tableaus,foundations}=_game) do
    foundations
  end

  defp create_tableaus(deck) do
    tableaus = for _tableau <- 1..7 do
      Tableau.new
    end

    distribute_cards(tableaus,deck,1)
  end

  defp distribute_cards([],_deck,_number) do
    []
  end

  defp distribute_cards([hd|tl],deck,number) do
    [ Tableau.add(hd,Enum.take(deck,number)) | distribute_cards(tl,Enum.drop(deck,number),number+1) ]
  end

  defp create_foundations() do
    for _foundation <- 1..4 do
      Foundation.new
    end
  end

  @spec pretty_print(Game.t) :: :ok
  @doc "Prints a readable version of the game"
  def pretty_print({stock,tableaus,foundations}) do
    IO.puts ""
    IO.inspect stock
    IO.puts "Tableaus"
    Enum.each(tableaus,fn(tableau) -> IO.inspect(tableau) end)
    IO.puts "Foundations"
    Enum.each(foundations,fn(foundation) -> IO.inspect(foundation) end)
  end

  @spec score(Game.t) :: non_neg_integer
  @doc "Calculate score of game == number of cards moved onto foundations"
  def score({_stock,_tableaus,foundations}) do
    Enum.reduce(foundations,0,fn(foundation,score) -> score + length(foundation) end)
  end

  @spec possible_moves(Game.t) :: [ Game.move ] 
  @doc "Returns a list of possible moves in the game as { from , from_index , to , to_index}"
  def possible_moves({stock,tableaus,foundations}) do
    solutions = find_moves_from_tableaus_to_foundations(tableaus,foundations) ++
    find_moves_from_deck_to_foundations(Stock.top_card(stock),foundations) ++
    find_moves_between_tableaus(tableaus) ++
    find_moves_from_deck_to_tableaus(Stock.top_card(stock),tableaus)
    Enum.filter(solutions,&(&1 != nil))
  end

  defp find_moves_from_tableaus_to_foundations(tableaus,foundations) do
    tableau_cards = bottom_cards_of_tableaus(tableaus)
    move_cards_to_foundation(tableau_cards,foundations)
  end

  defp bottom_cards_of_tableaus(tableaus) do
    cards = for tableau <- 0..6 do
      { tableau , Tableau.bottom_card(Enum.at(tableaus,tableau)) }
    end
    Enum.filter(cards,fn({_index,card}) -> card != nil end)
  end

  defp move_cards_to_foundation(cards,foundations) do
    for {index,card} <- cards do
      foundation = Enum.find_index(foundations,fn(foundation) -> Foundation.can_drop?(foundation,card) end)
      if foundation != nil, do: { :tableau , index , :foundation , foundation }, else: nil
    end
  end

  defp find_moves_between_tableaus(tableaus) do
    tableau_cards = bottom_cards_of_tableaus(tableaus)
    move_cards_to_tableau(tableau_cards,tableaus)
  end

  defp move_cards_to_tableau(cards,tableaus) do
    for {index,card} <- cards , tableau_index <- 0..6 do
      tableau = Enum.at(tableaus,tableau_index)
      if Tableau.can_drop?(tableau,card), do: { :tableau , index , :tableau , tableau_index }, else: nil
    end
  end

  defp find_moves_from_deck_to_foundations(nil,_foundations), do: []

  defp find_moves_from_deck_to_foundations(card,foundations) do
    foundation = Enum.find_index(foundations,fn(foundation) -> Foundation.can_drop?(foundation,card) end)
    if foundation != nil, do: [{ :deck , 0 , :foundation , foundation }], else: []
  end

  defp find_moves_from_deck_to_tableaus(nil,_tableaus), do: []

  defp find_moves_from_deck_to_tableaus(card,tableaus) do
    for tableau_index <- 0..6 do
     tableau = Enum.at(tableaus,tableau_index)
     if Tableau.can_drop?(tableau,card), do: { :deck , 0 , :tableau , tableau_index }, else: nil
    end
  end

  @spec perform(Game.t,Game.move) :: Game.t
  @doc "Perform the given move on the game"
  def perform({stock,tableaus,foundations},{:tableau , tableau_index, :foundation, foundation_index}) do
    tableau = Enum.at(tableaus,tableau_index)
    card = Tableau.bottom_card(tableau)
    tableaus = List.replace_at(tableaus,tableau_index,Tableau.take(tableau))
    foundation = Enum.at(foundations,foundation_index)
    foundations = List.replace_at(foundations,foundation_index,Foundation.drop(foundation,card))
    {stock,tableaus,foundations}
  end

  def perform({stock,tableaus,foundations},{:tableau , from_tableau_index, :tableau, to_tableau_index}) do
    tableau = Enum.at(tableaus,from_tableau_index)
    card = Tableau.bottom_card(tableau)
    tableaus = List.replace_at(tableaus,from_tableau_index,Tableau.take(tableau))

    tableau = Enum.at(tableaus,to_tableau_index)
    tableaus = List.replace_at(tableaus,to_tableau_index,Tableau.drop(tableau,card))
    
    {stock,tableaus,foundations}
  end

  def perform({stock,tableaus,foundations},{:deck , _, :foundation, foundation_index}) do
    card = Stock.top_card(stock)
    stock = Stock.take(stock)
    foundation = Enum.at(foundations,foundation_index)
    foundations = List.replace_at(foundations,foundation_index,Foundation.drop(foundation,card))
    {stock,tableaus,foundations}
  end

  def perform({stock,tableaus,foundations},{:deck , _, :tableau, to_tableau_index}) do
    card = Stock.top_card(stock)
    stock = Stock.take(stock)

    tableau = Enum.at(tableaus,to_tableau_index)
    tableaus = List.replace_at(tableaus,to_tableau_index,Tableau.drop(tableau,card))
    
    {stock,tableaus,foundations}
  end

end
