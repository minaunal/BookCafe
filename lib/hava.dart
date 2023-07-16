import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temperature = 0.0;
  int humidity = 0;
  String weatherCondition = '';

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  photo() {
    String backgroundImage = '';

    if (weatherCondition.toLowerCase().contains('clear')) {
      backgroundImage = 'images/clear.jpg';
    } else if (weatherCondition.toLowerCase().contains('rain')) {
      backgroundImage = 'images/rain.jpg';
    } else if (weatherCondition.toLowerCase() == 'clouds') {
      backgroundImage = 'images/bulut.png';
    } else if (weatherCondition.toLowerCase().contains('sun')) {
      backgroundImage = 'images/sun.jpg';
    } else if (weatherCondition.toLowerCase().contains('cloud')) {
      backgroundImage = 'images/parcalibulut.png';
    } else if (weatherCondition.toLowerCase().contains('snow')) {
      backgroundImage = 'images/snowy.png';
    }
    return CircleAvatar(
      radius: 75,
      backgroundImage: AssetImage(
          backgroundImage,
        ),
    );
  }

  Future<void> fetchWeatherData() async {
    try {
      http.Response response = await http.get(Uri.parse(
          'http://api.openweathermap.org/data/2.5/weather?q=ankara&appid=8506a5b14db1d9c8baae70ea936ced1b'));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          temperature = jsonData['main']['temp'];
          temperature = temperature - 273.15;
          humidity = jsonData['main']['humidity'];
          weatherCondition = jsonData['weather'][0]['description'];
        });
      } else {
        print('Hava durumu verileri alınamadı. Hata kodu: ${response.body}');
      }
    } catch (e) {
      print('Hava durumu verileri alınamadı: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 170, 203, 219),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Weather Condition',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(
              height: 20,
            ),
            photo(),
            Text('${temperature.toStringAsFixed(1)}°C',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Text('Humidity: $humidity%',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Text(weatherCondition,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
