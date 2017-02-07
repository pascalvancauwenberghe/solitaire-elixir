defmodule Solitaire do
  @moduledoc """
  Documentation for Solitaire.

  ## Examples

      iex> length(Solitaire.Cards.suits)
      4
      iex> length(Solitaire.Cards.values)
      13

  """

  defmodule Cards do
  
    @type suit :: :hearts | :diamonds | :spades | :clubs
    @type value :: Range.t(1,13)
    @type card :: { suit , value }
    @type t :: card

    @spec new(suit,value) :: card 
    @doc "Make a card with given suit and value"
    def new(suit,value) do
      { suit , value }
    end

    @spec suit_of(card) :: suit
    @doc "Returns suit part of card"
    def suit_of({suit,_value}) do
      suit
    end

    @spec value_of(card) :: value
    @doc "Returns value part of card"
    def value_of({_suit,value}) do
      value
    end

    @spec suits :: [ suit ]
    @doc "List of possible card suits"
    def suits do
      [:hearts, :diamonds, :spades, :clubs]
    end

    @spec values :: [ value ]
    @doc "List of possible card values"
    def values do
      Enum.to_list(1..13)
    end
  end

  defmodule Deck do
    
    @spec new :: [ Cards.t ]
    @doc "Create a deck of all possible cards"
    def new do
      for suit <- Cards.suits, value <- Solitaire.Cards.values do
        Cards.new(suit,value)
      end
    end

    def shuffle(deck,key) do
      :rand.seed(:exsplus, {1, 2, key})
      Enum.shuffle(deck)
    end

  end

end
