# TravelItinerary

## To get started with application locally
Clone the this repository 

```bash
 git@github.com:okothkongo/travel_itinerary.git
```

or   

```bash
https://github.com/okothkongo/travel_itinerary.git
```


To start your Phoenix server:

  * Change directory into the cloned repo: `cd travel_itinerary`
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000/file_uploads/new`](http://localhost:4000/file_uploads/new) from your browser

## Upload file
Visit  [`localhost:4000/file_uploads/new`](http://localhost:4000/file_uploads/new)

Click ``Choose file`` and the ```SUBMIT``` button

## Type and format of the files to be uploaded
The input should be a  file text file  with content in the format below;
```txt
BASED: SVQ

RESERVATION
SEGMENT: Hotel BCN 2023-01-05 -> 2023-01-10

RESERVATION
SEGMENT: Flight SVQ 2023-01-05 20:40 -> BCN 22:10
SEGMENT: Flight BCN 2023-01-10 10:30 -> SVQ 11:50

RESERVATION
SEGMENT: Train SVQ 2023-02-15 09:30 -> MAD 11:00
SEGMENT: Train MAD 2023-02-17 17:00 -> SVQ 19:30

RESERVATION
SEGMENT: Hotel MAD 2023-02-15 -> 2023-02-17
```
## Expected File Output

```txt
TRIP to BCN
Flight from SVQ to BCN at 2023-01-05 20:40 to 22:10
Hotel at BCN on 2023-01-05 to 2023-01-10
Flight from BCN to SVQ at 2023-01-10 10:30 to 11:50

TRIP to MAD
Train from SVQ to MAD at 2023-02-15 09:30 to 11:00
Hotel at MAD on 2023-02-15 to 2023-02-17
Train from MAD to SVQ at 2020-02-17 17:00 to 19:30

```
## Edges Case and assumptions made
* The mode of transport can either be `Flight` or `Train`.If any other mode is used the parsing of input `won't be sucessful`
* A hotel reservation is included in the itinerary at each location
* During file processing file `output.txt` file to be downloaded is overwritten by each new attempt assumpttion is there made that only one user will upload the file at any time.This however can be remedied by making output file unique for each download and clearing the `priv` directory of the `output.txt` after successful download.
