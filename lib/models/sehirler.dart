class Locations
{
  late String city;
  late String country;
  late String lati;
  late String long;

  Locations(this.city, this.country, this.lati, this.long);

  Locations.fromjson(Map<String, dynamic> json)
  {
    city = json["name"] as String;
    country = json["country_name"] as String;
    lati = json["latitude"] ?? "";
    long = json["longitude"]?? "";
  }
}