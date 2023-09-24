class Daily
{
  late int time;
  var day;
  var night;
  late String icon;

  Daily(this.time, this.day, this.night, this.icon);

  factory Daily.fromjson(Map<String, dynamic> json)
  {
    return Daily
    (
      json["dt"],
      json["temp"]["day"],
      json["temp"]["night"],
      json["weather"][0]["icon"]
    );
  }
}

class Hourly
{
  late int time;
  late var temp;
  late String icon;
  late String describtion;

  Hourly(this.time, this.temp, this.icon, this.describtion);

  factory Hourly.fromjson(Map<String, dynamic> json)
  {
    return Hourly
    (
      json["dt"],
      json["temp"],
      json["weather"][0]["icon"],
      json["weather"][0]["description"]
    );
  }
}

class DailyList
{
  var temp;
  var feels;
  var nem;
  var wind;
  var aciklama;
  late String icon;
  late List<Daily> dayTemps;
  late List<Hourly> hourTemps;

  DailyList(this.temp, this.feels, this.nem, this.wind, this.aciklama,
      this.icon, this.dayTemps, this.hourTemps);

  factory DailyList.fromjson(Map<String, dynamic> json) {
    var dailyArray = json["daily"] as List;
    List<Daily> dtempList = dailyArray.map((e) => Daily.fromjson(e)).toList();

    var hourArray = json["hourly"] as List;
    List<Hourly> hTempList = hourArray.map((e) => Hourly.fromjson(e)).toList();

    return DailyList(
      json["current"]["temp"],
      json["current"]["feels_like"],
      json["current"]["humidity"],
      json["current"]["wind_speed"],
      json["current"]["weather"][0]["description"],
      json["current"]["weather"][0]["icon"],
      dtempList,
      hTempList,
    );
  }
}
