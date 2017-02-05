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

end
