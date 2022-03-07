// ignore_for_file: prefer_const_constructors, unnecessary_this

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'ResultsOfsearch.dart';

class SearchFields extends StatefulWidget {
  String JobDB = "";

  //const SearchFields({Key? key}) : super(key: key);
  @override
  State<SearchFields> createState() => _SearchFieldsState();
}

class _SearchFieldsState extends State<SearchFields> {
  //The selected job type  --------------------------------->
  //And the variable to use in DataBase for search for this type of employees !!!!
  String JobType = 'Professor';
  final Joblist = [
    'Professor',
    'Carpenter',
    'Plumber',
    'Mechanical',
    'Smith'
  ]; //used var !!!

  //These variables are for The Form widget below !!!
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController minController = new TextEditingController();
  final TextEditingController maxController = new TextEditingController();

  //And these two are for db variable and all the cities in our app !!!

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
  String CityDB = ""; // TO-DO : we need to add the city of the current user
  String JobDB = "";
  int minDB = 0;
  int maxDB = 9999;
  //var to know if the max bigger than min and allow display a text error
  String error = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(Colors.white.value)),
        title: Text("Search"),
        backgroundColor: Color(0xEB1E1F69),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Text("Service"),
                )),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 295,
              height: 55,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromARGB(255, 105, 105, 105), width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              //Here the list of all services you can find in the app !
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  //hint: Text('Select a job'),
                  value: JobType,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      JobType = newValue!;
                      JobDB = JobType;
                      print(JobDB);
                    });
                  },
                  //Here we give all the Jobs list ------------------------------->
                  items: <String>[
                    'Professor',
                    'Carpenter',
                    'Plumber',
                    'Mechanical',
                    'Smith',
                    'Chanteur'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Text("City"),
                )),
            SizedBox(
              height: 10,
            ),
            // Here the text field for cities (you can enter your city here)
            Form(
              key: this._formKey,
              child: Padding(
                padding: EdgeInsets.only(left: 33, right: 33),
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
                      //labelText: "City",
                      border: OutlineInputBorder(),
                    ),
                    controller: this._textEditingController,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Text("Select the price/hour in DH"),
                )),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 33),
                  child: SizedBox(
                    width: 120,
                    height: 50,
                    child: TextField(
                      controller: minController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Min',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 55),
                  child: SizedBox(
                    width: 120,
                    height: 50,
                    child: TextField(
                      controller: maxController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Max',
                        // errorBorder: InputBorder(borderSide:BorderSide(color: Color(Colors.red.value)) ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 10),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 250,
            ),

            //Here the button search
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                child: const Text('Search'),
                onPressed: () {
                  //TO-DO : Search for the selected choices in DataBase
                  //and move to another page or change the contenue of the search page
                  if (minController.text.isEmpty &&
                      maxController.text.isEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResultsOftsearch(
                              City: CityDB,
                              Job: JobDB,
                              min: minDB,
                              max: maxDB)),
                    );
                  } else if (minController.text.isEmpty &&
                      maxController.text.isNotEmpty) {
                    setState(() {
                      maxDB = int.parse(maxController.text);
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResultsOftsearch(
                              City: CityDB,
                              Job: JobDB,
                              min: minDB,
                              max: maxDB)),
                    );
                  } else if (minController.text.isNotEmpty &&
                      maxController.text.isEmpty) {
                    setState(() {
                      minDB = int.parse(minController.text);
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResultsOftsearch(
                              City: CityDB,
                              Job: JobDB,
                              min: minDB,
                              max: maxDB)),
                    );
                  } else {
                    setState(() {
                      minDB = int.parse(minController.text);
                      maxDB = int.parse(maxController.text);
                    });
                    functionMaxMin();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(Color(0xEB1E1F69).value),
                  //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  // textStyle: TextStyle(fontSize: 20)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void functionMaxMin() {
    if ((minDB < maxDB)) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultsOftsearch(
                City: CityDB, Job: JobDB, min: minDB, max: maxDB)),
      );
    } else {
      setState(() {
        error = "(The max must be bigger than min !!)";
      });
      maxController.clear();
    }
  }
}
