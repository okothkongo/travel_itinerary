defmodule TravelItineraryWeb.PageController do
  use TravelItineraryWeb, :controller

  @output_file_path Application.get_env(:travel_itinerary, :output_file_path)

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"file_upload" => %{"file" => %{path: file_path}}}) do
    TravelItinerary.create_output_file(file_path, @output_file_path)
    conn = send_download(conn, {:file, @output_file_path})
    conn
  end
end
