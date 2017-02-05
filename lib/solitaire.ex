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
