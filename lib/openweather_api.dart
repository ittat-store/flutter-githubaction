import 'dart:async';

import 'package:weather/daily_forecast.dart';
import 'package:weather/utils.dart';

class OpenWeatherAPI {
  final key = 'YOUR_OPENWEATHER_API_KEY';

  Future<Map<String, dynamic>> _getData(String api, double lat, double lon,
      [int cnt]) async {
    var url = '/data/2.5/$api';
    var uri = new Uri.https(
      'api.openweathermap.org',
      url,
      {
        'lat': '$lat',
        'lon': '$lon',
        'cnt': '$cnt',
        'APPID': key,
        'units': 'metric',
      },
    );
    return await makeHttpsRequest(uri);
  }

  Future<int> getCurrentTemperature(double lat, double lon) async {
    Map<String, dynamic> responseMap = await _getData('weather', lat, lon);
    var temperature = responseMap['main']['temp'];

    return temperature.toInt();
  }

  Future<List<DailyForecast>> getWeatherForecast(double lat, double lon, int cnt) async {
    Map<String, dynamic> responseMap = await _getData('forecast', lat, lon, cnt);
    List<DailyForecast> dailyForecastList = [];

    for (var index = 0; index < cnt; index++) {
      var temperature = responseMap['list'][index]['main']['temp'];
      var weather = responseMap['list'][index]['weather'][0]['id'];
      var dailyForecast = new DailyForecast(temperature.toInt(), weather);
      dailyForecastList.add(dailyForecast);
    }

    return dailyForecastList;
  }
}

class WordOnlineAPI {

  final String baseurl = 'cdn.jsdelivr.net/gh/lyc8503/baicizhan-word-meaning-API/data';
  final String list = '/list.json';

  Future<Map<String, dynamic>> _getWordList() async {
    var uri = new Uri.https(
      baseurl,
      list
    );
    return await makeHttpsRequest(uri);
  }

  Future<List<String>> getAllWord() async {
    var wordData = await _getWordList();
    List<String> wordList = wordData['list'];
    //print(wordList["total"] as int);
    return wordList;
  }

  Future<String> getword(String word) async{
    return '/words/${word}.json';
  }
}
