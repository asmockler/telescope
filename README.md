# Telescope

:telescope: Help me find some spectacles

## Deploy to Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

Click the button above and Heroku will help you deploy the app. Once deployed, open the schedule add-on and add `bin/telescope` at the frequency you want (I have mine set to run hourly).

## TODO

* [ ] Tell user how far the location is from them
* [ ] Notify of countdown starting

### Snapchat Responses

```
# GET https://www.spectacles.com/locations
{"countdown": 0, "coordinates": [{"lat": 38.201380499999999, "lng": -85.704096100000001}]}
```
