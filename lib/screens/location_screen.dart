import 'dart:convert';

import 'package:clima/screens/city_screen.dart';
import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});
  final locationWeather;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  void initState() {
    super.initState();
    //print(widget.locationWeather);
    updateUI(widget.locationWeather);
  }

  double temperature;
  int condition;
  String cityName;
  String weatherIcon;
  String weatherMessage;

  void updateUI(dynamic weatherData) {
    WeatherModel im = WeatherModel();
    temperature = weatherData['main']['temp'];
    condition = weatherData['weather'][0]['id'];
    weatherIcon = im.getWeatherIcon(condition);
    weatherMessage = im.getMessage(temperature.toInt());
    cityName = weatherData['name'];
  }

  void getWeatherCity(String city) async {
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=6cbc1ccd712aa1fd96a02ba50601bae3&units=metric');
    Response response = await get(url);
    String data = response.body;
    dynamic weatherCity = jsonDecode(data);
    setState(() {
      updateUI(weatherCity);
    });
  }

  void currenWeather() async {
    Location current = Location();
    await current.getCurrentLocation();
    NetworkHelper networkHelper =
        NetworkHelper(latitude: current.latitude, longitude: current.longitude);
    var weatherData = await networkHelper.getNetworkData();
    print("updated");
    setState(() {
      updateUI(weatherData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      currenWeather();
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var TypedName = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return CityScreen();
                        }),
                      );
                      if (TypedName != null) {
                        getWeatherCity(TypedName);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '$temperature°C',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  '$weatherMessage in $cityName!',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
