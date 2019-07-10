defprotocol Readable do
  @moduledoc """
  Protocol which describes type convertion a -> b.
  Usually `@type a :: String.t()` but there is no
  any artificial restriction regarding type a.
  """

  @type t :: Readable.t()

  @doc """
  Accepts struct with field :data and type pair information in structure name
  and returns value of target type or raise exception.
  """
  @spec read(t) :: term
  def read(t)
end
