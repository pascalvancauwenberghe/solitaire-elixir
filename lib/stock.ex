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
    def down({down,_up}=_stock), do: down

    @spec up(Solitaire.Stock.t) :: [ Solitaire.Cards.t]
    @doc "Return the list of all up cards"
    def up({_down,up}=_stock), do: up

    @spec turn(Solitaire.Stock.t) :: Solitaire.Stock.t
    @doc "Turn over one card from down to up pile"
    def turn({[hd|tl],up}=_stock) do
      {tl , [hd | up] }
    end

    @spec exhausted?(Solitaire.Stock.t) :: boolean
    @doc "Stock is exhausted when there are no more down cards"
    def exhausted?({down,_up}=_stock) do
      length(down) == 0
    end

    @spec cards(Solitaire.Stock.t) :: [ Solitaire.Cards.t]
    @doc "Returns the list of all down and up cards"
    def cards({down,up}=_stock), do: down ++ up

    @spec top_card(Solitaire.Stock.t) :: Solitaire.Cards.t | nil
    @doc "Returns the top up card, if any. Else nil"
    def top_card({_down,[]}), do: nil

    def top_card({_down,[hd|_tl]}), do: hd

    @spec take(Solitaire.Stock.t) :: Solitaire.Stock.t
    @doc "Take the top up card away, if any"
    def take({down,[]}), do: {down,[]}

    def take({down,[_hd|tl]}), do: {down,tl}
end
