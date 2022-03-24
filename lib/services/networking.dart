import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NetworkHelper {
  final double latitude;
  final double longitude;
  final String key = '6cbc1ccd712aa1fd96a02ba50601bae3';
  NetworkHelper({@required this.latitude, @required this.longitude});

  Future getNetworkData() async {
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$key&units=metric');
    //Uri('https://api.openweathermap.org/data/2.5/weather?lat=30.34234234234234&lon=77.89510489627196&appid=6cbc1ccd712aa1fd96a02ba50601bae3');
    Response response = await get(url);
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
      // print(data);
      // var temperature = jsonDecode(data)['main']['temp'];
      // var condition = jsonDecode(data)['weather'][0]['id'];
      // var cityName = jsonDecode(data)['name'];

      // print(temperature);
      // print(condition);
      // print(cityName);
    } else {
      print(response.statusCode);
    }
  }
}
