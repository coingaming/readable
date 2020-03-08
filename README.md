# Readable

Elixir language have standard `String.Chars` protocol which describes `T -> String` relation (like Haskell [Show](https://www.haskell.org/haddock/libraries/GHC.Show.html) type class). But Elixir don't have any standard protocol for `String -> T` relation (some equivalent of Haskell [Read](https://www.haskell.org/haddock/libraries/GHC.Read.html) type class). But I think such protocol completely make sense.

This protocol describes read relation between 2 types. Instance of type `B` can be read from instance of type `A`. Usually type `A = String`, but this implementation don't have this constraint.

<img src="priv/img/logo.png" width="300"/>

## Example

```elixir
import Read

defreadable Integer, from: x :: BitString do
  String.to_integer(x)
end

defreadable URI, from: x :: BitString do
  URI.parse(x)
end

defreadable NaiveDateTime, from: x :: Tuple do
  case NaiveDateTime.from_erl(x) do
    {:ok, y} -> y
    {:error, _} -> fail!(x)
  end
end
```

and then we can use implementation of `Read` type class

```elixir
iex> Read.read("123", Integer)
123

iex> Read.read("https://hello.world", URI)
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

iex> Read.read({{2000, 1, 1}, {13, 30, 15}}, NaiveDateTime)
~N[2000-01-01 13:30:15]

iex> Read.read({{2000, 13, 1}, {13, 30, 15}}, NaiveDateTime)
** (Readable.Exception) NaiveDateTime can not be read from {{2000, 13, 1}, {13, 30, 15}}

iex> Read.read("https://hello.world", TypeNotExist)
** (ArgumentError) argument error
    :erlang.binary_to_existing_atom("Elixir.Readable.From.BitString.To.TypeNotExist", :utf8)
    (elixir) src/elixir_aliases.erl:119: :elixir_aliases.safe_concat/1
    (readable) lib/read.ex:84: Read.read/2
```

Also there is strict macro version of helper which checks existence of target type in compile-time:

```elixir
iex> import Read
Read
iex> mk_read("123", Integer)
123
iex> mk_read("123", TypeNotExist)
** (UndefinedFunctionError) function TypeNotExist.__struct__/0 is undefined (module
 TypeNotExist is not available)
    TypeNotExist.__struct__()
    (typable 0.3.0) lib/typable.ex:94: Type.assert_exist!/1
    (readable 0.2.1) expanding macro: Read.mk_read/2
```

## Installation

The package can be installed by adding `readable` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:readable, "~> 0.3"}
  ]
end
```
