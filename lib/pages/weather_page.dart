import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_weather_app/models/fav_cities_model.dart';
import 'package:my_weather_app/pages/cities_bottomsheet.dart';
import 'package:my_weather_app/utils/fl_chart.dart';
import 'package:my_weather_app/utils/get_box.dart';
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
    final box = await Hive.openBox("initialCity");

    Provider.of<WeatherFetch>(context,listen: false).cityListFetch();

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

    return Consumer<WeatherFetch>
    (
      builder: (context, value, child) => value.derece == null ?
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
          value.icon,
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
      )
    );    
  }
}

_favsButton(context)
{
  final provider = Provider.of<WeatherFetch>(context);
  final textController = TextEditingController(text: provider.sehirText);

  _addToFavsBoxList()
  {
    final box = Boxes.getFavs();

    final favs = FavCities()
    ..favCityName = textController.text
    ..favCityCountry = provider.ulkeText!
    ..favCityLat = provider.konumLat!
    ..favCityLong = provider.konumLong!;

    box.put(provider.konumLat, favs);
    provider.favIconCheck();
  }

  return IconButton
  (
    onPressed:() => showDialog
    (
      context: context,
      builder: (context)
      {
        if(provider.isAdded == false)
        {
          return AlertDialog
          (
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text("Konum Kaydet",style: Styles().alertTitle),
            content: Container
            (
              child: TextField
              (
                decoration: InputDecoration
                (
                  enabledBorder: UnderlineInputBorder
                  (                  
                    borderSide: BorderSide(color: Styles.softGreyColor),   
                  ),
                  focusedBorder: UnderlineInputBorder
                  (
                    borderSide: BorderSide(color: Styles.softGreyColor),
                  ),
                ),
                controller: textController,
                onChanged: (value){},            
              ),
            ),
            actions:
            [
              InkWell
              (
                borderRadius: BorderRadius.circular(24),
                onTap: ()
                {
                  if(textController.text != "")
                  {
                    _addToFavsBoxList();
                    Navigator.pop(context);
                    print(textController.text);
                  }
                },
                child: Ink
                (
                  height: 48,
                  width: 96,
                  child: Center(child: Text("kaydet",style: Styles().alertButtonText)),
                  decoration: BoxDecoration
                  (
                    color: Styles.softGreyColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          );
        }
        else
        {
          return AlertDialog
          (
            title: Text("Konumu Kaldır", style: Styles().alertTitle),
            content: Text("Konum favorilerden kaldırılsın mı?", style: Styles().cityListTextSub),
            actions:
            [
              InkWell
              (
                onTap: ()
                {
                  provider.deleteItemFromFavsBox(0,provider.konumLat!,1);
                  Navigator.pop(context);
                },
                child: Ink
                (
                  height: 48,
                  width: 128,
                  child: Center(child: Text("Kaldır",style: Styles().alertButtonText)),
                  decoration: BoxDecoration
                  (
                    color: Styles.softGreyColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ); 
        }
      },
    ),
    icon: Icon(provider.isAdded == true ? Icons.bookmark_rounded :
    Icons.bookmark_outline_rounded, color: provider.fontRenkKontrol()),
  );
}

_appbar(context)
{
  final prov = Provider.of<WeatherFetch>(context);

  return AppBar
  (
    toolbarHeight: 82,
    backgroundColor: Colors.transparent,    
    elevation: 0,
    leading: _favsButton(context),
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
      ),
      CitySheetWithButton(),
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
                style: GoogleFonts.inter(textStyle: Styles().mainDiscribeText, color: prov.fontRenkKontrol())),
                SizedBox(height: 6),
                Text("${prov.derece?.toInt()} \u2103",
                style: GoogleFonts.inter(textStyle: Styles().mainWeatherText,color: prov.fontRenkKontrol())),
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
                  ListTile
                  (
                    leading: FaIcon(FontAwesomeIcons.water,
                      color: prov.fontRenkKontrol()), 
                    title: Text("Nem",
                      style: GoogleFonts.inter(textStyle: Styles().mainDetailsText, color: prov.fontRenkKontrol())),
                    trailing: Text("% ${prov.nem}",
                      style: GoogleFonts.inter(textStyle: Styles().mainDetailsText, color: prov.fontRenkKontrol())),
                  ),
                  ListTile
                  (
                    leading: FaIcon(FontAwesomeIcons.temperatureHigh, color: prov.fontRenkKontrol()),
                    title: Text("Hissedilen",
                      style: GoogleFonts.inter(textStyle: Styles().mainDetailsText, color: prov.fontRenkKontrol())),
                    trailing: Text("${prov.hissedilen?.toInt()} \u2103",
                      style: GoogleFonts.inter(textStyle: Styles().mainDetailsText, color: prov.fontRenkKontrol())),
                  ),
                  ListTile
                  (
                    leading: FaIcon(FontAwesomeIcons.wind, color: prov.fontRenkKontrol()),
                    title: Text("Rüzgar",
                      style: GoogleFonts.inter(textStyle: Styles().mainDetailsText, color: prov.fontRenkKontrol())),
                    trailing: Text("${prov.ruzgar?.toInt()} km/s",
                      style: GoogleFonts.inter(textStyle: Styles().mainDetailsText, color: prov.fontRenkKontrol())),
                  )
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
  final weatherProvider = Provider.of<WeatherFetch>(con);

  Widget div = Divider
  (
    color: weatherProvider.fontRenkKontrol(),
    thickness: 0.1,
  );

  return SafeArea
  (
    child: Column
    (
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
      [
        Container //Saatlik Penceresi
        (
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: MediaQuery.of(con).size.height * 0.5,
          width: MediaQuery.of(con).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration
          (
            color: weatherProvider.panelRenkKontrol(), borderRadius: BorderRadius.circular(16),
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
                  Text("Günün Tahminleri",
                  style: GoogleFonts.inter(textStyle: Styles().hourlyForecastTitle, color: weatherProvider.fontRenkKontrol())),
                  Spacer(),
                  _switchButton(prov.switchIcon, ()=> prov.switchIconChange(), con),
                ],
              ),
              Container //Grafik ve Liste Penceresi
              (
                height: MediaQuery.of(con).size.height * 0.4,
                child: _hourly(prov.switchIcon, con, div),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Container //7 Günlük Tahminler
        (
          height: MediaQuery.of(con).size.height * 0.26,
          padding: const EdgeInsets.symmetric(horizontal: 8),            
          child: ListView.builder
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration
                (
                  color: weatherProvider.panelRenkKontrol(),
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
                        weatherProvider.dailyData[i].time * 1000)),
                      style: GoogleFonts.inter(textStyle: Styles().dailyForecastText,
                      color: weatherProvider.fontRenkKontrol()),
                    ),
                    div,
                    SizedBox
                    (
                      height:
                      MediaQuery.of(con).size.height * 0.1 > 80 ? 80 :
                      MediaQuery.of(con).size.height * 0.1,
                      child: DataControl().iconCheck(weatherProvider.dailyData[i].icon,false),
                    ),
                    div,
                    Text
                    (
                      "${weatherProvider.dailyData[i].day.toInt()}\u00b0 / ${weatherProvider.dailyData[i].night.toInt()}\u00b0",
                      style: GoogleFonts.inter(textStyle: Styles().dailyForecastText,
                      color: weatherProvider.fontRenkKontrol()),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

_switchButton(switchIcon, tap, context)
{
  final iconProv = Provider.of<WeatherFetch>(context);

  return InkWell
  (
    onTap: tap,
    child: Container
    (
      width: 42,
      height: 36,
      child: switchIcon == true ? Image.asset("images icons/chart_icon.png", color: iconProv.fontRenkKontrol()) :
      Image.asset("images icons/list_icon.png", color: iconProv.fontRenkKontrol()),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration
      (
        color:Colors.black12,
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

_hourly(switchIcon,con,div)
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
              style: GoogleFonts.inter(textStyle: Styles().hourlyForecastListText, color: prov.fontRenkKontrol()),
            ),
            Row(children:
            [
              Text(prov.hourlyData[index].temp.toInt().toString()+"°",
              style: GoogleFonts.inter(textStyle: Styles().hourlyForecastListText, color: prov.fontRenkKontrol())),
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
              child: Text(prov.hourlyData[index].describtion,
              style: GoogleFonts.inter(textStyle: Styles().hourlyForecastListText, color: prov.fontRenkKontrol()), textAlign: TextAlign.end),
            ),
          ]
        ),
      ),
      separatorBuilder: (BuildContext context, int index) => div,
    );
  }
}