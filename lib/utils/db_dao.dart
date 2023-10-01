import 'dart:async';
import 'package:my_weather_app/utils/sehir_db.dart';
import 'package:my_weather_app/utils/db_yardimcisi.dart';

class SehirlerDAO {
  Future<List<SehirlerList>> sehirOku() async {
    var db = await DBYardimcisi.dbErisim();

    List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * From sehirList");

    return List.generate(maps.length, (index) {
      var satir = maps[index];

      return SehirlerList(satir["sehir_id"], satir["sehir_ad"],
          satir["ulke_kod"], satir["lat"], satir["long"]);
    });
  }

  Future<void> sehirEkle(String sehirAd, String ulkeKod, String lat, String long) async
  {
    var db = await DBYardimcisi.dbErisim();

    var sehirBilgi = <String, dynamic>{};
    sehirBilgi["sehir_ad"] = sehirAd;
    sehirBilgi["ulke_kod"] = ulkeKod;
    sehirBilgi["lat"] = lat;
    sehirBilgi["long"] = long;

    await db.insert("sehirlist", sehirBilgi);
  }

  Future<void> sehirSil(int sehirID) async {
    var db = await DBYardimcisi.dbErisim();

    db.delete("sehirlist", where: "sehir_id=?", whereArgs: [sehirID]);
  }
}
