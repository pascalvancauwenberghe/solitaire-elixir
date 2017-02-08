defmodule Solitaire.Game do
  @moduledoc """
  A Solitaire Game

  ## Examples

      iex> deck = Solitaire.Deck.shuffle(Solitaire.Deck.new,1234)
      iex> game = Solitaire.Game.new(deck)
      iex> length(Solitaire.Game.tableaus(game))
      7



  """

  @opaque game :: { [ Solitaire.Cards.t ] , [ Solitaire.Tableau.t] , [ Solitaire.Foundation.t ] }
  @type t :: game

  @spec new(Solitaire.Deck.t) :: Solitaire.Game.t
  @doc "Create a new empty Game"
  def new(deck) do
    tableaus = create_tableaus(deck)
    foundations = create_foundations()
    deck = Enum.drop(deck,1+2+3+4+5+6+7)
    { deck , tableaus , foundations }
  end
  
  @spec cards(Solitaire.Game.t) :: [ Solitaire.Cards.t]
  @doc "Returns the remaining cards in the game"
  def cards({cards,_tableaus,_foundations}=_game) do
    cards
  end

  @spec tableaus(Solitaire.Game.t) :: [ Solitaire.Tableau.t]
  @doc "Returns the list of 7 tableaus in the game"
  def tableaus({_cards,tableaus,_foundations}=_game) do
    tableaus
  end

  @spec foundations(Solitaire.Game.t) :: [ Solitaire.Foundation.t]
  @doc "Returns the list of 4 foundations in the game"
  def foundations({_cards,_tableaus,foundations}=_game) do
    foundations
  end

  defp create_tableaus(deck) do
    tableaus = for _tableau <- 1..7 do
      Solitaire.Tableau.new
    end

    distribute_cards(tableaus,deck,1)
  end

  defp distribute_cards([],_deck,_number) do
    []
  end

  defp distribute_cards([hd|tl],deck,number) do
    [ Solitaire.Tableau.add(hd,Enum.take(deck,number)) | distribute_cards(tl,Enum.drop(deck,number),number+1) ]
  end

  defp create_foundations() do
    for _foundation <- 1..4 do
      Solitaire.Foundation.new
    end
  end

  def pretty_print({cards,tableaus,foundations}) do
    IO.puts ""
    IO.inspect cards
    IO.puts "Tableaus"
    Enum.each(tableaus,fn(tableau) -> IO.inspect(tableau) end)
    IO.puts "Foundations"
    Enum.each(foundations,fn(foundation) -> IO.inspect(foundation) end)
  end

  def score({_cards,_tableaus,foundations}) do
    Enum.reduce(foundations,0,fn(foundation,score) -> score + length(foundation) end)
  end

  def possible_moves({_cards,tableaus,foundations}) do
    solutions = find_moves_from_tableaus_to_foundations(tableaus,foundations)
    Enum.filter(solutions,&(&1 != nil))
  end

  defp find_moves_from_tableaus_to_foundations(tableaus,foundations) do
    tableau_cards = bottom_cards_of_tableaus(tableaus)
    move_cards_to_foundation(tableau_cards,foundations)
  end

  defp bottom_cards_of_tableaus(tableaus) do
    cards = for tableau <- 0..6 do
      { tableau , Solitaire.Tableau.bottom_card(Enum.at(tableaus,tableau)) }
    end
    Enum.filter(cards,fn({_index,card}) -> card != nil end)
  end

  defp move_cards_to_foundation(cards,foundations) do
    for {index,card} <- cards do
      foundation = Enum.find_index(foundations,fn(foundation) -> Solitaire.Foundation.can_drop?(foundation,card) end)
      if foundation != nil, do: { :tableau , index , :foundation , foundation }, else: nil
    end
  end

end
