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

  test "Can drop a King on an empty tableau" do
    tableau = Solitaire.Tableau.new
    
    for suit <- Solitaire.Cards.suits do
      assert Solitaire.Tableau.can_drop?(tableau,Solitaire.Cards.new(suit,13))
    end
  end

  test "Can drop a cards on a non-empty tableau if it has a different colour and its value is one less than top up card" do
    tableau = Solitaire.Tableau.new
     |> Solitaire.Tableau.add([Solitaire.Cards.new(:hearts,12) ,
                                Solitaire.Cards.new(:diamonds,7) ,
                                Solitaire.Cards.new(:spades,1) ])

    assert Solitaire.Tableau.can_drop?(tableau,Solitaire.Cards.new(:clubs,11))
    assert Solitaire.Tableau.can_drop?(tableau,Solitaire.Cards.new(:spades,11))

    assert ! Solitaire.Tableau.can_drop?(tableau,Solitaire.Cards.new(:hearts,11))
    assert ! Solitaire.Tableau.can_drop?(tableau,Solitaire.Cards.new(:clubs,10))
    assert ! Solitaire.Tableau.can_drop?(tableau,Solitaire.Cards.new(:clubs,13))
  end

  test "When a King is dropped onto an empty tableau it becomes the top up card" do
    tableau = Solitaire.Tableau.new
    |> Solitaire.Tableau.drop(Solitaire.Cards.new(:spades,13))

    assert Solitaire.Tableau.up(tableau) == [Solitaire.Cards.new(:spades,13)]
    
  end

  test "When a cards is dropped onto an non-empty tableau it becomes the top up card" do
    tableau = Solitaire.Tableau.new
      |> Solitaire.Tableau.add([Solitaire.Cards.new(:hearts,12) ,
                                Solitaire.Cards.new(:diamonds,7) ,
                                Solitaire.Cards.new(:spades,1) ])
      |> Solitaire.Tableau.drop(Solitaire.Cards.new(:spades,11))

    assert Solitaire.Tableau.up(tableau) == [Solitaire.Cards.new(:spades,11),Solitaire.Cards.new(:hearts,12)]
    
  end
end
