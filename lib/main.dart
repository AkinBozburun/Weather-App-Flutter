import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:my_weather_app/pages/city_list_search.dart';
import 'package:my_weather_app/pages/weather_page.dart';
import 'package:my_weather_app/utils/db_dao.dart';
import 'package:my_weather_app/utils/weather_provider.dart';
import 'package:provider/provider.dart';

void main()
{
  initializeDateFormatting();
  Intl.defaultLocale = "tr_TR";

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

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
        theme: ThemeData
        (
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
  gecmisSehirKontrol() async
  {
    final sehirListesi = await SehirlerDAO().sehirOku();
    if (sehirListesi.isEmpty)
    {
      print("liste boş");
      Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => CityList()), (route) => false);
    }
  }

  @override
  void initState()
  {
    gecmisSehirKontrol();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => WeatherPage();
}
