defmodule TravelItineraryWeb.PageController do
  use TravelItineraryWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
