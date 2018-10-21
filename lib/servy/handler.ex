defmodule Servy.Handler do
  @moduledoc """
  By Hany
  """

  @doc """
    handle is the main def
  """
  def handle(request) do
    request # send as a first parameter to the next pipe
    |> parse # the result of this def send as a first parameter to the next pipe
    |> log
    |> route # the result of this def send as a first parameter to the next pipe
    |> format_response # last line returned by default
  end

  def log(conv), do: IO.inspect conv  # short text for one line ddef

  def parse(request) do
    [method, path, _] =   # _ will match any thing which you not need
      request
      |> String.split("\n")  # split multi lines to array of lines
      |> List.first  # get the first element in the given array
      |> String.split(" ")  # split the line to words

    %{ method: method, path: path, resp_body: "" }  # this is elixir map # last line returned by default
  end

  def route(conv) do
    route(conv, conv.method, conv.path)
  end

  @doc """
    if you hard coded the parameter then yo doing parameter matching and only maching def will run
  """
  def route(conv, "GET", "/wildthings") do
    %{ conv | resp_body: "Bears, Lions, Tigers" }  # retirn a new map with changed element
  end

  def route(conv, "GET", "/bears") do
    %{ conv | resp_body: "Bear1, Bear2, Bear3" }  # retirn a new map with changed element
  end

  def route(conv, "GET", "/bigs") do
    %{ conv | resp_body: "Big1, Big2, Big3" }  # retirn a new map with changed element
  end

  def format_response(conv) do
    # return the next multi lines text because it is the last thing in the def
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

end

# multi line text
request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response


request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bigs HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response
