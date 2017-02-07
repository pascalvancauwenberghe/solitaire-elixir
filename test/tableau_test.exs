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

  test "add a set of down cards to the tableau. The top down card is turned up" do
    tableau = Solitaire.Tableau.new
      |> Solitaire.Tableau.add([Solitaire.Cards.new(:hearts,12) ,
                                Solitaire.Cards.new(:diamonds,7) ,
                                Solitaire.Cards.new(:spades,1) ])

    assert Solitaire.Tableau.down(tableau) == [ Solitaire.Cards.new(:diamonds,7) , Solitaire.Cards.new(:spades,1) ]
    assert Solitaire.Tableau.up(tableau)   == [ Solitaire.Cards.new(:hearts,12) ]
  end

  test "When adding cards to a tableau with an up card, the up card is kept" do
    tableau = Solitaire.Tableau.new
      |> Solitaire.Tableau.add([Solitaire.Cards.new(:hearts,12) ,
                                Solitaire.Cards.new(:diamonds,7) ,
                                Solitaire.Cards.new(:spades,1) ])

    tableau = Solitaire.Tableau.add(tableau,[Solitaire.Cards.new(:clubs,5) ])

    assert Solitaire.Tableau.down(tableau) == [ Solitaire.Cards.new(:diamonds,7) , Solitaire.Cards.new(:spades,1),Solitaire.Cards.new(:clubs,5) ]
    assert Solitaire.Tableau.up(tableau)   == [ Solitaire.Cards.new(:hearts,12) ]
  end

end
