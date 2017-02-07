defmodule TableauTest do
  use ExUnit.Case
  doctest Solitaire.Tableau

  test "an empty tableau has no down cards" do
    tableau = Solitaire.Tableau.new

    assert length(Solitaire.Tableau.down(tableau)) == 0
  end

    test "an empty tableau has no up cards" do
    tableau = Solitaire.Tableau.new

    assert length(Solitaire.Tableau.up(tableau)) == 0
  end
end