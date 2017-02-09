defmodule TableauTest do
  use ExUnit.Case
  doctest Solitaire.Tableau

  alias Solitaire.Tableau, as: Tableau
  alias Solitaire.Cards, as: Cards

  test "an empty tableau has no down cards" do
    tableau = Tableau.new

    assert length(Tableau.down(tableau)) == 0
  end

  test "an empty tableau has no up cards" do
    tableau = Tableau.new

    assert length(Tableau.up(tableau)) == 0
  end

  test "add a set of down cards to the tableau. The top down card is turned up" do
    tableau = Tableau.new
      |> Tableau.add([Cards.new(:hearts,12) ,
                      Cards.new(:diamonds,7) ,
                      Cards.new(:spades,1) ])

    assert Tableau.down(tableau) == [ Cards.new(:diamonds,7) , Cards.new(:spades,1) ]
    assert Tableau.up(tableau)   == [ Cards.new(:hearts,12) ]
  end

  test "When adding cards to a tableau with an up card, the up card is kept" do
    tableau = Tableau.new
      |> Tableau.add([Cards.new(:hearts,12) ,
                      Cards.new(:diamonds,7) ,
                      Cards.new(:spades,1) ])

    tableau = Tableau.add(tableau,[Cards.new(:clubs,5) ])

    assert Tableau.down(tableau) == [ Cards.new(:diamonds,7) , Cards.new(:spades,1),Cards.new(:clubs,5) ]
    assert Tableau.up(tableau)   == [ Cards.new(:hearts,12) ]
  end

  test "Can drop a King on an empty tableau" do
    tableau = Tableau.new
    
    for suit <- Cards.suits do
      assert Tableau.can_drop?(tableau,Cards.new(suit,13))
    end
  end

  test "Can drop a cards on a non-empty tableau if it has a different colour and its value is one less than top up card" do
    tableau = Tableau.new
     |> Tableau.add([Cards.new(:hearts,12) ,
                     Cards.new(:diamonds,7) ,
                     Cards.new(:spades,1) ])

    assert Tableau.can_drop?(tableau,Cards.new(:clubs,11))
    assert Tableau.can_drop?(tableau,Cards.new(:spades,11))

    assert ! Tableau.can_drop?(tableau,Cards.new(:hearts,11))
    assert ! Tableau.can_drop?(tableau,Cards.new(:clubs,10))
    assert ! Tableau.can_drop?(tableau,Cards.new(:clubs,13))
  end

  test "When a King is dropped onto an empty tableau it becomes the top up card" do
    tableau = Tableau.new
    |> Tableau.drop(Cards.new(:spades,13))

    assert Tableau.up(tableau) == [Cards.new(:spades,13)]
    
  end

  test "When a cards is dropped onto an non-empty tableau it becomes the top up card" do
    tableau = Tableau.new
      |> Tableau.add([Cards.new(:hearts,12) ,
                      Cards.new(:diamonds,7) ,
                      Cards.new(:spades,1) ])
      |> Tableau.drop(Cards.new(:spades,11))

    assert Tableau.up(tableau) == [Cards.new(:spades,11),Cards.new(:hearts,12)]
    
  end

  test "An empty tableau has no bottom card" do
    tableau = Tableau.new
    assert  Tableau.bottom_card(tableau) == nil
  end

  test "An filled tableau has a bottom card: the lowest value visible card" do
    tableau = Tableau.new
     |> Tableau.add([Cards.new(:hearts,12) ,
                     Cards.new(:diamonds,7) ,
                     Cards.new(:spades,1) ])

    assert Tableau.bottom_card(tableau) == Cards.new(:hearts,12)
  end

  test "Taking a card from a Tableau turns the next card up" do
    tableau = Tableau.new
      |> Tableau.add([Cards.new(:hearts,12) ,
                      Cards.new(:diamonds,7) ,
                      Cards.new(:spades,1) ])

    tableau = Tableau.take(tableau)                           
    assert Tableau.bottom_card(tableau) == Cards.new(:diamonds,7)
  end

  test "A filled tableau has a top card: the highest visible card" do
    tableau = Tableau.new
     |> Tableau.add([Cards.new(:hearts,12) ,
                     Cards.new(:diamonds,7) ,
                     Cards.new(:spades,1) ])
     |> Tableau.drop(Cards.new(:spades, 11))

    assert Tableau.top_card(tableau) == Cards.new(:hearts,12)
    assert Tableau.bottom_card(tableau) == Cards.new(:spades,11)
  end

  test "An empty tableau has no top card" do
    tableau = Tableau.new
    assert  Tableau.top_card(tableau) == nil
  end

end
