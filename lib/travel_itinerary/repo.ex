defmodule TravelItinerary.Repo do
  use Ecto.Repo,
    otp_app: :travel_itinerary,
    adapter: Ecto.Adapters.Postgres
end
