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
    |> rewrite_path
    |> log
    |> route # the result of this def send as a first parameter to the next pipe
    |> track
    |> format_response # last line returned by default
  end

  def track(%{status: 404, path: path} = conv) do
    IO.puts "Warning #{path} is not here"
    conv
  end

  def track(conv), do: conv  # match any another thing and return it as it

  def rewrite_path(%{path: "/wildlife"} = conv) do  # = conv used to use conv vale in the def , you can use the match without it
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(conv), do: conv  # match any another thing and return it as it

  def log(conv), do: IO.inspect conv  # short text for one line ddef

  def parse(request) do
    [method, path, _] =   # _ will match any thing which you not need
      request
      |> String.split("\n")  # split multi lines to array of lines
      |> List.first  # get the first element in the given array
      |> String.split(" ")  # split the line to words

    %{ method: method, path: path, resp_body: "", status: nil }  # this is elixir map # last line returned by default
  end

  @doc """
    if you hard coded the parameter then yo doing parameter matching and only maching def will run
  """
  def route(%{ method: "GET", path: "/wildthings" } = conv) do
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }  # retirn a new map with changed elements
  end

  def route(%{ method: "GET", path: "/bears" } = conv) do
    %{ conv | status: 200, resp_body: "Bear1, Bear2, Bear3" }
  end

  def route(%{ method: "GET", path: "/bears/" <> id } = conv) do  # <> to connect 2 strings
    %{ conv | status: 200, resp_body: "Bear #{id}" }
  end

  def route(%{ method: method, path: path } = conv) do  # with no hard coded , it catch all -> make it in last
    %{ conv | status: 404, resp_body: "No #{method} and No #{path}" }  # #{} print variable inside text
  end

  def format_response(conv) do
    # return the next multi lines text because it is the last thing in the def
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do  # private def
    %{
      200 => "OK",    # when key is number , use => , when key is text use atom:
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
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
GET /wildlife HTTP/1.1
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
GET /bears/55 HTTP/1.1
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
