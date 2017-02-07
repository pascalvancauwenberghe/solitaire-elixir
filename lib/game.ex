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
    { [] , tableaus , [] }
  end

  @spec tableaus(Solitaire.Game.t) :: [ Solitaire.Tableau.t]
  @doc "Returns the list of 7 tableaus in the game"
  def tableaus({_cards,tableaus,_foundations}=_game) do
    tableaus
  end

  defp create_tableaus(_deck) do
    for _tableau <- 1..7 do
      Solitaire.Tableau.new
    end
  end

end
