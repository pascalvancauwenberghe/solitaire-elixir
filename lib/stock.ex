 defmodule Solitaire.Stock do
    @moduledoc """
  A Stock has zero or more cards with face down and one or more cards face up, arranged red/black with descending values

  ## Examples

      iex> deck = Solitaire.Deck.new
      iex> stock = Solitaire.Stock.new(deck)
      iex> length(Solitaire.Stock.down(stock))
      52
      

  """

    @opaque stock :: { [ Solitaire.Cards.t] , [ Solitaire.Cards.t] }
    @type t :: stock

    @spec new(Solitaire.Deck.t) :: Solitaire.Stock.t
    @doc "Create a new stock with all cards in the deck initially down"
    def new(deck) do
      { deck , [] }
    end

    @spec down(Solitaire.Stock.t) :: [ Solitaire.Cards.t]
    @doc "Return the list of all down cards"
    def down({down,_up}), do: down

    @spec up(Solitaire.Stock.t) :: [ Solitaire.Cards.t]
    @doc "Return the list of all up cards"
    def up({_down,up}), do: up
end