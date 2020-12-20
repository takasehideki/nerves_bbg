defmodule NervesBbg do
  @moduledoc """
  Documentation for NervesBbg.
  """

  @doc """
  Hello world.

  ## Examples

      iex> NervesBbg.hello
      :world

  """
  def hello do
    :world
  end

  @doc """
  Calculate Fibonacci number by recursive call.

  ## Examples

      iex> NervesBbg.fib(20)
      6765

  """
  def fib(0), do: 0
  def fib(1), do: 1
  def fib(n), do: fib(n-1) + fib(n-2)
end
