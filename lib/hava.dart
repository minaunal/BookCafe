
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String apiUrl =
      'http://api.openweathermap.org/data/2.5/weather?q=ankara&appid=8506a5b14db1d9c8baae70ea936ced1b';

  double temperature = 0.0;
  int humidity = 0;
  String weatherCondition = '';

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  photo() {
    if (weatherCondition.toLowerCase().contains('clear')) {
      return CircleAvatar(
        radius: 75,
        backgroundImage: AssetImage(
          'images/clear.jpg',
        ),
      );
    } else if (weatherCondition.toLowerCase().contains('rain')) {
      return CircleAvatar(
        radius: 75,
        backgroundImage: AssetImage(
          'images/yagmurlu.jpg',
        ),
      );
    }
    else if (weatherCondition.toLowerCase()=='clouds') {
      return CircleAvatar(
        radius: 75,
        backgroundImage: AssetImage(
          'images/bulut.png',
        ),
      );
    }
    else if (weatherCondition.toLowerCase().contains('sun')) {
      return CircleAvatar(
        radius: 75,
        backgroundImage: AssetImage(
          'images/sun.jpg',
        ),
      );
    }
    else if (weatherCondition.toLowerCase().contains('cloud')) {
      return CircleAvatar(
        radius: 75,
        backgroundImage: AssetImage(
          'images/parcalibulut.png',
        ),
      );
    }
    else if (weatherCondition.toLowerCase().contains('snow')) {
      return CircleAvatar(
        radius: 75,
        backgroundImage: AssetImage(
          'images/snowy.png',
        ),
      );
    }
  }

  Future<void> fetchWeatherData() async {
    try {
      http.Response response = await http.get(Uri.parse(apiUrl));

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
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
            Text('Humidity: $humidity%',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
            Text(weatherCondition,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
