defmodule Txtshr do
  @moduledoc """
  Txtshr keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def random_string(), do: Enum.random(10000..99999) |> Integer.to_string()
end
