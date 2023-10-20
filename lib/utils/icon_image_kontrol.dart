import 'package:flutter/material.dart';

class DataControl
{
  iconCheck(gelenIcon,shadowOk)
  {
    switch(gelenIcon)
    {
      case "01d" :
      case "01n" :
      return Container
      (
        width: 200,
        height: 200,
        child: Image.asset("images icons/sunny.png"),
        decoration:
        BoxDecoration
        (
          shape: BoxShape.circle,
          boxShadow:
          [
            BoxShadow(color: shadowOk == false ? Colors.transparent : Colors.amber.shade300 ,blurRadius: 100,spreadRadius: -6),
          ]
        ),
      );

      case "02d" :
      case "02n" :
      return Container
      (
        width: 200,
        height: 200,
        child: Image.asset("images icons/sun cloud.png"),
        decoration: BoxDecoration
        (
          shape: BoxShape.circle,
          boxShadow:
          [
            BoxShadow(color: shadowOk == false ? Colors.transparent :  Colors.yellow.shade50,blurRadius: 100,spreadRadius: -6),
          ]
        ),
      );

      case "03d" :
      case "03n" :
      return Container
      (
        width: 200,
        height: 200,
        child: Image.asset("images icons/cloudy.png"),
        decoration: BoxDecoration
        (
          shape: BoxShape.circle,
          boxShadow:
          [
            BoxShadow(color: shadowOk == false ? Colors.transparent :  Colors.grey.shade300,blurRadius: 100,spreadRadius: -6),
          ]
        ),
      );

      case "04d" :
      case "04n" :
      return Container
      (
        width: 200,
        height: 200,
        child: Image.asset("images icons/broken clouds.png"),
        decoration: BoxDecoration
        (
          shape: BoxShape.circle,
          boxShadow:
          [
            BoxShadow(color: shadowOk == false ? Colors.transparent  :  Colors.white60,blurRadius: 100,spreadRadius: -6),
          ]
        ),
      );

      case "09d" :
      case "09n" :
      return Container
      (
        width: 200,
        height: 200,
        child: Image.asset("images icons/shower rain.png"),
        decoration: BoxDecoration
        (
          shape: BoxShape.circle,
          boxShadow:
          [
            BoxShadow(color: shadowOk == false ? Colors.transparent :  Colors.blueGrey.shade600,blurRadius: 100,spreadRadius: -6),
          ]
        ),
      );

      case "10d" :
      case "10n" :
      return Container
      (
        width: 200,
        height: 200,
        child: Image.asset("images icons/sun-shower.png"),
        decoration: BoxDecoration
        (
          shape: BoxShape.circle,
          boxShadow:
          [
            BoxShadow(color: shadowOk == false ? Colors.transparent :  Colors.black26,blurRadius: 100,spreadRadius: -6),
          ]
        ),
      );

      case "11d" :
      case "11n" :
      return Container
      (
        width: 200,
        height: 200,
        child: Image.asset("images icons/storm.png"),
        decoration: BoxDecoration
        (
          shape: BoxShape.circle,
          boxShadow:
          [
            BoxShadow(color: shadowOk == false ? Colors.transparent :  Colors.yellow.shade100,blurRadius: 100,spreadRadius: -6),
          ]
        ),
      );

      case "13d" :
      case "13n" :
      return Container
      (
        width: 200,
        height: 200,
        child: Image.asset("images icons/snow.png"),
        decoration: BoxDecoration
        (
          shape: BoxShape.circle,
          boxShadow:
          [
            BoxShadow(color: shadowOk == false ? Colors.transparent :  Colors.white,blurRadius: 100,spreadRadius: -6),
          ]
        ),
      );

      case "50d" :
      case "50n" :
      return Container
      (
        width: 200,
        height: 200,
        child: Image.asset("images icons/fog.png"),
        decoration: BoxDecoration
        (
          shape: BoxShape.circle,
          boxShadow:
          [
            BoxShadow(color: shadowOk == false ? Colors.transparent :  Colors.white,blurRadius: 100,spreadRadius: -6),
          ]
        ),
      );
      default: return Center();
    }
  }

  backGroundCheck(gelenIcon,gelenH,gelenW,pageView)
  {
    Duration dur = const Duration(milliseconds: 400);

    switch(gelenIcon)
    {
      case "01d" :  //Açık hava
      case "01n" :
      return AnimatedContainer
      (
        duration: dur,
        height: gelenH,
        width: gelenW,
        decoration: const BoxDecoration
        (
          gradient: LinearGradient
          (
            colors:
            [
              Color(0xFF4A91FF),
              Color(0xFF47BFDF),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
          ),
        ),
        child: pageView,
      );

      case "02d" : //parçalı bulut
      case "02n" :
      return AnimatedContainer
      (
        duration: dur,
        height: gelenH,
        width: gelenW,
        decoration: const BoxDecoration
        (
          gradient: LinearGradient
          (
            colors:
            [
              Color(0xFF0082F0),
              Color(0xFF669ef6),
              Color(0xFF88C6FC),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
          ),
        ),
        child: pageView,        
      );

      case "03d" : //Bulutlu
      case "03n" :
      return AnimatedContainer
      (
        duration: dur,
        height: gelenH,
        width: gelenW,
        decoration: const BoxDecoration
        (
          gradient: LinearGradient
          (
            colors:
            [
              Color(0xFF8ba5c0),
              Color(0xFF94b2d1),
              Color(0xFFa2b7d1),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
          ),
        ),
        child: pageView,
      );

      case "04d" : //Parçalı Bulutlu
      case "04n" :
      return AnimatedContainer
      (
        duration: dur,
        height: gelenH,
        width: gelenW,
        decoration:  BoxDecoration
        (
          gradient: LinearGradient
          (
            colors:
            [
              Colors.blue.shade600,
              Colors.blueGrey.shade600,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
          ),
        ),
        child: pageView,
      );

      case "09d" : //Sağnak Yağmur
      case "09n" :
      return AnimatedContainer
      (
        duration: dur,
        height: gelenH,
        width: gelenW,
        decoration: const BoxDecoration
        (
          gradient: LinearGradient
          (
            colors:
            [
              Color(0xFF4a5461),
              Color(0xFF45526d),
              Color(0xFF3e4962),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
          ),
        ),
        child: pageView,
      );

      case "10d" : //Orta Yağmur
      case "10n" :
      return AnimatedContainer
      (
        duration: dur,
        height: gelenH,
        width: gelenW,
        decoration: const BoxDecoration
        (
          gradient: LinearGradient
          (
            colors:
            [

              Color(0xFF044a6c),
              Color(0xFF006292),
              Color(0xFF5d87a1),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: pageView,
      );

      case "11d" : //Fırtına
      case "11n" :
      return AnimatedContainer
      (
        duration: dur,
        height: gelenH,
        width: gelenW,
        decoration: const BoxDecoration
        (
          gradient: LinearGradient
          (
            colors:
            [
              Color(0xFF34495e),
              Color(0xFF2c3c4d),
              Color(0xFF405160),
              Color(0xFF51677d),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
          ),
        ),
        child: pageView,
      );

      case "13d" : //Kar Yağışlı
      case "13n" :
      return AnimatedContainer
      (
        duration: dur,
        height: gelenH,
        width: gelenW,
        decoration: const BoxDecoration
        (
          gradient: LinearGradient
          (
            colors:
            [
              Color(0xFFdddddd),
              Color(0xFFc6dbe7),
              Color(0xFFc6dbe7),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
          ),
        ),
        child: pageView,
      );

      case "50d" : //Sisli
      case "50n" :
      return AnimatedContainer
      (
        duration: dur,
        height: gelenH,
        width: gelenW,
        decoration: BoxDecoration
        (
          gradient: LinearGradient
          (
            colors:
            [
              Color(0xFF7c959d),
              Color(0xFF96a8ae),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
          ),
        ),
        child: pageView,
      );
      default : return Container(width: gelenW,height: gelenH, color: Colors.white);
    }
  }
}