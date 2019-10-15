const express = require("express");
const package = require("./package.json");
const token = require("./token.json");
const XMLHTTPRequest = require("xmlhttprequest").XMLHttpRequest;
const api = new XMLHTTPRequest();
const app = express();

const port = 6969;
const name = "iOS App API by jpitkanen18";
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

app.get("/city=:id", (req, res) => {
  console.log("Sending weather data for " + req.params.id);
  request(req.params.id, res, req);
});
function request(city, res, req) {
  var url =
    "http://api.openweathermap.org/data/2.5/weather?q=" +
    city +
    "&APPID=" +
    token.token;
  console.log(url);
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
      weatherData.timenow = getDate(responseHandler.dt);
      console.log(weatherData);
      res.send(weatherData);
    }
  };
}
function getDate(UNIX_timestamp) {
  var a = new Date(UNIX_timestamp * 1000);
  var months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  var year = a.getFullYear();
  var month = months[a.getMonth()];
  var date = a.getDate();
  var hour = a.getHours();
  var min = a.getMinutes();
  var sec = a.getSeconds();
  var time = hour + ":" + min + ":" + sec;
  return time;
}
