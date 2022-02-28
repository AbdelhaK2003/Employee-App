// ignore_for_file: prefer_const_constructors, unused_import, use_key_in_widget_constructors

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Colors.white,
      body: Searchtools(),
    );
  }
}

class Searchtools extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();
  String CityDB = "";
  static const cities = [
    "Casablanca",
    "Fez",
    "Tangier",
    "Marrakesh",
    "Salé",
    "Meknes",
    "Rabat",
    "Oujda",
    "Kenitra",
    "Agadir",
    "Tetouan",
    "Temara",
    "Safi",
    "Mohammedia",
    "Khouribga",
    "El Jadida",
    "Beni Mellal",
    "Ait Melloul",
    "Nador",
    "Dar Bouazza",
    "Taza",
    "Settat",
    "Berrechid",
    "Khemisset",
    "Inezgane",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Form(
            key: this._formKey,
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: TypeAheadField(
                suggestionsCallback: (pattern) => cities.where((item) => item
                    .toString()
                    .toLowerCase()
                    .contains(pattern.toLowerCase())),
                itemBuilder: (_, String item) => ListTile(title: Text(item)),
                onSuggestionSelected: (String city) {
                  this._textEditingController.text = city;
                  print(city);
                  CityDB = city;
                },
                getImmediateSuggestions: true,
                hideSuggestionsOnKeyboardHide: false,
                hideOnEmpty: false,
                noItemsFoundBuilder: (context) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('No item found'),
                ),
                textFieldConfiguration: TextFieldConfiguration(
                  decoration: InputDecoration(
                    hintText: 'Enter a city ',
                    labelText: "City",
                    border: OutlineInputBorder(),
                  ),
                  controller: this._textEditingController,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 250,
            height: 50,
            child: ElevatedButton(
              child: const Text('Search'),
              onPressed: () {
                //TO-DO : Search for the selected choices in DataBase
                //and move to another page or change the contenue of the search page
              },
            ),
          ),
        ],
      ),
    );
  }
}
