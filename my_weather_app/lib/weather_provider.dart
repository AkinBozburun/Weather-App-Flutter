import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:my_weather_app/db_dao.dart';
import 'package:my_weather_app/json.dart';

class WeatherFetch extends ChangeNotifier
{
  Future<void> sehirSil(i) async
  {
    await SehirlerDAO().sehirSil(i);
    notifyListeners();
    print("silindi");
  }

  List<Hourly> data = [];

  List<FlSpot> spots = [];

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

  Future<DailyList>? foreFuture;

  double lat = 0.0;
  double long = 0.0;

  bool konumkontrolcu = false;

  //String a = "https://api.openweathermap.org/data/2.5/onecall?lat=40.766137064354304&lon=29.937820890203547&appid=f5aac4a1dc5827bf0daf0d1cdee290b1&units=metric&lang=tr";

  Future<void> izinKontrol() async
  {
    await Geolocator.requestPermission();
    LocationPermission izin = await Geolocator.checkPermission();
    if(izin == LocationPermission.denied)
    {
      Fluttertoast.showToast
      (
        msg: "Konum Reddedildi",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black38,
      );
    }
    if(izin == LocationPermission.deniedForever)
    {
      Fluttertoast.showToast
      (
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
      konumkontrolcu = true;
      konumAl();
    }
  }

  Future<void> konumAl() async
  {
    await Geolocator.requestPermission();
    var konum = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    spots = [];
    api("", "", konum.latitude.toString(), konum.longitude.toString());
  }



  api(String sehirDB,String ulkeDB,String lat, String long)
  {
    String havaDurumuAPI = "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$long&appid=f5aac4a1dc5827bf0daf0d1cdee290b1&units=metric&lang=tr";
    sehirText = sehirDB == "" ? "Anlık" : sehirDB;
    ulkeText =  sehirDB == "" ? "(Konum)": ulkeDB;
    havaDurumuAl(havaDurumuAPI);
    spots = [];
    foreFuture = forecast(havaDurumuAPI);
  }

  Future<void> havaDurumuAl(String api) async
  {
    var jsonData = await http.get(Uri.parse(api));

    sayac++;
    print(sayac);

    var gunlukTemps = DailyList.fromjson(json.decode(jsonData.body));

    _dataYakala(gunlukTemps);
  }

  _dataYakala(jsonTemp)
  {
    derece = jsonTemp.temp;
    hissedilen = jsonTemp.feels;
    nem = jsonTemp.nem;
    ruzgar = jsonTemp.wind;
    aciklama = jsonTemp.aciklama;
    icon = jsonTemp.icon;
    notifyListeners();
  }

  renkKontrol()
  {
    if(icon == "13d" || icon == "13n")
    {
      return Colors.black;
    }
    else
    {
      return Colors.white;
    }
  }

  Future<DailyList> forecast(String api) async
  {
    var jsonData = await http.get(Uri.parse(api));
    sayac++;
    print(sayac);
    var foreTemps = DailyList.fromjson(json.decode(jsonData.body));
    _forecastDataYakala(foreTemps);
    return foreTemps;
  }

  _forecastDataYakala(jsonTemp) //Grafik
  {
    data = jsonTemp.hourTemps;
    for(int i = 0;i<24;i++)
    {
      y = data[i].temp.toDouble();
      spots.add(FlSpot (i.toDouble(),y));
      i++;
    }
    notifyListeners();
  }
}