defmodule TravelItineraryWeb.PageControllerTest do
  use TravelItineraryWeb.ConnCase

  test "GET /file_uploads", %{conn: conn} do
    conn = get(conn, "/file_uploads/new")
    assert html_response(conn, 200) =~ "Upload Input File"
  end

  test " post /file_uploads", %{conn: conn} do
    params = %{"file_upload" => %{"file" => %Plug.Upload{path: "test/support/input.txt"}}}
    %{resp_body: resp_body} = post(conn, "/file_uploads", params)
    assert resp_body == File.read!("test/support/expected_ouput.txt")
  end
end
