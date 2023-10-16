import 'package:hive/hive.dart';

part 'fav_cities_model.g.dart';

@HiveType(typeId: 0)
class FavCities extends HiveObject
{
  @HiveField(0)
  late int favCityID;

  @HiveField(1)
  late String favCityName;

  @HiveField(2)
  late String favCityCountry;

  @HiveField(3)
  late String favCityLat;

  @HiveField(4)
  late String favCityLong;
}