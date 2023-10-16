import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:my_weather_app/models/fav_cities_model.dart';
import 'package:my_weather_app/pages/weather_page.dart';
import 'package:my_weather_app/utils/weather_provider.dart';
import 'package:provider/provider.dart';

void main() async
{
  initializeDateFormatting();
  Intl.defaultLocale = "tr_TR";

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Hive.initFlutter();
  Hive.registerAdapter(FavCitiesAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MultiProvider
    (
      providers:
      [
        ChangeNotifierProvider(create: (context) => WeatherFetch()),
        ChangeNotifierProvider(create: (context) => VisualProvider()),
      ],
      child: MaterialApp
      (
        title: 'My Weather',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: WeatherPage(),
      ),
    );
  }
}