import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_weather_app/city_list_search.dart';
import 'package:my_weather_app/db_dao.dart';
import 'package:my_weather_app/fl_chart.dart';
import 'package:my_weather_app/icon_image_kontrol.dart';
import 'package:my_weather_app/json.dart';
import 'package:my_weather_app/sehir_db.dart';
import 'package:my_weather_app/weather_provider.dart';
import 'package:provider/provider.dart';

class WeatherPage extends StatefulWidget
{
  @override
  State<WeatherPage> createState() => _WeatherPageState();
}
class Fonts
{
  var location1 = GoogleFonts.rubik(textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w600,color: WeatherFetch().renkKontrol()));
  var location2 = GoogleFonts.rubik(textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color:  WeatherFetch().renkKontrol()));
  var celcius = GoogleFonts.notoSans(textStyle: TextStyle(color:  WeatherFetch().renkKontrol(), fontSize: 50,fontWeight: FontWeight.bold));
  var detail = GoogleFonts.notoSans(textStyle: TextStyle(color:  WeatherFetch().renkKontrol(), fontSize: 18,fontWeight: FontWeight.w500));
  var cList = GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFFFBFAF5), fontSize: 20));
}


class _WeatherPageState extends State<WeatherPage>
{
  gecmisSehirKontrol() async
  {
    final sehirListesi = await SehirlerDAO().sehirOku();
    if(sehirListesi.isEmpty)
    {
      print("liste boş");
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => CityList()), (route) => false);
    }
    else
    {
      print("Listede item var");
      var sehir = sehirListesi.last;
      Provider.of<WeatherFetch>(context,listen: false).api(sehir.sehirAd, sehir.ulkeAd, sehir.lat, sehir.long);
    }
  }

  @override
  void initState()
  {
    gecmisSehirKontrol();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold
  (
    backgroundColor: Colors.blue.shade300,
    appBar:_appbar(),
    body: Center
    (
      child: Stack
      (
        children:
        [
          Consumer<WeatherFetch>(builder: (context, value, child) => IconImageKontrol().imageKontrol
          (
            value.icon,
            MediaQuery.of(context).size.height,
            MediaQuery.of(context).size.width,
          )),
          PageView
          (
            scrollDirection: Axis.vertical,
            children:
            [
              _page1(context),
              _page2(context),
            ],
          ),
        ],
      ),
    ),
    drawer: _drawer(context),
    drawerEnableOpenDragGesture: false,
    extendBodyBehindAppBar: true,
  );
}
_appbar() => AppBar
(
  toolbarHeight: 80,
  backgroundColor: Colors.transparent,
  elevation: 0,
  actions:
  [
    Consumer<WeatherFetch>(builder: (context, value, child) => Container
    (
      //color: Colors.red,
      padding: const EdgeInsets.only(top: 10,right: 15),
      child: Column
      (
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        [
          Text(value.sehirText.toString(),style: Fonts().location1),
          Text(value.ulkeText.toString(),style: Fonts().location2),
        ],
      ),
    )),
  ],
  leading: Padding
  (
    padding: const EdgeInsets.only(top:10),
    child: Builder
    (
      builder:(context) =>
      IconButton(onPressed:() => Scaffold.of(context).openDrawer(),
      icon: Consumer<WeatherFetch>
      (
        builder: (context, value, child) =>
        FaIcon(FontAwesomeIcons.bars,color: value.renkKontrol()),
      )),
    ),
  ),
);

_drawer(con) => Drawer
(
  backgroundColor: Colors.blueGrey.shade400,
  child: Column
  (
    mainAxisAlignment: MainAxisAlignment.center,
    children:
    [
      Container
      (
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column
        (
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            Padding
            (
              padding: const EdgeInsets.all(10),
              child: Row(children:
              [
                Text("Geçmiş Listesi",style: Fonts().detail),
                SizedBox(width: 5),
                FaIcon(FontAwesomeIcons.history,color: Colors.white,size: 20,),
              ]),
            ),
            Container //Geçmiş şehirler listesi kutusu
            (
              padding: const EdgeInsets.symmetric(vertical: 15),
              height: 300,
              decoration: BoxDecoration
              (
                color: Colors.black26,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Consumer<WeatherFetch>
              (
                builder: (context, value, child) =>
                FutureBuilder<List<SehirlerList>>
                (
                  future: SehirlerDAO().sehirOku(),
                  builder: (context, snapshot)
                  {
                    if(snapshot.hasData)
                    {
                      var sehirListSnap = snapshot.data;
                      return ListView.builder
                      (
                        shrinkWrap: true,
                        itemCount: sehirListSnap!.length,
                        itemBuilder: (context,index)
                        {
                          var sehir = sehirListSnap[index];
                          return ListTile
                          (
                            onTap:()
                            {
                              value.spots = [];
                              value.api(sehir.sehirAd, sehir.ulkeAd, sehir.lat, sehir.long);
                              Navigator.pop(context);
                            },
                            title: Text(sehir.sehirAd,style: Fonts().cList),
                            trailing: IconButton(onPressed:() //şehir Silme Butonu
                            {
                              value.sehirSil(sehir.sehirID);
                            },
                            icon: FaIcon(FontAwesomeIcons.times)),
                          );
                        }
                      );
                    }
                    else
                    {
                      return Center();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 80),
      GestureDetector //Şehir arama butonu
      (
        onTap: ()=> Navigator.push(con, MaterialPageRoute(builder: (context) => CityList())),
        child: Container
        (
          alignment: Alignment.center,
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration
          (
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Text("Şehir Ara",style: const TextStyle(fontSize: 20)),
        ),
      ),
      SizedBox(height: 15),
      Consumer<WeatherFetch> //Konum butonu
      (
        builder: (context, value, child) => SizedBox
        (
          width: 200,
          child: InkWell
          (
            onTap: ()
            {
              Navigator.pop(context);
              value.izinKontrol();
            },
            child: Row
            (
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              [
                FaIcon(FontAwesomeIcons.searchLocation,size: 20,color: Colors.white),
                SizedBox(width: 5),
                Text("Konumdan Bul",style: Fonts().detail),
              ]
            )
          ),
        ),
      ),
    ],
  )
);

_page1(con) => Center
(
  child: SingleChildScrollView
  (
    child: Column
    (
      mainAxisAlignment: MainAxisAlignment.center,
      children:
      [
        Consumer<WeatherFetch> //Hava Durumu Icon
        (
          builder: (context, value, child) =>
          IconImageKontrol().iconKontrol(value.icon),
        ),
        SizedBox(height: 40),
        Container //Hava Durumu Detay
        (
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(con).size.height*0.48,
          width: MediaQuery.of(con).size.width*0.9,
          decoration: BoxDecoration
          (
            color: Colors.white12,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white30)
          ),
          child: Column
          (
            children:
            [
              Consumer<WeatherFetch>
              (
                builder: (context, value, child) => Column
                (
                  children:
                  [
                    Text(value.aciklama.toString(),style: Fonts().location1),
                    Text("${value.derece?.toInt()} \u2103",style: Fonts().celcius),
                    Divider(color: value.renkKontrol(), thickness: 0.7, indent: 30, endIndent: 30)
                  ],
                )
              ),
              SizedBox
              (
                width: 280,
                child: Consumer<WeatherFetch>
                (
                  builder: (context, value, child) => Column
                  (
                    children:
                    [
                      ListTile
                      (
                        leading: FaIcon(FontAwesomeIcons.water,color: value.renkKontrol()),//Consumer<WeatherFetch>(builder: (context, value, child) => FaIcon(FontAwesomeIcons.water,color: value.renkKontrol())),
                        title: Text("Nem",style: Fonts().detail),
                        trailing: Text("% ${value.nem}",style: Fonts().detail),//Consumer<WeatherFetch>(builder: (context, value, child) => Text("% ${value.nem}",style: Fonts().detail))
                      ),
                      ListTile
                      (
                        leading: FaIcon(FontAwesomeIcons.temperatureHigh,color: value.renkKontrol()),//Consumer<WeatherFetch>(builder: (context, value, child) => FaIcon(FontAwesomeIcons.temperatureHigh,color: value.renkKontrol())),
                        title: Text("Hissedilen",style: Fonts().detail),
                        trailing: Text("${value.hissedilen?.toInt()} \u2103",style: Fonts().detail),//Consumer<WeatherFetch>(builder: (context, value, child) => Text("${value.hissedilen.toInt()} \u2103",style: Fonts().detail))
                      ),
                      ListTile
                      (
                        leading: FaIcon(FontAwesomeIcons.wind,color: value.renkKontrol()),//Consumer<WeatherFetch>(builder: (context, value, child) => FaIcon(FontAwesomeIcons.wind,color: value.renkKontrol())),
                        title: Text("Rüzgar",style: Fonts().detail),
                        trailing: Text("${value.ruzgar?.toInt()} km/s",style: Fonts().detail),//Consumer<WeatherFetch>(builder: (context, value, child) => Text("${value.ruzgar.toInt()} km/s",style: Fonts().detail))
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);

_page2(con) => Center
(
  child: SafeArea
  (
    child: Column
    (
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
      [
        Container //Grafik Tablosu
        (
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: MediaQuery.of(con).size.height*0.5,
          width: MediaQuery.of(con).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration
          (
            color: Colors.black12,
            borderRadius: BorderRadius.circular(15)
          ),
          child: Column
          (
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
            [
              Row
              (
                children:
                [
                  Padding
                  (
                    padding: const EdgeInsets.only(left:20),
                    child: Text("Günün Tahminleri",style: Fonts().cList),
                  ),
                ],
              ),
              Container
              (
                height: MediaQuery.of(con).size.height*0.4,
                child: Consumer<WeatherFetch>
                (
                  builder: (context, value, child) => SingleChildScrollView
                  (
                    scrollDirection: Axis.horizontal,
                    child: Container
                    (
                      padding: const EdgeInsets.only(left:20,right: 20,bottom: 10,top: 10),
                      width: 1000,
                      child: FLChart(spots: value.spots, y: value.y, timeList: value.data),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container //7 Günlük Tahminler
        (
          height: MediaQuery.of(con).size.height*0.25,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child:Consumer<WeatherFetch>
          (
            builder: (context, value, child) => FutureBuilder<DailyList>
            (
              future: value.foreFuture,
              builder: (context, snap)
              {
                if(snap.hasData)
                {
                  var list = snap.data!.dayTemps;
                  return ListView.builder
                  (
                    scrollDirection: Axis.horizontal,
                    itemCount: 7,
                    itemBuilder: (con, i)
                    {
                      if(i == 0) return Center();
                      return Container
                      (
                        width: MediaQuery.of(con).size.width*0.25,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration
                        (
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column
                        (
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                          [
                            Text(DateFormat.EEEE().format(DateTime.fromMillisecondsSinceEpoch(list[i].time*1000)), style: Fonts().location2),
                            Divider(color: value.renkKontrol(), thickness: 0.2, indent: 20, endIndent: 20,height: 20),
                            SizedBox
                            (
                              height: MediaQuery.of(con).size.height*0.1,
                              child: IconImageKontrol().iconKontrol(list[i].icon),
                            ),
                            Divider(color: value.renkKontrol(), thickness: 0.2, indent: 20, endIndent: 20,height: 20),
                            Text("${list[i].day.toInt()}\u00b0 / ${list[i].night.toInt()}\u00b0",style: Fonts().location2)
                          ],
                        ),
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator(color: Colors.white,));
              },
            ),
          ),
        ),
      ],
    ),
  ),
);