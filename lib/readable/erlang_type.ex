import Read

defreadable Atom, from: x :: BitString do
  x
  |> String.to_existing_atom()
end

defreadable BitString, from: x :: BitString do
  x
end

defreadable Float, from: x :: BitString do
  x
  |> String.to_float()
end

defreadable Integer, from: x :: BitString do
  x
  |> String.to_integer()
end

defreadable PID, from: x :: BitString do
  x
  |> :erlang.binary_to_list()
  |> :erlang.list_to_pid()
end

defreadable Port, from: x :: BitString do
  x
  |> :erlang.binary_to_list()
  |> :erlang.list_to_port()
end

defreadable Reference, from: x :: BitString do
  x
  |> :erlang.binary_to_list()
  |> :erlang.list_to_ref()
end
