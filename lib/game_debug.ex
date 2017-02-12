defmodule Solitaire.Game.Debug do
  @moduledoc """
  Debugging utilities for Solitaire Game

  ## Examples

"""

  alias Solitaire.Game, as: Game
  alias Solitaire.Foundation, as: Foundation
  alias Solitaire.Tableau, as: Tableau
  alias Solitaire.Cards, as: Cards

  
  @typedoc "A game can be invalid because 1) cards on tableau are in wrong order/colour 2) cards on foundation are in wrong order/colour or 3) foundation doesn't start with ace'"
  @type error_type :: :tableau_mismatch | :foundation_mismatch | :foundation_base_mismatch
  @type validation_error :: { error_type , non_neg_integer , Cards.t , Cards.t | nil }


  @spec pretty_print(Game.t) :: :ok
  @doc "Prints a readable version of the game"
  def pretty_print(game) do
    IO.inspect Game.cards(game)
    IO.puts "Tableaus"
    Enum.each(Game.tableaus(game),fn(tableau) -> IO.inspect(tableau) end)
    IO.puts "Foundations"
    Enum.each(Game.foundations(game),fn(foundation) -> IO.inspect(foundation) end)
  end

  @spec validate(Game.t) :: [ validation_error ] 
  @doc "Validates that the game follows solitaire rules. Returns list of found errors"
  def validate(game) do
    tableaus = Game.tableaus(game)
    foundations = Game.foundations(game)
    validate_tableaus(tableaus,0) ++ validate_foundations(foundations,0) ++ validate_foundation_starts_with_ace(foundations,0)
  end

  @spec validate_foundation_starts_with_ace([Foundation.t],non_neg_integer) :: [validation_error]
  defp validate_foundation_starts_with_ace([],_index), do: []

  defp validate_foundation_starts_with_ace([foundation|tl],index) do
    starts_with_ace(Foundation.up(foundation),index) ++ validate_foundation_starts_with_ace(tl,index+1)
  end

  @spec starts_with_ace([Cards.t],non_neg_integer) :: [ validation_error ]
  defp starts_with_ace([],_index), do: []

  defp starts_with_ace([_ht|_tl]=cards,index) do
    card = List.last(cards)
    if Cards.value_of(card) == 1, do: [] , else: [{:foundation_base_mismatch , index, card, nil} ]
  end

  @spec validate_foundations([Foundation.t],non_neg_integer) :: [validation_error]
  defp validate_foundations([],_index), do: []

  defp validate_foundations([foundation|tl],index) do
    validate_foundation(Foundation.up(foundation),index) ++ validate_foundations(tl,index+1)
  end

  @spec validate_foundation([Cards.t],non_neg_integer) :: [validation_error]
  defp validate_foundation([],_index), do: []

  defp validate_foundation([card|tl],index) do
    same_colour_increasing(card,tl,index)
  end

  @spec same_colour_increasing(Cards.t,[Cards.t],non_neg_integer) :: [validation_error]
  defp same_colour_increasing(_card,[],_index), do: []

  defp same_colour_increasing(card,[hd|tl],index) do
    if Cards.colour_of(card) == Cards.colour_of(hd) &&
       Cards.value_of(card) == Cards.value_of(hd) + 1 do
      same_colour_increasing(hd,tl,index)
    else
      [ {:foundation_mismatch, index, card, hd } ]
    end
  end

  @spec validate_tableaus([Tableau.t],non_neg_integer) :: [ validation_error ] 
  defp validate_tableaus([],_index), do: []

  defp validate_tableaus([hd|tl],index), do: validate_tableau(Tableau.up(hd),index) ++ validate_tableaus(tl,index+1)

  @spec validate_tableau([Cards.t],non_neg_integer) :: [ validation_error ] 
  defp validate_tableau([],_index), do: []
    
  defp validate_tableau([card|tl],index) do
    alternating_descending(card,tl,index)
  end

  @spec alternating_descending(Cards.t,[Cards.t],non_neg_integer) :: [ validation_error ] 
  defp alternating_descending(_card,[],_index), do: []

  defp alternating_descending(card,[hd|tl],index) do
    if Cards.colour_of(card) != Cards.colour_of(hd) &&
       Cards.value_of(card) + 1 == Cards.value_of(hd) do
      alternating_descending(hd,tl,index)
    else
      [ {:tableau_mismatch, index, card, hd } ]
    end
  end
  
end
