defmodule HttpRequestParser do
  @moduledoc """
  Documentation for `HttpRequestParser`.
  """

  @doc """
  Assume the HTTP request is formed properly
  First line of the request is the start-line, there should be three words separated by spaces, the verb, path, and HTTP version (which we can ignore)
  ex:
  GET /index.php HTTP/1.1

  The next few lines are headers until a blank line is encountered
  Content-Type: text/html
  Host: php.net

  Anything after the head section is considered the body of the request
  """
  @spec parse(String.t()) :: Request.t()
  def parse(request_string) do
    [start_line | rest] =
      request_string
      |> String.split("\n")

    [method, path, _] = start_line |> String.split(" ")

    case rest |> Enum.chunk_by(fn x -> x != "" end) do
      [headers, _, [body]] ->
        %Request{
          method: method,
          path: path,
          body: body,
          headers: headers |> parse_headers()
        }

      [headers | _] ->
        %Request{
          method: method,
          path: path,
          headers: headers |> parse_headers(),
          body: ""
        }
    end
  end

  def parse_headers(["", ""]) do
    %{}
  end

  @spec parse_headers([String.t()]) :: %{optional(String.t()) => String.t()}
  def parse_headers(headers) do
    headers
    |> Stream.map(fn x -> x |> String.split(": ") end)
    |> Stream.map(fn [a, b] -> {a, b} end)
    |> Map.new()
  end
end
