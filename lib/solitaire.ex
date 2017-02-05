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
  
    def suits do
      [:hearts, :diamonds, :spades, :clubs]
    end

    def values do
      Enum.to_list(1..13)
    end
  end

end
