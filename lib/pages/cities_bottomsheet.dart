import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_weather_app/utils/get_box.dart';
import 'package:my_weather_app/utils/styles.dart';
import 'package:my_weather_app/utils/weather_provider.dart';
import 'package:provider/provider.dart';

class CitySheetWithButton extends StatelessWidget
{
  const CitySheetWithButton({Key? key}) : super(key: key);  

  @override
  Widget build(BuildContext context) => IconButton
  (
    onPressed: () => bottomSheet(context),
    icon: Icon(Icons.keyboard_arrow_down_rounded,color: Styles.whiteColor)
  );
}

bottomSheet(context)
{
  final provider = Provider.of<VisualProvider>(context,listen: false);
  final double height = MediaQuery.of(context).size.height;

  showModalBottomSheet
  (
    context: context,
    builder: (context) => Container
    (    
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: height,
      child: Column
      (
        children:
        [
          SizedBox(height: 16),
          _searchBar(context),
          SizedBox(height: 16),        
          provider.textCheck == "" ?
          Divider(color: Styles.softGreyColor, indent: 16, endIndent: 16,thickness: 2) : Center(), 
          SizedBox(height: 16),
          provider.textCheck == "" ? _favs(context) : _sehirList(context),
        ],
      ),
    ),
    backgroundColor: Styles.whiteColor,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
  );
}

_searchBar(context)
{
  final provider = Provider.of<VisualProvider>(context);
  final providerWeather = Provider.of<WeatherFetch>(context);

  return Row
  (
    children:
    [
      Expanded //TextField
      (
        child: Container
        (
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(color: Styles.softGreyColor, borderRadius: BorderRadius.circular(12)),
          child: TextField
          (
            decoration: InputDecoration
            (
              icon: Icon(Icons.search_rounded),
              iconColor: Colors.black38,
              contentPadding: const EdgeInsets.all(4),
              hintText: "Şehir arayın...",
              border: InputBorder.none,
              hintStyle:  GoogleFonts.inter(
                fontSize: 16, color: Colors.black38, fontWeight: FontWeight.w400),
            ),
            onChanged: (value)
            {
              provider.textBool(value);
              providerWeather.citySearch(value);
            },            
          ),
        ),
      ),
      InkWell //Location Button
      (
        onTap:()
        {
          providerWeather.izinKontrol();
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Ink
        (
          height: 46, width: 46,
          child: Center(child: Icon(Icons.gps_fixed_rounded,color: Styles.blackColor)),
          decoration: BoxDecoration
          (
            color: Styles.softGreyColor,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ],
  );
}

_sehirList(context)
{
  final prov = Provider.of<WeatherFetch>(context);
  final prov2 = Provider.of<VisualProvider>(context);

  return Container
  (
    height: MediaQuery.of(context).size.height*0.5,
    width: MediaQuery.of(context).size.width,
    child: ListView.separated
    (
      itemCount: prov.citySearchList.length,
      itemBuilder: (context, index)
      {
        String turkeyCheck = prov.citySearchList[index].country == "Turkey" ?
        "Türkiye" :  prov.citySearchList[index].country;

        return ListTile
        (
          onTap: ()
          {
            prov.fetchData(prov.citySearchList[index].city, turkeyCheck,
            prov.citySearchList[index].lati, prov.citySearchList[index].long);
            prov2.clearText();
            Navigator.pop(context);
          },
          title: Text(prov.citySearchList[index].city, style: Styles().cityListText),
          subtitle: Text(turkeyCheck,style: Styles().cityListTextSub),
        );
      },
      separatorBuilder: (context, index)
      => Divider(color: Styles.softGreyColor, indent: 16, endIndent: 16,thickness: 2),
    ),
  );
}

_favs(context)
{
  final boxList = Boxes.getFavs().values.toList();

  final prov = Provider.of<WeatherFetch>(context,listen: false);

  return Column
  (
    children:
    [
      Row(children:
      [
        Icon(Icons.bookmark_rounded,color: Styles.blackColor),
        SizedBox(width: 8), Text("Kayıtlı Konumlar", style: Styles().bottomSheetText2)
      ]),
      SizedBox(height: 16),
      boxList.isNotEmpty? Container
      (
        height: 48,
        child: ListView.separated
        (
          scrollDirection: Axis.horizontal,
          itemCount: boxList.length,
          itemBuilder: (context, index) => InkWell
          (
            borderRadius: BorderRadius.circular(12),
            onTap: () 
            {
              prov.fetchData(boxList[index].favCityName, boxList[index].favCityCountry,
              boxList[index].favCityLat.toString(), boxList[index].favCityLong.toString());
              Navigator.pop(context);
            },
            onLongPress: () => prov.deleteItemFromFavsBox(index,prov.konumLat!,0),
            child: Ink
            (
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: Text(boxList[index].favCityName,style: Styles().favsText)),
              decoration: BoxDecoration
              (
                color: Styles.softGreyColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          separatorBuilder: (context, index) => SizedBox(width: 16),
        ),
      ) : Text("Favori buraya konumlarınızı ekleyebilirsiniz",style: Styles().favsText),
    ],
  );
}