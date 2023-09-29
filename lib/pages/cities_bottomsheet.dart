import 'package:flutter/material.dart';
import 'package:my_weather_app/utils/styles.dart';
import 'package:my_weather_app/utils/weather_provider.dart';
import 'package:provider/provider.dart';

class CitySheetWithButton extends StatelessWidget
{
  const CitySheetWithButton({Key? key}) : super(key: key);  

  @override
  Widget build(BuildContext context)
  {
    return IconButton
    (
      onPressed: () => showModalBottomSheet
      (
        context: context,
        builder: (context) => _bottomSheet(context),
        backgroundColor: Styles.whiteColor,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: true,        
      ),
      icon: Icon(Icons.keyboard_arrow_down_rounded,color: Styles.whiteColor)
    );
  }
}

_bottomSheet(context)
{
  final provider = Provider.of<WeatherFetch>(context);
  final radius = Radius.circular(24);
  return Container
  (
    margin: const EdgeInsets.symmetric(horizontal: 16),
    height: MediaQuery.of(context).size.height,
    decoration: BoxDecoration
    (
      borderRadius: BorderRadius.only(topLeft: radius,topRight: radius)
    ),
    child: Column
    (
      children:
      [
        SizedBox(height: 16),
        _searchBar(context),
        SizedBox(height: 16),        
        provider.textCheck == "" ?
        Divider(color: Styles.softGreyColor, indent: 16, endIndent: 16,thickness: 2) : Center(),
        _sehirList(context),
        SizedBox(height: 16),
        _favs(),
      ],
    ),
  );
}

_searchBar(context)
{
  final provider = Provider.of<WeatherFetch>(context);

  return Row
  (
    children:
    [
      Expanded
      (
        child: Container
        (
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(color: Styles.softGreyColor, borderRadius: BorderRadius.circular(12)),
          child: TextField
          (
            decoration: InputDecoration
            (
              contentPadding: const EdgeInsets.all(4),
              hintText: "Aramak için tıklayın...",
              border: InputBorder.none,
              hintStyle: Styles().bottomSheetText1,
            ),
            onChanged: (value) => provider.textBool(value),
            
          ),
        ),        
      ),
      Container
      (
        height: 46, width: 46,
        child: Center(child: Icon(Icons.location_city)),
        decoration: BoxDecoration
        (
          color: Styles.softGreyColor,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ],
  );
}

_sehirList(context)
{
  final provider = Provider.of<WeatherFetch>(context);

  return Column
  (
    children:
    [
      if(provider.textCheck == "") Center() else Container
      (
        height: MediaQuery.of(context).viewInsets.bottom*0.8,
        width: MediaQuery.of(context).size.height*0.8,
        child: ListView.separated
        (
          itemCount: 6,
          itemBuilder: (context, index) => ListTile
          (
            title: Text("Istanbul",style: Styles().cityListText),
            subtitle: Text("Türkiye",style: Styles().cityListTextSub),                  
          ),
          separatorBuilder: (context, index) => 
          Divider(color: Styles.softGreyColor, indent: 16, endIndent: 16,thickness: 2),
        ),
      ),
    ],
  );
}

_favs()
{
  return Positioned
  (
    child: Container
    (
      height: 106,
      color: Colors.red,
      child: Column
      (
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        [
          Row(children: [Icon(Icons.favorite_rounded),SizedBox(width: 8), Text("Kayıtlı Konumlar",
          style: Styles().bottomSheetText2)]),
          Container
          (
            height: 64,
            child: ListView.builder
            (
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) => Container
              (
                margin: const EdgeInsets.only(top: 16,right: 16),            
                width: 81,
                child: Center(child: Text("Ataevler",style: Styles().favsText)),
                decoration: BoxDecoration
                (
                  color: Styles.softGreyColor,
                  borderRadius: BorderRadius.circular(12)
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}