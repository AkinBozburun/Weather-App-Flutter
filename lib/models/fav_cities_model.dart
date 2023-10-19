import 'package:hive/hive.dart';

part 'fav_cities_model.g.dart';

@HiveType(typeId: 0)
class FavCities extends HiveObject
{
  @HiveField(0)
  late String favCityName;

  @HiveField(1)
  late String favCityCountry;

  @HiveField(2)
  late double favCityLat;

  @HiveField(3)
  late double favCityLong;
}