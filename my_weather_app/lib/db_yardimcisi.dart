import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class DBYardimcisi
{
  static String veritabaniAdi = "kayitlisehirler.sqlite";

  static Future<Database> dbErisim() async
  {
    String yol = join(await getDatabasesPath(), veritabaniAdi);

    if(await databaseExists(yol))
    {
      print("Veritabanı var.");
    }
    else
    {
      ByteData veri = await rootBundle.load("database/$veritabaniAdi");

      List<int> bytes = veri.buffer.asInt8List(veri.offsetInBytes, veri.lengthInBytes);

      await File(yol).writeAsBytes(bytes,flush: true);

      print("Veritabanı kopyalandı.");
    }
    return openDatabase(yol);
  }
}