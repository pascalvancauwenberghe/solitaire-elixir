 defmodule Solitaire.Tableau do
    @moduledoc """
  A tableau has zero or more cards with face down and one or more cards face up, arranged red/black with descending values

  ## Examples

      iex> tableau = Solitaire.Tableau.new
      iex> length(Solitaire.Tableau.down(tableau))
      0
      iex> length(Solitaire.Tableau.up(tableau))
      0

      iex> tableau = Solitaire.Tableau.new
      iex> |> Solitaire.Tableau.add([Solitaire.Cards.new(:hearts,12) ,
      iex>                          Solitaire.Cards.new(:diamonds,7) ,
      iex>                          Solitaire.Cards.new(:spades,1) ])
      iex> Solitaire.Tableau.down(tableau)
      [ {:diamonds,7} , {:spades,1} ]
      iex> Solitaire.Tableau.up(tableau)
      [ {:hearts,12} ]

  """

    @opaque tableau :: { [ Solitaire.Cards.t] , [ Solitaire.Cards.t] }
    @type t :: tableau

    @spec new :: Solitaire.Tableau.t
    @doc "Creates a new empty tableau"
    def new do
      make_consistent_tableau([] , [] )
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

    @spec add(Solitaire.Tableau.t , [ Solitaire.Cards.t]) :: Solitaire.Tableau.t
    @doc "Add a set of cards to the down pile. If no cards are turned up, the top down card is turned up"
    def add({down,up}=_tableau,cards) do
      make_consistent_tableau(down ++ cards , up )
    end

    defp make_consistent_tableau([hd|tl],[]) do
      { tl , [hd] }
    end  

    defp make_consistent_tableau(down,[hd|tl]) do
      { down , [hd|tl] }
    end  

    defp make_consistent_tableau([],up) do
      { [] , up }
    end  

    @spec can_drop?(Solitaire.Tableau.t , Solitaire.Cards.t) :: boolean
    @doc "Can drop Kings on an empty Tableau"
    def can_drop?({_down,[]},card) do
      Solitaire.Cards.value_of(card) == 13
    end

  end
  