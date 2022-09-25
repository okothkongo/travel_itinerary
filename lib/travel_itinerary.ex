defmodule TravelItinerary do
  @moduledoc """
  TravelItinerary keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @doc """
    `create_output_file/2` processes the content of the input file and writes 
    the resulting content on an output file.
  """
  @spec create_output_file(String.t(), String.t()) :: :ok
  def create_output_file(input_file_path, output_file_path) do
    file_content = create_ouput_file_content(input_file_path)
    File.write!(output_file_path, file_content)
  end

  defp create_ouput_file_content(input_file_path) do
    input_file_path
    |> read_file_content()
    |> Enum.map(&format_data/1)
    |> sort_itinerary()
    |> format_output()
  end

  defp read_file_content(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split(&1, ["RESERVATION", "\n"], trim: true))
  end

  defp sort_itinerary(itinerary) do
    [%{start_point: start_point} | itenirary] = itinerary |> List.flatten()

    start_point
    |> get_destinations(itenirary)
    |> Enum.map(fn dest ->
      value = sort_by_location_and_arrival_date(itenirary, dest)
      {dest, value}
    end)
  end

  defp sort_by_location_and_arrival_date(itenirary, location) do
    itenirary
    |> Enum.reduce([], fn item, acc ->
      case item do
        %{iata: iata} when iata == location -> [item | acc]
        %{from: from} when from == location -> [item | acc]
        %{to: to} when to == location -> [item | acc]
        _ -> acc
      end
    end)
    |> Enum.sort_by(fn data -> data.arrival_date end)
  end

  defp format_output(output_data) do
    output_data
    |> Enum.map(fn {destination, travel_arrangements} ->
      "TRIP to #{destination}\n#{Enum.map(travel_arrangements, fn travel_arrangement -> form_output_data(travel_arrangement) end)}\n"
    end)
    |> Enum.join()
    |> String.trim_trailing()
  end

  defp format_data(data) when is_list(data) do
    Enum.map(data, &segment/1)
  end

  defp format_data(data) do
    segment(data)
  end

  defp segment(
         <<"SEGMENT: Hotel ", iata::binary-size(3), " ", start_date::binary-size(10), " -> ",
           end_date::binary-size(10)>>
       ) do
    %{
      iata: iata,
      reservation_type: "Hotel",
      arrival_date: "#{start_date} ",
      departure_date: end_date
    }
  end

  defp segment(
         <<"SEGMENT: Train ", from::binary-size(3), " ", departure_date::binary-size(10), " ",
           departure_time::binary-size(5), " -> ", to::binary-size(3), " ",
           arrival_time::binary-size(5)>>
       ) do
    %{
      from: from,
      to: to,
      reservation_type: "Train",
      departure_time: departure_time,
      departure_date: departure_date,
      arrival_time: arrival_time,
      arrival_date: "#{departure_date}"
    }
  end

  defp segment(
         <<"SEGMENT: Flight ", from::binary-size(3), " ", departure_date::binary-size(10), " ",
           departure_time::binary-size(5), " -> ", to::binary-size(3), " ",
           arrival_time::binary-size(5)>>
       ) do
    %{
      from: from,
      to: to,
      reservation_type: "Flight",
      departure_time: departure_time,
      departure_date: departure_date,
      arrival_time: arrival_time,
      arrival_date: "#{departure_date}"
    }
  end

  defp segment("BASED: " <> iata) do
    %{start_point: iata}
  end

  defp get_destinations(start_point, itenirary) do
    itenirary
    |> Enum.reduce([], fn it, acc ->
      do_get_destinations(it, start_point, acc)
    end)
  end

  defp do_get_destinations(%{iata: iata}, start_point, acc) when iata == start_point do
    acc
  end

  defp do_get_destinations(%{iata: iata}, _start_point, acc) do
    if iata not in acc, do: acc ++ [iata], else: acc
  end

  defp do_get_destinations(%{to: to}, start_point, acc) when to == start_point do
    acc
  end

  defp do_get_destinations(%{to: to}, _start_point, acc) do
    if to not in acc, do: acc ++ [to], else: acc
  end

  defp do_get_destinations(_, _, acc), do: acc

  defp form_output_data(%{iata: iata, arrival_date: arrival_date, departure_date: departure_date}) do
    "Hotel at #{iata} on #{String.trim(arrival_date)} to #{departure_date}\n"
  end

  defp form_output_data(r) do
    "#{r.reservation_type} from #{r.from} to #{r.to} at #{r.arrival_date} #{r.departure_time} to #{r.arrival_time}\n"
  end
end
