import 'package:hive/hive.dart';
import 'package:my_weather_app/models/fav_cities_model.dart';

class Boxes
{
  static Box<FavCities> getFavs() => Hive.box<FavCities>("favCities");
}