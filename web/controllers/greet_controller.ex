defmodule Rumbl.GreetController do
  use Rumbl.Web, :controller

  def greet(conn, _params) do
    render conn, "greet.html"
  end
end