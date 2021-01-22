defmodule Request do
  @type t() :: %__MODULE__{
          method: String.t(),
          path: String.t(),
          body: String.t(),
          headers: %{optional(String.t()) => String.t()}
        }

  defstruct [:method, :path, :body, :headers]
end
