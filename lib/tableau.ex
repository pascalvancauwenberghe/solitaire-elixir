 defmodule Solitaire.Tableau do
    @moduledoc """
  A tableau has zero or more cards with face down and one or more cards face up, arranged red/black with descending values

  ## Examples

      iex> tableau = Solitaire.Tableau.new
      iex> length(Solitaire.Tableau.down(tableau))
      0
      iex> length(Solitaire.Tableau.up(tableau))
      0

  """

    @opaque tableau :: { [ Solitaire.Cards.t] , [ Solitaire.Cards.t] }
    @type t :: tableau

    @spec new :: Solitaire.Tableau.t
    @doc "Creates a new empty tableau"
    def new do
      {[] , [] }
    end

    @spec down(Solitaire.Tableau.t) :: [ Solitaire.Cards.t]
    @doc "Returns the pile of down cards in the tableau"
    def down(tableau) do
      down_of(tableau)
    end

    defp down_of({down,_up}) do
      down
    end

    @spec up(Solitaire.Tableau.t) :: [ Solitaire.Cards.t]
    @doc "Returns the pile of up cards in the tableau"
    def up(tableau) do
      up_of(tableau)
    end

    defp up_of({_down,up}) do
      up
    end

  end
  