import 'package:flutter/material.dart';
class CountryDropdown extends StatefulWidget {

  final countries;
  var currentCountry;
  Function (String) callback;

  CountryDropdown({@required this.countries,@required this.currentCountry,this.callback});

  @override
  _CountryDropdownState createState() => _CountryDropdownState();
}

class _CountryDropdownState extends State<CountryDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 90,
      alignment: Alignment(0.0, -0.9),
      decoration: BoxDecoration(
          color: Colors.white,boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.black45)], borderRadius: BorderRadius.circular(20.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage('https://www.countryflags.io/'+widget.currentCountry+'/shiny/64.png')
              ),
            ),
          ),
          Container(
            child: DropdownButton<String>(
        value: widget.currentCountry,
        icon: Icon(Icons.arrow_drop_down, color: Colors.black),
        iconSize: 24,
        elevation: 20,
        dropdownColor: Colors.white,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Volte',
          fontWeight: FontWeight.bold,
          fontSize: 15  
        ),
        underline: Container(
          color: Colors.white,
        ),
        onChanged:(String newValue){
          widget.callback(newValue);
          setState(() {
            widget.currentCountry= newValue;
          });
        } ,
        items: <String>['NP','IN','AE','AU','GB','JP','US','CA']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black
              ),
            ),
          );
        }).toList(),
      )
          )
        ],
      )
    );
  }
}
