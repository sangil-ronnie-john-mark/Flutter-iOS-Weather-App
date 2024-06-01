import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ios/settings.dart';
import 'variables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';
void main() async{
  await Hive.initFlutter();

  var box = await Hive.openBox('database');

  runApp(CupertinoApp(
      theme: CupertinoThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: Homepage()
  ));
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var box = Hive.box('database');
  Future<void> hiveOperations() async{


    if (box.get('city') == null){
      print("null metric");
      box.put('city', "San Fernando");
      box.put('iconColors', "CupertinoColors.destructiveRed");
      box.put('metric', true);
    } else {
     box.put('city', box.get('city'));

     box.put('metric', box.get('metric'));
     if (box.get('iconColors') == "CupertinoColors.activeBlue") {
       iconColors = CupertinoColors.activeBlue;
     } else if (box.get('iconColors') == "CupertinoColors.destructiveRed") {
       iconColors = CupertinoColors.destructiveRed;
     } else if (box.get('iconColors') == "CupertinoColors.systemPurple") {
       iconColors = CupertinoColors.systemPurple;
     } else if (box.get('iconColors') == "CupertinoColors.activeGreen") {
       iconColors = CupertinoColors.activeGreen;
     }
    }
    city = box.get('city');
    metric = box.get('metric');
    if (box.get('iconColors') == "CupertinoColors.activeBlue") {
      iconColors = CupertinoColors.activeBlue;
    } else if (box.get('iconColors') == "CupertinoColors.destructiveRed") {
      iconColors = CupertinoColors.destructiveRed;
    } else if (box.get('iconColors') == "CupertinoColors.systemPurple") {
      iconColors = CupertinoColors.systemPurple;
    } else if (box.get('iconColors') == "CupertinoColors.activeGreen") {
      iconColors = CupertinoColors.activeGreen;
    }
  }
  String? cod;
  String? temp;
  double? heat_index;
  int? humidity;
  String? weather;
  double? windSpeed;
  String? cityName;
  IconData? iconWeather;
  //function to get new city from the settings
  void getNewLocationFromSettings() async{
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => Settings()),
    );
    print(city);
    // re run the function with the new settings
    getData(box.get('city'), box.get('metric'));
  }

  // function to get weather data from the api
  Future<void> getData(String location, bool m) async {
    hiveOperations();
    String url = "https://api.openweathermap.org/data/2.5/forecast?q=$location&appid=$apiKey";
    try {
      final response = await http.get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> data = jsonDecode(response.body);
          cityName = data['city']['name'];
          cod = data['cod'];
          if (m == true) {
            temp = (data['list'][0]['main']['temp'] - 273.15).toStringAsFixed(0);
            heat_index = data['list'][0]['main']['feels_like'] - 273.15;

          } else if (m == false){

            temp = ((data['list'][0]['main']['temp'] - 273.15) * 1.8 + 32).toStringAsFixed(0);
            heat_index = (data['list'][0]['main']['feels_like'] - 273.15) * 1.8 + 32;
          }

          humidity = data['list'][0]['main']['humidity'];
          weather = data['list'][0]['weather'][0]['description'];
          windSpeed = data['list'][0]['wind']['speed'];

          if (weather!.contains('clouds')){
            iconWeather = CupertinoIcons.cloud;
          } else if (weather!.contains('rain')) {
            iconWeather = CupertinoIcons.cloud_rain;
          } else if (weather!.contains('thunderstorm')) {
            iconWeather = CupertinoIcons.cloud_bolt_rain;
          } else if (weather!.contains('snow')) {
            iconWeather = CupertinoIcons.snow;
          } else if (weather!.contains('clear')) {
            iconWeather = CupertinoIcons.sun_dust;
          }

        });

      }
    } catch (e) {
      Timer(Duration(seconds: 2), () {
        showCupertinoDialog(context: context, builder: (context){
          return CupertinoAlertDialog(
            title: Text('Server Error'),
            content: Text('No internet connection'),
            actions: [
              CupertinoButton(child: Text('Retry'), onPressed: (){

                getData(city!, metric!);
                Navigator.pop(context);
              })
            ],
          );
        });
      });

    }


  }

  @override
  void initState() {

     hiveOperations();

    getData(box.get('city'), box.get('metric'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('iWeather'),
          trailing: CupertinoButton(
            child: Icon(CupertinoIcons.gear, color: iconColors,),
            onPressed: () async {
              getNewLocationFromSettings();
            },
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: cod == "200"? Column(
                children: [
                  Text(
                    'My Location',
                    style: TextStyle(fontSize: 30),
                  ),
                  Text('$cityName', style: TextStyle(fontSize: 15)),
                  Text('$temp°', style: TextStyle(fontSize: 65)),
                  SizedBox(height: 21,),
                  Icon(iconWeather, size: 100, color: iconColors,),
                  SizedBox(height: 20,),
                  Text('$weather'),
                  Text('H: $humidity% W: $windSpeed kph'),

                ],
              ) : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Loading'),
                    SizedBox(height: 20,),
                    CupertinoActivityIndicator(),
                  ],
                ),
              )
            ),
          ),
        ),
      );
  }
}
