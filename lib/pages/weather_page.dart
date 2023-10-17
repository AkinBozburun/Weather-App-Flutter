import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  _initData() async
  {
    Provider.of<WeatherFetch>(context,listen: false).cityListFetch();

    final box = await Hive.openBox("initialCity");

    if(box.isNotEmpty)
    {
      Provider.of<WeatherFetch>(context, listen: false).fetchData
      (
        box.get("City")["city"],
        box.get("City")["country"],
        box.get("City")["lat"],
        box.get("City")["long"],
      );
    }
    else
    {
      Future.delayed(Duration(milliseconds: 100)).then((value) => bottomSheet(context));
    }    
  }

  @override
  void initState()
  {
    _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    SystemChrome.setSystemUIOverlayStyle
    (
      const SystemUiOverlayStyle
      (
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      )
    );

    final provider = Provider.of<WeatherFetch>(context);

    return provider.derece == null ?
    Scaffold
    (
      backgroundColor: Color(0xff44B0FF),
      body: Center(child: CircularProgressIndicator(color: Styles.whiteColor)),
    ) :
    Scaffold
    (      
      appBar: _appbar(context),
      body: DataControl().backGroundCheck
      (
        provider.icon,
        MediaQuery.of(context).size.height,
        MediaQuery.of(context).size.width,
        PageView
        (
          scrollDirection: Axis.horizontal,
          children:
          [
            _page1(context),
            _page2(context),
          ],
        ),  
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
    );
  }
}

_appbar(con)
{
  final prov = Provider.of<WeatherFetch>(con);

  return AppBar
  (
    toolbarHeight: 82,
    backgroundColor: Colors.transparent,    
    elevation: 0,
    leading: IconButton(onPressed: (){},
    icon: Icon(Icons.bookmark_border_outlined,color: Styles.whiteColor)),
    actions:
    [
      Column
      (
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children:
        [
          Text(prov.sehirText.toString(), style: GoogleFonts.inter(textStyle: TextStyle
          (
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: prov.fontRenkKontrol()
          ))),
          Text(prov.ulkeText.toString(), style: GoogleFonts.inter(textStyle: TextStyle
          (
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: prov.fontRenkKontrol()
          ))),
        ],
      ),CitySheetWithButton()
    ],
  );
}

_page1(con)
{
  final prov = Provider.of<WeatherFetch>(con);

  String capitilized(text)
  => text[0].toString().toUpperCase()+text.toString().substring(1).toLowerCase();

  return Column
  (
    mainAxisAlignment: MainAxisAlignment.center,
    children:
    [
      SizedBox(height: 24),
      DataControl().iconCheck(prov.icon,true),
      SizedBox(height: 36),
      Container
      (
        height: MediaQuery.of(con).size.height * 0.45,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration
        (
          color: prov.panelRenkKontrol(),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30)
        ),
        child: Column
        (          
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            Column
            (
              children:
              [
                Text(capitilized(prov.aciklama),
                style: GoogleFonts.inter(textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: prov.fontRenkKontrol()))),
                SizedBox(height: 6),
                Text("${prov.derece?.toInt()} \u2103",
                style: GoogleFonts.inter(textStyle: TextStyle(
                  fontSize: 48,
                  color: prov.fontRenkKontrol(),
                  fontWeight: FontWeight.bold))),
              ],
            ),
            SizedBox(height: 8),
            Divider
            (
              color: prov.fontRenkKontrol(),
              thickness: 0.7,
              indent: 30,
              endIndent: 30
            ),
            SizedBox(height: 8),
            Container //Details
            (
              margin: const EdgeInsets.symmetric(horizontal: 32),
              child: Column
              (
                children:
                [
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.water,
                        color: prov.fontRenkKontrol()), 
                    title: Text("Nem",
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 18,
                                color: prov.fontRenkKontrol()))),
                    trailing: Text("% ${prov.nem}",
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 18,
                                color: prov.fontRenkKontrol()))),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.temperatureHigh,
                        color: prov
                            .fontRenkKontrol()),
                    title: Text("Hissedilen",
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 18,
                                color: prov.fontRenkKontrol()))),
                    trailing: Text(
                        "${prov.hissedilen?.toInt()} \u2103",
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 18,
                                color: prov
                                    .fontRenkKontrol()))),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.wind,
                        color: prov
                            .fontRenkKontrol()),
                    title: Text("Rüzgar",
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 18,
                                color: prov.fontRenkKontrol()))),
                    trailing: Text("${prov.ruzgar?.toInt()} km/s",
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 18,
                                color: prov.fontRenkKontrol()))),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ],
  );
}

_page2(con)
{
  final prov = Provider.of<VisualProvider>(con);
  final providerWeather = Provider.of<WeatherFetch>(con);

  Widget div = Divider
  (
    color: providerWeather.fontRenkKontrol(),
    thickness: 0.2,
    indent: 20,
    endIndent: 16,
    height: 24
  );

  return SafeArea
  (
    child: SingleChildScrollView
    (
      child: Column
      (
        children:
        [
          SizedBox(height: 16),
          Container //Saatlik Penceresi
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
                    Text("Günün Tahminleri", style: GoogleFonts.inter(textStyle: Styles().hourlyForecastTitle)),
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
          SizedBox(height: 24),
          Container //7 Günlük Tahminler
          (
            height: MediaQuery.of(con).size.height * 0.25,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: FutureBuilder<DailyList>
            (
              future: providerWeather.foreFuture,
              builder: (context, snap)
              {
                if (snap.hasData)
                {
                  var list = snap.data!.dayTemps;
                  return ListView.builder
                  (
                    scrollDirection: Axis.horizontal,
                    itemCount: 8,
                    itemBuilder: (con, i)
                    {
                      if (i == 0) return Center();
                      return Container
                      (
                        width: MediaQuery.of(con).size.width * 0.26,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration
                        (
                          color: providerWeather.panelRenkKontrol(),
                          borderRadius: BorderRadius.circular(24)
                        ),
                        child: Column
                        (
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                          [
                            Text
                            (
                              DateFormat.EEEE().format(DateTime.fromMillisecondsSinceEpoch(
                                list[i].time * 1000)),
                              style: GoogleFonts.inter(textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: providerWeather.fontRenkKontrol()))
                            ),
                            div,
                            SizedBox
                            (
                              height:
                              MediaQuery.of(con).size.height * 0.1 > 80 ? 80 :
                              MediaQuery.of(con).size.height * 0.1,
                              child: DataControl().iconCheck(list[i].icon,false),
                            ),
                            div,
                            Text
                            (
                              "${list[i].day.toInt()}\u00b0 / ${list[i].night.toInt()}\u00b0",
                              style: GoogleFonts.inter(textStyle: TextStyle
                              (
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: providerWeather.fontRenkKontrol()
                              )),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return Center(child: CircularProgressIndicator(color: Styles.whiteColor));
              },
            ),
          ),
        ],
      ),
    ),
  );
}

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
        child: FLChart(spots: prov.spots, y: prov.y, timeList: prov.hourlyData),
      ),
    );
  }
  else
  { 
    return ListView.separated //list
    (
      itemCount: 25,
      itemBuilder: (context, index) => SizedBox
      (
        height: 64,
        child: Row
        (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
          [
            Text
            (
              time(prov.hourlyData[index].time),
              style: Styles().hourlyForecastListText,
            ),
            Row(children:
            [
              Text(prov.hourlyData[index].temp.toInt().toString()+"°",
              style: Styles().hourlyForecastListText),
              SizedBox(width: 8),
              SizedBox //Icon
              (
                height: 42,
                width: 42,
                child: DataControl().iconCheck(prov.hourlyData[index].icon,false)
              ),                                  
            ]),
            SizedBox
            (
              width: 80,
              child: Text(prov.hourlyData[index].describtion,style: Styles().hourlyForecastListText,textAlign: TextAlign.end),
            ),
          ]
        ),
      ),
      separatorBuilder: (BuildContext context, int index) =>  Divider(color: Colors.white24),
    );
  }
}