import 'dart:async';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'variables.dart';
class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {


  //function that verifies the valid location
  Future<void> verifyLocation() async {

    String url = "https://api.openweathermap.org/data/2.5/forecast?q="+_location.text+"&appid=$apiKey";
    final response = await http.get(
      Uri.parse(url)
    );

    Map<String,dynamic> data = jsonDecode(response.body);
    print(data['cod']);
    if (data['cod'] == "200") {
        print('valid city');
        setState(() {
        box.put('city', _location.text);
        city = box.get('city');
        });
    } else if(data['cod'] == "404") {
      print('invalid city');

      showCupertinoDialog(context: context, builder: (context){
        return CupertinoAlertDialog(
          title: Text('Error'),
          content: Text('City not found'),
          actions: [
            CupertinoButton(child: Text('Close'), onPressed: (){
              _location.text = city!;
              Navigator.pop(context);
            })
          ],
        );
      });
    }
  }
  TextEditingController _location = TextEditingController(text: city);
  var box = Hive.box('database');
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Settings'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back, color: Colors.white,), onPressed: (){
            Navigator.pop(context);
        },)
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: ListView(
                      children: [
                          CupertinoListTile(title: GestureDetector(
                            onTap: (){
                              showCupertinoDialog(context: context, builder: (context){
                                return CupertinoAlertDialog(
                                  title: Text('Location'),
                                  content: Column(
                                    children: [
                                      SizedBox(height: 10,),
                                      CupertinoTextField(
                                        controller: _location,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    CupertinoButton(child: Text('Save'), onPressed: (){
                                      verifyLocation();
                                      Navigator.pop(context);
                                    }),
                                    CupertinoButton(child: Text('Close', style: TextStyle(color: CupertinoColors.destructiveRed),), onPressed: (){
                                      Navigator.pop(context);
                                    })
                                  ],
                                );
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(

                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7),
                                              color: Colors.orange[700]
                                          ),
                                          child: Icon(CupertinoIcons.location_fill, color: Colors.white,)
                                      ),
                                      SizedBox(width: 20,),
                                      Text('Location'),

                                    ],
                                  ),
                                  // this is on the right side of the row
                                  Row(
                                    children: [
                                      Text('$city'),
                                      SizedBox(width: 10,),
                                      Icon(CupertinoIcons.right_chevron, size: 20, color: Colors.white,)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )),
                        Divider(thickness: 1, indent: 20, endIndent: 20,),

                        // start of list tile
                        CupertinoListTile(title: GestureDetector(
                          onTap: (){
                            showCupertinoDialog(context: context, builder: (context){
                              return CupertinoAlertDialog(
                                title: Text('Icon Color'),
                                content: Row(
                                  children: [
                                    CupertinoButton(child: Icon(CupertinoIcons.circle_fill, color: CupertinoColors.destructiveRed,), onPressed: (){
                                      setState(() {
                                        iconColors = CupertinoColors.destructiveRed;
                                        box.put('iconColors', 'CupertinoColors.destructiveRed');
                                      });
                                      Navigator.pop(context);
                                    }),
                                    CupertinoButton(child: Icon(CupertinoIcons.circle_fill, color: CupertinoColors.activeBlue,), onPressed: (){
                                      setState(() {
                                        iconColors = CupertinoColors.activeBlue;
                                        box.put('iconColors', 'CupertinoColors.activeBlue');
                                      });
                                      Navigator.pop(context);
                                    }),
                                    CupertinoButton(child: Icon(CupertinoIcons.circle_fill, color: CupertinoColors.activeGreen,), onPressed: (){
                                      setState(() {
                                        iconColors = CupertinoColors.activeGreen;
                                        box.put('iconColors', 'CupertinoColors.activeGreen');
                                      });
                                      Navigator.pop(context);
                                    }),
                                    CupertinoButton(child: Icon(CupertinoIcons.circle_fill, color: CupertinoColors.systemPurple,), onPressed: (){
                                      setState(() {
                                        iconColors = CupertinoColors.systemPurple;
                                        box.put('iconColors', 'CupertinoColors.systemPurple');
                                      });
                                      Navigator.pop(context);
                                    }),

                                  ],
                                ),
                                actions: [

                                  CupertinoButton(child: Text('Close', style: TextStyle(color: CupertinoColors.destructiveRed),), onPressed: (){
                                    Navigator.pop(context);
                                  }),
                                ],
                              );
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.systemPink,
                                      borderRadius: BorderRadius.circular(6)
                                    ),
                                    padding: EdgeInsets.all(6),
                                    child: Icon(CupertinoIcons.color_filter, color: Colors.white,)
                                  ),
                                  SizedBox(width: 20,),
                                  Text('Icon'),

                                ],
                              ),

                              // right side
                              Row(
                                children: [
                                    Icon(CupertinoIcons.circle_fill, color: iconColors,),
                                    SizedBox(width: 10,),
                                    Icon(CupertinoIcons.right_chevron, color: Colors.white, size: 20,)
                                ],
                              )
                            ],),
                          ),
                        )),
                        Divider(thickness: 1, indent: 20, endIndent: 20,),
                        // end of list tile

                        // start of list tile
                        CupertinoListTile(title: GestureDetector(
                          onTap: (){
                            setState(() {
                              metric = !metric!;
                            });
                            print(metric);
                          },
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(

                                        decoration: BoxDecoration(
                                            color: CupertinoColors.systemGreen,
                                            borderRadius: BorderRadius.circular(6)
                                        ),
                                        padding: EdgeInsets.all(6),
                                        child: Icon(CupertinoIcons.gauge, color: Colors.white,)
                                    ),
                                    SizedBox(width: 20,),
                                    Text('Metric System'),

                                  ],
                                ),

                                // right side
                                Row(
                                  children: [
                                    CupertinoSwitch(value: box.get('metric'), onChanged: (value){
                                      setState(() {
                                        box.put('metric', value);
                                      });
                                      print(box.get('metric'));
                                    })
                                  ],
                                )
                              ],),
                          ),
                        )),
                        Divider(thickness: 1, indent: 20, endIndent: 20,),
                        // end of list tile


                        // start of list tile
                        CupertinoListTile(title: GestureDetector(
                          onTap: (){
                            print('HELLO');
                          },
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(

                                        decoration: BoxDecoration(
                                            color: CupertinoColors.systemYellow,
                                            borderRadius: BorderRadius.circular(6)
                                        ),
                                        padding: EdgeInsets.all(6),
                                        child: Icon(CupertinoIcons.light_max, color: Colors.white,)
                                    ),
                                    SizedBox(width: 20,),
                                    Text('Light Mode'),

                                  ],
                                ),

                                // right side
                                Row(
                                  children: [
                                    CupertinoSwitch(value: false, onChanged: (value){

                                    })
                                  ],
                                )
                              ],),
                          ),
                        )),
                        Divider(thickness: 1, indent: 20, endIndent: 20,),
                        // end of list tile

                        // start of list tile
                        CupertinoListTile(title: GestureDetector(
                          onTap: (){
                            print('HELLO');
                          },
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(

                                        decoration: BoxDecoration(
                                            color: CupertinoColors.activeBlue,
                                            borderRadius: BorderRadius.circular(6)
                                        ),
                                        padding: EdgeInsets.all(6),
                                        child: Icon(CupertinoIcons.info, color: Colors.white,)
                                    ),
                                    SizedBox(width: 20,),
                                    Text('About'),

                                  ],
                                ),

                                // right side
                                Row(
                                  children: [
                                    Text('Version: 1.0'),
                                    SizedBox(width: 10,),
                                    Icon(CupertinoIcons.right_chevron, color: Colors.white, size: 20,)
                                  ],
                                )
                              ],),
                          ),
                        )),
                        Divider(thickness: 1, indent: 20, endIndent: 20,),
                        // end of list tile


                      ],
                    ),
                  ),
                ),
          ),
        ));
  }
}
