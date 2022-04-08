class Sehirler
{
  late String sehirAd;
  late String ulkeAd;
  late String lati;
  late String long;

  Sehirler(this.sehirAd, this.ulkeAd, this.lati, this.long);

  Sehirler.fromjson(Map<String, dynamic> json)
  {
    sehirAd = json["name"] as String;
    ulkeAd = json["country_name"] as String;
    lati = json["latitude"] ?? "";
    long = json["longitude"]?? "";
  }
}