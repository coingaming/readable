defmodule Read do
  @moduledoc """
  Provides utilities to implement and work with `Readable` types
  """

  @doc """
  Helper to define readable relation for pair of types.
  Accepts:
  - target type which we want to read
  - source arg `expression :: type` pair
  - block of code where relation is described

  ## Examples

  ```
  iex> quote do
  ...>   import Read
  ...>   defreadable URI, from: x :: BitString do
  ...>     URI.parse(x)
  ...>   end
  ...> end
  ...> |> Code.compile_quoted
  iex> import Read
  iex> read("https://hello.world", URI)
  %URI{
    authority: "hello.world",
    fragment: nil,
    host: "hello.world",
    path: nil,
    port: 443,
    query: nil,
    scheme: "https",
    userinfo: nil
  }
  ```
  """
  defmacro defreadable(
             quoted_to_type,
             [from: {:"::", _, [quoted_from_expression, quoted_from_type]}],
             do: code
           ) do
    {to_type, []} = Code.eval_quoted(quoted_to_type, [], __CALLER__)
    {from_type, []} = Code.eval_quoted(quoted_from_type, [], __CALLER__)
    :ok = Type.assert_exist!(to_type)
    :ok = Type.assert_exist!(from_type)

    type =
      [Readable, From, from_type, To, to_type]
      |> Module.concat()

    quote do
      defmodule unquote(type) do
        @enforce_keys [:data]
        defstruct @enforce_keys
      end

      defimpl Readable, for: unquote(type) do
        def read(%unquote(type){data: unquote(quoted_from_expression)}) do
          unquote(code)
        end
      end
    end
  end

  @doc """
  Helper to read expression into given type

  ## Examples

  ```
  iex> Read.read("1", Integer)
  1
  ```
  """
  def read(from_expression, to_type) do
    type =
      [
        Readable,
        From,
        Type.type_of(from_expression),
        To,
        to_type
      ]
      |> Module.safe_concat()

    %{__struct__: type, data: from_expression}
    |> Readable.read()
  end
end