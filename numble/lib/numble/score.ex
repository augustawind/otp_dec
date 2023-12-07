defmodule Numble.Score do
  @type t :: %__MODULE__{
          red: non_neg_integer(),
          white: non_neg_integer()
        }

  @type row :: list(piece())
  @type piece :: 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8

  defstruct red: 0, white: 0

  @spec new(row(), row()) :: t()
  def new(answer, guess) do
    for {answer_item, guess_item} <- Enum.zip(answer, guess),
        reduce: struct(__MODULE__) do
      score ->
        cond do
          guess_item == answer_item ->
            %{score | red: score.red + 1}

          answer_item in guess ->
            %{score | white: score.white + 1}

          true ->
            score
        end
    end
  end

  @spec new_with_duplicates(row(), row()) :: t()
  def new_with_duplicates(answer, guess) do
    reds =
      Enum.zip(answer, guess)
      |> Enum.count(fn {a, g} -> a == g end)

    blacks =
      Enum.count(guess -- answer)

    whites =
      4 - reds - blacks

    __struct__(red: reds, white: whites)
  end

  @spec show(t()) :: String.t()
  def show(%__MODULE__{red: reds, white: whites}) do
    String.duplicate("R", reds) <> String.duplicate("W", whites)
  end
end
