# Contributing

We would love help in making Telescope a great experience. Feel free to log issues and open pull requests of any kind.

## spectacles.com Response Guide

We grab the following responses from spectacles.com depending on the status of the map:

`GET https://www.spectacles.com/locations`

```
# Active snapbot on map
{"countdown": 0, "coordinates": [{"lat": 38.201380499999999, "lng": -85.704096100000001}]}
```

```
# Map shows '??:??:??'
{"countdown": 0, "coordinates": []}
```

```
# Map shows countdown
# TODO
```
