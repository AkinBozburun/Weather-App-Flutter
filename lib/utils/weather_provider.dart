import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:my_weather_app/models/sehirler.dart';
import 'package:my_weather_app/models/weather_model.dart';
import 'package:my_weather_app/utils/styles.dart';

class WeatherFetch extends ChangeNotifier
{
  List<Hourly> hourlyData = [];

  List<FlSpot> spots = [];

  List<Daily> dailyData = [];

  double y = 0;

  var derece;
  var aciklama;
  var ruzgar;
  var nem;
  var hissedilen;
  var icon;

  String? sehirText;
  String? ulkeText;

  int sayac = 0;

  double lat = 0.0;
  double long = 0.0;  

  izinKontrol() async
  {
    await Geolocator.requestPermission();
    LocationPermission izin = await Geolocator.checkPermission();

    if(izin == LocationPermission.denied)
    {
      Fluttertoast.showToast(
        msg: "Konum Reddedildi",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black,
      );
    }
    if(izin == LocationPermission.deniedForever)
    {
      Fluttertoast.showToast(
        msg: "Konum Kullanımı Engellendi",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
    }
    bool servisKontrol = await Geolocator.isLocationServiceEnabled();
    if(!servisKontrol)
    {
      Fluttertoast.showToast
      (
        msg: "Konum Servisi Kapalı",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black38,
      );
    }
    else
    {
      _konumAl();
    }
  }

  _konumAl() async
  {
    await Geolocator.requestPermission();
    var konum = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    List<Placemark> placeMark = await placemarkFromCoordinates(konum.latitude, konum.longitude);
    final name = placeMark.first.locality == "" ? placeMark.first.subLocality : placeMark.first.locality;
    final country = placeMark.first.country;
    spots = [];
    fetchData(name.toString(), country.toString(), konum.latitude.toString(), konum.longitude.toString());
  }

  fetchData(String sehirDB, String ulkeDB, String lat, String long)
  {
    String havaDurumuAPI =
      "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$long&appid=f5aac4a1dc5827bf0daf0d1cdee290b1&units=metric&lang=tr";
    sehirText = sehirDB;
    ulkeText = ulkeDB;
    spots = [];    
    _havaDurumuAl(havaDurumuAPI);
    _saveToBox(sehirDB, ulkeDB, lat, long);
  }

  _havaDurumuAl(String api) async
  {
    var jsonData = await http.get(Uri.parse(api));
    var gunlukTemps = DailyList.fromjson(json.decode(jsonData.body));

    _currentDataSet(gunlukTemps);
    _hourlyDailyDataAddList(gunlukTemps);
  }

  _currentDataSet(jsonTemp)
  {
    derece = jsonTemp.temp;
    hissedilen = jsonTemp.feels;
    nem = jsonTemp.nem;
    ruzgar = jsonTemp.wind;
    aciklama = jsonTemp.aciklama;
    icon = jsonTemp.icon;
    notifyListeners();
  }

  _hourlyDailyDataAddList(jsonTemp) //24 saatlik tahminler Grafik ve Tablo
  {
    dailyData = jsonTemp.dayTemps;
    hourlyData = jsonTemp.hourTemps;

    for (int i = 0; i < 24; i++)
    {
      y = hourlyData[i].temp.toDouble();
      spots.add(FlSpot(i.toDouble(), y));
      i++;
    }    
    notifyListeners();
  }

  List<Locations> cityList = [];
  List<Locations> citySearchList = [];

  cityListFetch() async
  {
    final String api = "https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/master/states.json";

    var jsonData = await http.get(Uri.parse(api));    

    var data = json.decode(jsonData.body);

    _cityData(data);
  }

  _cityData(data)
  {
    if(cityList.isEmpty)
    {
      for(var cityData in data)
      {
        cityList.add(Locations.fromjson(cityData));
      }
    }
    citySearchList = cityList;
    notifyListeners();
  }

  citySearch(String city)
  {    
    citySearchList = cityList.where((item)
    => item.city.toLowerCase().contains(city.toLowerCase())).toList();
    notifyListeners();    
  }

  _saveToBox(city,country,lat,long) async
  {    
    final box = await Hive.openBox('initialCity');
    box.put("City",
    {
      "city" : city,
      "country" : country,
      "lat" : lat,
      "long" : long,
    });
  }

  fontRenkKontrol()
  {
    if (icon == "13d" || icon == "13n") {
      return Styles.blackColor;
    } else {
      return Styles.whiteColor;
    }
  }
  panelRenkKontrol()
  {
    if (icon == "13d" || icon == "13n") {
      return Colors.black12;
    } else {
      return Colors.white10;
    }
  }
}

class VisualProvider extends ChangeNotifier
{
  bool switchIcon = true;

  switchIconChange()
  {
    switchIcon = !switchIcon;
    notifyListeners();
  }

  String textCheck = "";

  textBool(textfieldText)
  {
    textCheck = textfieldText;
    notifyListeners();
  }

  clearText()
  {
    textCheck = "";
    notifyListeners();
  }
}