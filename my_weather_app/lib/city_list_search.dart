import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_weather_app/db_dao.dart';
import 'package:my_weather_app/sehirler.dart';
import 'package:my_weather_app/weather_page.dart';

class CityList extends StatefulWidget
{
  @override
  _CityListState createState() => _CityListState();
}

class _CityListState extends State<CityList>
{
  var listFont = GoogleFonts.rubik(textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.black54));

  String textKontrol = "";

  final List<Sehirler> _sehirler = <Sehirler>[];
  List<Sehirler> _sehirlerGoruntu = <Sehirler>[];

  Future<List<Sehirler>> dataGetir() async
  {
    var url = Uri.parse("https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/master/states.json");
    var cevap = await http.get(url);

    var sehirList = <Sehirler>[];

    if(cevap.statusCode == 200)
    {
      var sehirlerJson = json.decode(cevap.body);
      for(var sehirJson in sehirlerJson)
      {
        sehirList.add(Sehirler.fromjson(sehirJson));
      }
    }
    return sehirList;
  }

  @override
  void initState()
  {
    dataGetir().then((value)
    {
      setState(()
      {
        _sehirler.addAll(value);
        _sehirlerGoruntu = _sehirler;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      resizeToAvoidBottomInset: false,
      //backgroundColor: Colors.blue.shade400,
      appBar: AppBar
      (
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        title: Container
        (
          decoration: BoxDecoration(color: Colors.white70,borderRadius: BorderRadius.circular(25)),
          child: _aramaBar(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack
      (
        alignment: Alignment.center,
        children:
        [
          Container //Background Gradient
          (
            decoration: BoxDecoration
            (
              gradient: LinearGradient
              (
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors:
                [
                  Colors.blue.shade700,
                  Colors.blue.shade400,
                  Colors.blue.shade300
                ]
              )
            ),
          ),
          SafeArea  //??ehirler List
          (
            child: Column
            (
              children:
              [
                if (textKontrol == "")
                Center
                (
                  child: Padding(padding: const EdgeInsets.only(top: 20), child: Text("??ehirler burada listelenecektir.",style: TextStyle(color: Colors.white,fontSize: 15)),
                  )
                )
                else SafeArea
                (
                  child: Container
                  (
                    height:MediaQuery.of(context).viewInsets.bottom*0.8,
                    width: MediaQuery.of(context).size.width*0.92,
                    decoration: BoxDecoration
                    (
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black12,
                    ),
                    child: ListView.builder
                    (
                      itemCount: _sehirlerGoruntu.length,
                      itemBuilder: (context, i) => _listItem(i),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _aramaBar()
  {
    return Padding
    (
      padding: const EdgeInsets.all(8.0),
      child: TextField
      (
        style: listFont,
        decoration: InputDecoration
        (
          hintText: "Aramak i??in t??klay??n...",
          hintStyle: listFont,
          border: InputBorder.none,
          icon: FaIcon(FontAwesomeIcons.search)
        ),
        onChanged: (text)
        {
          textKontrol = text.toLowerCase();
          setState(()
          {
            _sehirlerGoruntu = _sehirler.where((sehir)
            {
              var sehirAdi = sehir.sehirAd.toLowerCase();

              return sehirAdi.contains(textKontrol);
            }).toList();
          });
        },
      ),
    );
  }
 _listItem(index)
  {
    String trKontrol = _sehirlerGoruntu[index].ulkeAd == "Turkey" ? "T??rkiye" : _sehirlerGoruntu[index].ulkeAd;
    return GestureDetector
    (
      onTap: ()
      {
        SehirlerDAO().sehirEkle(_sehirlerGoruntu[index].sehirAd, trKontrol,
        _sehirlerGoruntu[index].lati, _sehirlerGoruntu[index].long);
        print("??ehir eklendi.");

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute
        (
          builder: (context) => WeatherPage(),
        ),(route) => false);
      },

      child: ListTile
      (
        title:Text(_sehirlerGoruntu[index].sehirAd,style: listFont),
        subtitle: Text(trKontrol,style:listFont),
      ),
    );
  }
}