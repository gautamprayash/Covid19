import 'package:fl_chart/fl_chart.dart' as flchart;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyChart extends StatelessWidget {
  var dates = [];
  Map<String, dynamic> data;
  int noOfDays = 5;

  WeeklyChart(var dates, Map data) {
    this.dates = dates;
    this.data = data;
  }

  String chk(double value) {
    int index = dates.length - 1 - noOfDays + value.round();
    return convertDateFromString(dates[index].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: AspectRatio(
                aspectRatio: 1.7,
                child: flchart.BarChart(flchart.BarChartData(
                    barGroups: getBarGroups(dates, data),
                    borderData: flchart.FlBorderData(show: false),
                    titlesData: flchart.FlTitlesData(
                        leftTitles: flchart.SideTitles(showTitles: false),
                        bottomTitles: flchart.SideTitles(
                            showTitles: true,
                            getTitles: (double value) {
                              return chk(value);
                            },
                            textStyle: TextStyle(
                              fontFamily: 'Volte',
                              color: Colors.black,
                            ))))),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

String convertDateFromString(String strDate) {
  var month = '0';
  var arrayDate = strDate.split('/');
  var year = '20' + arrayDate[2];
  var day = arrayDate[1];
  if (arrayDate[0].length == 1) {
    month += arrayDate[0];
  } else {
    month = arrayDate[0];
  }
  String finalStringDate = year + month + day;
  var formatter = new DateFormat('MMMM d');
  String formatted = formatter.format(DateTime.parse(finalStringDate));
  return formatted;
}

getBarGroups(dates, data) {
  List<double> newCase = <double>[];
  List<flchart.BarChartGroupData> barChartGroups = [];
  for (var i = dates.length - 6; i < dates.length - 1; i++) {
    newCase.add(data[dates[i]]['new_daily_cases'].toDouble());
  }

  newCase.asMap().forEach(
        (j, value) => barChartGroups.add(
          flchart.BarChartGroupData(
            x: j,
            barRods: [
              flchart.BarChartRodData(
                y: value,
                width: 16,
              )
            ],
          ),
        ),
      );
  return barChartGroups;
}
