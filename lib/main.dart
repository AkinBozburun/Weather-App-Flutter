import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:my_weather_app/pages/weather_page.dart';
import 'package:my_weather_app/utils/weather_provider.dart';
import 'package:provider/provider.dart';

void main() {
  initializeDateFormatting();
  Intl.defaultLocale = "tr_TR";

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //Ekran döndürmeyi iptal etme.

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WeatherFetch()),
      ],
      child: MaterialApp(
        title: 'My Weather',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: BootPage(),
      ),
    );
  }
}

class BootPage extends StatefulWidget
{
  const BootPage({Key? key}) : super(key: key);

  @override
  State<BootPage> createState() => _BootPageState();
}

class _BootPageState extends State<BootPage>
{
  _booting()
  {
    final provider = Provider.of<WeatherFetch>(context);

    if (provider.data == [])
    {
      return Scaffold
      (
        backgroundColor: Color(0xff44B0FF),
        body: Center
        (
          child: CircularProgressIndicator(),
        ),
      );
    } else
    {
      return WeatherPage();
    }
  }

  @override
  Widget build(BuildContext context) => _booting();
}
