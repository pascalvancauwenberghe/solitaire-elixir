defmodule Solitaire.Foundation do
  @moduledoc """
  A Foundation has zero or more cards facing up with the same suit and increasing values

  ## Examples

      iex> foundation = Solitaire.Foundation.new
      iex> length(Solitaire.Foundation.up(foundation))
      0


  """

  @opaque foundation :: [ Solitaire.Cards.t ]
  @type t :: foundation

  @spec new :: Solitaire.Foundation.t
  @doc "Create a new empty Foundation"
  def new do
    []
  end

  @spec up(Solitaire.Foundation.t) :: [ Solitaire.Cards.t ]
  @doc "The list of up cards in the Foundation"
  def up(foundation) do
    foundation
  end

end
