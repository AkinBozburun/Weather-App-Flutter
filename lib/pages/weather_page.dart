import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_weather_app/models/weather_model.dart';
import 'package:my_weather_app/pages/city_list_search.dart';
import 'package:my_weather_app/utils/sehir_db.dart';
import 'package:my_weather_app/utils/db_dao.dart';
import 'package:my_weather_app/utils/fl_chart.dart';
import 'package:my_weather_app/utils/icon_image_kontrol.dart';
import 'package:my_weather_app/utils/styles.dart';
import 'package:my_weather_app/utils/weather_provider.dart';
import 'package:provider/provider.dart';

class WeatherPage extends StatefulWidget
{
  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
{
  gecmisSehirKontrol() async
  {
    final sehirListesi = await SehirlerDAO().sehirOku();
    if (sehirListesi.isEmpty)
    {
      print("liste boş");
      Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => CityList()), (route) => false);
    }
    else
    {
      print("Listede item var");
      var sehir = sehirListesi.last;
      Provider.of<WeatherFetch>(context, listen: false)
      .api(sehir.sehirAd, sehir.ulkeAd, sehir.lat, sehir.long);
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
    appBar: _appbar(),
    body: Center
    (
      child: Stack
      (
        children:
        [
          Consumer<WeatherFetch>(builder: (context, value, child) => DataControl().imageKontrol
          (
            value.icon,
            MediaQuery.of(context).size.height,
            MediaQuery.of(context).size.width,
          )),
          PageView
          (
            scrollDirection: Axis.horizontal,
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
      actions: [
        Consumer<WeatherFetch>(
            builder: (context, value, child) => Container(
                  padding: const EdgeInsets.only(top: 10, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(value.sehirText.toString(),
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: value.fontRenkKontrol()))),
                      Text(value.ulkeText.toString(),
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: value.fontRenkKontrol()))),
                    ],
                  ),
                )),
      ],
      leading: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Builder(
          builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Consumer<WeatherFetch>(
                builder: (context, value, child) => FaIcon(
                    FontAwesomeIcons.bars,
                    color: value.fontRenkKontrol()),
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
      Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(children: [
                Text("Geçmiş Listesi", style: Styles().bottomSheetText1),
                SizedBox(width: 5),
                FaIcon(
                  FontAwesomeIcons.history,
                  color: Colors.white,
                  size: 20,
                ),
              ]),
            ),
            Container //Geçmiş şehirler listesi kutusu
                (
              padding: const EdgeInsets.symmetric(vertical: 15),
              height: 300,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Consumer<WeatherFetch>(
                builder: (context, value, child) =>
                    FutureBuilder<List<SehirlerList>>(
                  future: SehirlerDAO().sehirOku(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var sehirListSnap = snapshot.data;
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: sehirListSnap!.length,
                          itemBuilder: (context, index) {
                            var sehir = sehirListSnap[index];
                            return ListTile(
                              onTap: () {
                                value.spots = [];
                                value.api(sehir.sehirAd, sehir.ulkeAd,
                                    sehir.lat, sehir.long);
                                Navigator.pop(context);
                              },
                              title: Text(sehir.sehirAd,
                                  style: Styles().bottomSheetText1),
                              trailing: IconButton(
                                  onPressed: () //şehir Silme Butonu
                                      {
                                    value.sehirSil(sehir.sehirID);
                                  },
                                  icon: FaIcon(FontAwesomeIcons.times)),
                            );
                          });
                    } else {
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
        onTap: () => Navigator.push(
            con, MaterialPageRoute(builder: (context) => CityList())),
        child: Container(
          alignment: Alignment.center,
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Text("Şehir Ara", style: Styles().bottomSheetText2),
        ),
      ),
      SizedBox(height: 15),
      Consumer<WeatherFetch> //Konum butonu
          (
        builder: (context, value, child) => SizedBox(
          width: 200,
          child: InkWell(
              onTap: () {
                Navigator.pop(context);
                value.izinKontrol();
              },
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                FaIcon(FontAwesomeIcons.searchLocation,
                    size: 20, color: Colors.white),
                SizedBox(width: 5),
                Text("Konumdan Bul", style: Styles().bottomSheetText1),
              ])),
        ),
      ),
    ],
  ));

_page1(con) => Center
(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            Consumer<WeatherFetch> //Hava Durumu Icon
            (
              builder: (context, value, child) =>
              DataControl().iconKontrol(value.icon,true),
            ),
            SizedBox(height: 50),
            Consumer<WeatherFetch> //Hava Durumu Detay
            (
              builder: (context, value, child) => Container
              (
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(con).size.height * 0.45,
              width: MediaQuery.of(con).size.width * 0.9,
              decoration: BoxDecoration
              (
                color: value.panelRenkKontrol(),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white30)),
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                [
                  Column
                  (
                    children:
                    [
                      Text(value.aciklama.toString(),
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: value.fontRenkKontrol()))),
                      Text("${value.derece?.toInt()} \u2103",
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 50,
                                  color: value.fontRenkKontrol(),
                                  fontWeight: FontWeight.bold))),
                      Divider(
                          color: value.fontRenkKontrol(),
                          thickness: 0.7,
                          indent: 30,
                          endIndent: 30)
                    ],
                  ),
                  SizedBox(
                    width: 280,
                    child: Consumer<WeatherFetch>(
                      builder: (context, value, child) => Column(
                        children: [
                          ListTile(
                            leading: FaIcon(FontAwesomeIcons.water,
                                color: value
                                    .fontRenkKontrol()), //Consumer<WeatherFetch>(builder: (context, value, child) => FaIcon(FontAwesomeIcons.water,color: value.renkKontrol())),
                            title: Text("Nem",
                                style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        fontSize: 18,
                                        color: value.fontRenkKontrol()))),
                            trailing: Text("% ${value.nem}",
                                style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        fontSize: 18,
                                        color: value
                                            .fontRenkKontrol()))), //Consumer<WeatherFetch>(builder: (context, value, child) => Text("% ${value.nem}",style: Fonts().detail))
                          ),
                          ListTile(
                            leading: FaIcon(FontAwesomeIcons.temperatureHigh,
                                color: value
                                    .fontRenkKontrol()), //Consumer<WeatherFetch>(builder: (context, value, child) => FaIcon(FontAwesomeIcons.temperatureHigh,color: value.renkKontrol())),
                            title: Text("Hissedilen",
                                style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        fontSize: 18,
                                        color: value.fontRenkKontrol()))),
                            trailing: Text(
                                "${value.hissedilen?.toInt()} \u2103",
                                style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        fontSize: 18,
                                        color: value
                                            .fontRenkKontrol()))), //Consumer<WeatherFetch>(builder: (context, value, child) => Text("${value.hissedilen.toInt()} \u2103",style: Fonts().detail))
                          ),
                          ListTile(
                            leading: FaIcon(FontAwesomeIcons.wind,
                                color: value
                                    .fontRenkKontrol()), //Consumer<WeatherFetch>(builder: (context, value, child) => FaIcon(FontAwesomeIcons.wind,color: value.renkKontrol())),
                            title: Text("Rüzgar",
                                style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        fontSize: 18,
                                        color: value.fontRenkKontrol()))),
                            trailing: Text("${value.ruzgar?.toInt()} km/s",
                                style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        fontSize: 18,
                                        color: value
                                            .fontRenkKontrol()))), //Consumer<WeatherFetch>(builder: (context, value, child) => Text("${value.ruzgar.toInt()} km/s",style: Fonts().detail))
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );


_switchButton()
{
  return InkWell
  (
    onTap: () => print("tıklandı"),
    child: Container
    (
      width: 36,
      height: 36,
      child: Image.asset("images icons/list_icon.png"),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration
      (
        color: Colors.black12,
        border: Border.all(color: Styles.whiteColor),
        borderRadius: BorderRadius.circular(10)
      ),
    ),
  );
}

_page2(con)
{
  final prov = Provider.of<WeatherFetch>(con);

  String time(int stamp)
  {
    var date = DateTime.fromMillisecondsSinceEpoch(stamp * 1000);
    if (date.hour < 10)
    {
      return "0${date.hour}:00";
    }
    else return "${date.hour}:00";
  }

  return Center
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: MediaQuery.of(con).size.height * 0.5,
            width: MediaQuery.of(con).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration
            (
              color: Colors.black12, borderRadius: BorderRadius.circular(16),
            ),
            child: Column
            (
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
              [
                Row(
                  children:
                  [
                    Text("Günün Tahminleri", style: GoogleFonts.inter(
                      textStyle: TextStyle
                      (
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600
                      ))),
                    Spacer(),
                    _switchButton(),
                  ],
                ),
                Container
                (
                  height: MediaQuery.of(con).size.height * 0.4,
                  child: ListView.separated
                  (
                    itemCount: 24,
                    itemBuilder: (context, index)
                    {
                      if (index == 0) return Center();
                      return SizedBox(
                        height: 64,
                        child: Row
                        (
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:
                          [
                            Text
                            (
                              time(prov.hourlyData[index].time),
                              style: Styles().dailyForecastText,
                            ),
                            Row(children:
                            [
                              Text(prov.hourlyData[index].temp.toInt().toString()+"°",
                              style: Styles().dailyForecastText),
                              SizedBox(width: 8),
                              SizedBox //Icon
                              (
                                height: 42,
                                width: 42,
                                child: DataControl().iconKontrol(prov.hourlyData[index].icon,false)
                              ),                                  
                            ]),
                            SizedBox
                            (
                              width: 80,
                              child: Text(prov.hourlyData[index].describtion,style: Styles().dailyForecastText,textAlign: TextAlign.end,)
                            ),
                          ]
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index)
                    {
                      if (index == 0) return Center();

                      return Divider(color: Colors.white24,);
                    },
                  )
                    //Consumer<WeatherFetch>
                    //(
                    //  builder: (context, value, child) => SingleChildScrollView(
                    //    scrollDirection: Axis.horizontal,
                    //    child: Container
                    //    (
                    //      padding: const EdgeInsets.only(
                    //          left: 20, right: 20, bottom: 10, top: 10),
                    //      width: 1000,
                    //      child: FLChart(
                    //          spots: value.spots,
                    //          y: value.y,
                    //          timeList: value.data),
                    //    ),
                    //  ),
                    //),
                  ),
              ],
            ),
          ),
          Container //7 Günlük Tahminler
          (
            height: MediaQuery.of(con).size.height * 0.25,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Consumer<WeatherFetch>(
              builder: (context, value, child) => FutureBuilder<DailyList>(
                future: value.foreFuture,
                builder: (context, snap) {
                  if (snap.hasData) {
                    var list = snap.data!.dayTemps;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      itemBuilder: (con, i) {
                        if (i == 0) return Center();
                        return Container(
                          width: MediaQuery.of(con).size.width * 0.25,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: value.panelRenkKontrol(),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  DateFormat.EEEE().format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          list[i].time * 1000)),
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: value.fontRenkKontrol()))),
                              Divider(
                                  color: value.fontRenkKontrol(),
                                  thickness: 0.2,
                                  indent: 20,
                                  endIndent: 20,
                                  height: 20),
                              SizedBox(
                                height: MediaQuery.of(con).size.height * 0.1,
                                child: DataControl().iconKontrol(list[i].icon,false),
                              ),
                              Divider(
                                  color: value.fontRenkKontrol(),
                                  thickness: 0.2,
                                  indent: 20,
                                  endIndent: 20,
                                  height: 20),
                              Text(
                                  "${list[i].day.toInt()}\u00b0 / ${list[i].night.toInt()}\u00b0",
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: value.fontRenkKontrol())))
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  ));
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
