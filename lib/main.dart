import 'dart:async';
import 'dart:convert';

import 'package:covid_app/country_dropdown.dart';
import 'package:covid_app/weekly_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.blue, // navigation bar color
    statusBarColor: Color(int.parse("0xFF4739f7")), // status bar color
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int i = 1;
  List country = ['NP', 'IN', 'AE', 'AU', 'UK', 'JP', 'US', 'CA', 'HK'];
  List data;
  var dats;
  int newDailyCase = 0;
  int newDailyDeath = 0;
  int totalCase = 0;
  int totalDeath = 0;
  bool datafetched = false;
  String defaultCountry = 'NP';
  List<dynamic> dataMap;
  Map<String, dynamic> dm = new Map();
  var listOfDates = [];

  Future<Null> getNewData() async {
    http.Response response = await http.get(
        Uri.encodeFull(
            "https://api.thevirustracker.com/free-api?countryTimeline=$defaultCountry"),
        headers: {"Accept": "application/json"});

    setState(() {
      dataMap = json.decode(response.body)['timelineitems'];
      dm = dataMap[0];
      dm.forEach((k, v) => listOfDates.add(k.toString()));
      String latestdate = listOfDates[listOfDates.length - 2];
      newDailyCase = dm[latestdate]['new_daily_cases'];
      newDailyDeath = dm[latestdate]['new_daily_deaths'];
      totalCase = dm[latestdate]['total_cases'];
      totalDeath = dm[latestdate]['total_deaths'];
      datafetched = true;
    });
    return null;
  }

  callback(selectedDropdownData) {
    setState(() {
      defaultCountry = selectedDropdownData;
      getNewData();
    });
  }

  @override
  void initState() {
    super.initState();
    getNewData();
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment(0.0, -0.9),
                      height: 250.0,
                      decoration: BoxDecoration(
                          borderRadius: new BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0)),
                          color: _getColorFromHex('#4739f7'),
                          image: DecorationImage(
                              image: AssetImage('assets/doctornurse.png'))),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 20, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Center(
                            child: CountryDropdown(
                                countries: country,
                                currentCountry: defaultCountry,
                                callback: callback),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(25.0, 200.0, 25.0, 0.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(blurRadius: 2.0, color: Colors.grey)
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                padding:
                                    EdgeInsets.fromLTRB(25.0, 25.0, 5.0, 5.0),
                                child: Text('New Cases',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0)),
                              ),
                              Container(
                                padding:
                                    EdgeInsets.fromLTRB(25.0, 40.0, 5.0, 5.0),
                                child: Text('$newDailyCase',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Volte',
                                        fontSize: 40.0)),
                              )
                            ],
                          ),
                          SizedBox(width: 70.0),
                          GestureDetector(
                            onTap: () {
                              //getNewData();
                            },
                            child: Container(
                              height: 50.0,
                              width: 120.0,
                              decoration: BoxDecoration(
                                  color: _getColorFromHex('#f05457'),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Center(
                                child: Text('Learn More',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20.0),
                GridView.count(
                  crossAxisCount: 2,
                  primary: false,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 4.0,
                  shrinkWrap: true,
                  childAspectRatio: (2 / 1.1),
                  children: <Widget>[
                    _buildCard('Total Cases', totalCase.toString(), 1,
                        _getColorFromHex('#8668fd')),
                    _buildCard('Total Death', totalDeath.toString(), 2,
                        _getColorFromHex('#f05458')),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
                  child: Text(
                    'Daily New Cases',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Volte',
                        fontWeight: FontWeight.normal,
                        fontSize: 20),
                  ),
                ),
                loadChart(),
              ],
            ),
            onRefresh: getNewData));
  }

  String dropdownValue = 'One';

  loadChart() {
    if (datafetched) {
      return WeeklyChart(this.listOfDates, this.dm);
    } else {
      return Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget genDropdown() {
    return Container(
        height: 35,
        width: 90,
        alignment: Alignment(0.0, -0.9),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.black45)],
            borderRadius: BorderRadius.circular(20.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        'https://www.countryflags.io/AU/shiny/64.png')),
              ),
            ),
            Container(
                child: DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(Icons.arrow_drop_down,
                  color: _getColorFromHex('#61688A')),
              iconSize: 24,
              elevation: 20,
              dropdownColor: Colors.white,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Volte',
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
              underline: Container(
                color: Colors.white,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items: <String>['One', 'Two', 'Free', 'Four']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ))
          ],
        ));
  }

  Widget _buildCard(
      String name, String status, int cardIndex, Color colorcode) {
    return Container(
      height: 20.0,
      child: Card(
          color: colorcode,
          elevation: 2.0,
          margin: EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 10.0, top: 10.0),
                    child: Text(
                      name,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Volte',
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 10.0, top: 10.0),
                    child: Text(
                      status,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Volte',
                        fontSize: 25.0,
                      ),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}
