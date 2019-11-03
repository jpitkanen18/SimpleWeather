const express = require("express");
const package = require("./package.json");
const token = require("./token.json");
const XMLHTTPRequest = require("xmlhttprequest").XMLHttpRequest;
const api = new XMLHTTPRequest();
const app = express();

const port = 6969;
const sleep = waitTimeInMs =>
  new Promise(resolve => setTimeout(resolve, waitTimeInMs));
const name = "Weather API for iOS by jpitkanen18";
const version = package.version;
var weatherData = {
  temperature: Number,
  description: String,
  sunrise: Number,
  sunset: Number,
  timenow: Number
};

app.listen(port, () => {
  console.log(name + "\nVersion: " + version + "\nListening on port: " + port);
});

var time = 0;

app.get("/city=:id&fullData=:bool", async (req, res) => {
  console.log(req.params.bool);
  if (req.params.bool == "false") {
    if (time > 1500) {
      time = 0;
    }
    console.log("Sending weather data for " + req.params.id);
    time = time + 500;
    await sleep(time);
    request(req.params.id, res, req.params.bool);
  } else if (req.params.bool == "true") {
    request(req.params.id, res, req, req.params.bool);
  }
});
async function request(city, res, bool) {
  var url =
    "http://api.openweathermap.org/data/2.5/weather?q=" +
    city +
    "&APPID=" +
    token.token;
  console.log(url);
  if (bool == "false") {
    time += 500;
    await sleep(time);
  }
  api.open("GET", url, true);
  api.send();
  api.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      var responseHandler = JSON.parse(this.responseText);
      weatherData.temperature =
        Math.round(responseHandler.main.temp - 273.15) + "°C";
      weatherData.description = responseHandler.weather[0].description;
      weatherData.sunrise = getDate(responseHandler.sys.sunrise);
      weatherData.sunset = getDate(responseHandler.sys.sunset);
      weatherData.timenow = getDate2(
        responseHandler.dt,
        responseHandler.timezone
      );
      console.log(weatherData);
      res.send(weatherData);
    }
  };
}

function getDate2(UNIX_timestamp, offset) {
  var a = new Date(UNIX_timestamp * 1000);
  var offseth = offset / 60 / 60;
  var offsetm = offset / 60;
  a.setUTCDate(a.getUTCDate() + offset);
  var hours = a.getUTCHours();
  var mins = a.getUTCMinutes();
  var secs = a.getUTCSeconds();
  var time = hours + ":" + mins + ":" + secs;
  return time;
}
function getDate(UNIX_timestamp) {
  var a = new Date(UNIX_timestamp * 1000);
  var hours = a.getUTCHours();
  var mins = a.getUTCMinutes();
  var secs = a.getUTCSeconds();
  var time = hours + ":" + mins + ":" + secs + " UTC";
  return time;
}
