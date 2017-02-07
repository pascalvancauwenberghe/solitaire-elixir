defmodule Solitaire do
  @moduledoc """
  Documentation for Solitaire.


  """

  defmodule Cards do
    @moduledoc """
  A card has a suit and a value

  ## Examples

      iex> length(Solitaire.Cards.suits)
      4
      iex> length(Solitaire.Cards.values)
      13

  """
  
    @type suit :: :hearts | :diamonds | :spades | :clubs
    @type value :: non_neg_integer
    @type colour :: :red | :black
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

    @spec colour_of(card) :: colour
    @doc "Return the colour of the card"
    def colour_of({suit,_value}) do
      colour_of_suit(suit)
    end

    defp colour_of_suit(:hearts), do: :red
    defp colour_of_suit(:diamonds), do: :red
    defp colour_of_suit(:clubs), do: :black
    defp colour_of_suit(:spade), do: :black

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
  @moduledoc """
    A region contains a `Sudoku.Grid` and communicates results with neighbouring Regions 

    It implementes the `Sudoku.Notifyable` behaviour

      iex> deck = Solitaire.Deck.new
      iex> length(deck)
      52
      iex> Solitaire.Deck.shuffle(deck,1234) == deck
      false
      iex> Solitaire.Deck.shuffle(deck,1234) == Solitaire.Deck.shuffle(deck,1234)
      true
      iex> Solitaire.Deck.shuffle(deck,1234) == Solitaire.Deck.shuffle(deck,12345)
      false

  """
    
    @type t :: [ Cards.t ]

    @spec new :: Deck.t
    @doc "Create a deck of all possible cards"
    def new do
      for suit <- Cards.suits, value <- Solitaire.Cards.values do
        Cards.new(suit,value)
      end
    end

    @spec shuffle(Deck.t,integer) :: Deck.t
    @doc "Shuffle a Deck based on a key. If you use the same key, you get the same randomized Deck"
    def shuffle(deck,key) do
      :rand.seed(:exsplus, {1, 2, key})
      Enum.shuffle(deck)
    end

  end

end
