defmodule Solitaire.Game.Debug do
  @moduledoc """
  Debugging utilities for Solitaire Game

  ## Examples

"""

  alias Solitaire.Game, as: Game

  @spec pretty_print(Game.t) :: :ok
  @doc "Prints a readable version of the game"
  def pretty_print(game) do
    IO.inspect Game.cards(game)
    IO.puts "Tableaus"
    Enum.each(Game.tableaus(game),fn(tableau) -> IO.inspect(tableau) end)
    IO.puts "Foundations"
    Enum.each(Game.foundations(game),fn(foundation) -> IO.inspect(foundation) end)
  end
end
