import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_weather_app/models/weather_model.dart';
import 'package:my_weather_app/pages/cities_bottomsheet.dart';
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
  @override
  Widget build(BuildContext context) => Scaffold
  (
    backgroundColor: Colors.blue.shade300,
    resizeToAvoidBottomInset: false,
    appBar: _appbar(context),    
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
    drawerEnableOpenDragGesture: false,
    extendBodyBehindAppBar: true,
  );
}

_appbar(con)
{
  final prov = Provider.of<WeatherFetch>(con);

  return AppBar
  (
    toolbarHeight: 70,
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(onPressed: (){}, icon: Icon(Icons.favorite,color: Styles.whiteColor)),
    actions:[Column
    (
      children:
      [
        Text(prov.sehirText.toString(), style: GoogleFonts.inter(textStyle: TextStyle
        (
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: prov.fontRenkKontrol()))),
        Text(prov.ulkeText.toString(), style: GoogleFonts.inter(textStyle: TextStyle
        (
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: prov.fontRenkKontrol()))),
      ],
    ),CitySheetWithButton()],
  );
}

_page1(con) => Center
(
  child: SingleChildScrollView
  (
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
                                  .fontRenkKontrol()), 
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
                                          .fontRenkKontrol()))),
                        ),
                        ListTile(
                          leading: FaIcon(FontAwesomeIcons.temperatureHigh,
                              color: value
                                  .fontRenkKontrol()),
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
                                          .fontRenkKontrol()))),
                        ),
                        ListTile(
                          leading: FaIcon(FontAwesomeIcons.wind,
                              color: value
                                  .fontRenkKontrol()),
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
                                          .fontRenkKontrol()))),
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

_switchButton(switchIcon, tap) => InkWell
(
  onTap: tap,
  child: Container
  (
    width: 42,
    height: 36,
    child: switchIcon == true ? Image.asset("images icons/chart_icon.png") :
    Image.asset("images icons/list_icon.png"),      
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration
    (
      color:Colors.black12,
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);

_hourly(switchIcon,con)
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

  if(switchIcon == true)
  {
    return SingleChildScrollView //chart
    (
      scrollDirection: Axis.horizontal,
      child: Container
      (
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
        width: 1000,
        child: FLChart
        (
          spots: prov.spots,
          y: prov.y,
          timeList: prov.hourlyData
        ),
      ),
    );
  }
  else
  { 
    return ListView.separated //list
    (
      itemCount: 24,
      itemBuilder: (context, index)
      {        
        return SizedBox
        (
          height: 64,
          child: Row
          (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
            [
              Text
              (
                index == 0 ? "Şimdi" : time(prov.hourlyData[index].time),
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
      separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.white24),
    );
  }
}

_page2(con)
{
  final prov = Provider.of<VisualProvider>(con);

  return SafeArea
  (
    child: Column
    (
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
      [
        Container
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
              Row
              (
                children:
                [
                  Text("Günün Tahminleri", style: GoogleFonts.inter(textStyle: TextStyle
                  (
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600
                  ))),
                  Spacer(),
                  _switchButton(prov.switchIcon,()=> prov.switchIconChange()),
                ],
              ),
              Container //Grafik ve Liste Penceresi
              (
                height: MediaQuery.of(con).size.height * 0.4,
                child: _hourly(prov.switchIcon, con),
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
  );
}