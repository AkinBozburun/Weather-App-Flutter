class Cities
{
  late String city;
  late String country;
  late String lati;
  late String long;

  Cities(this.city, this.country, this.lati, this.long);

  Cities.fromjson(Map<String, dynamic> json)
  {
    city = json["name"] as String;
    country = json["country_name"] as String;
    lati = json["latitude"] ?? "";
    long = json["longitude"]?? "";
  }
}