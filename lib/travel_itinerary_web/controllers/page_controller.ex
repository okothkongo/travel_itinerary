defmodule TravelItineraryWeb.PageController do
  use TravelItineraryWeb, :controller

  @output_file_path "priv/output#{System.unique_integer(~w[monotonic positive]a)}.txt"

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"file_upload" => %{"file" => %{path: file_path}}}) do
    TravelItinerary.create_output_file(file_path, @output_file_path)
    send_download(conn, {:file, @output_file_path})
  end
end
