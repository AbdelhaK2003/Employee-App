import 'package:flutter/material.dart';

Widget WorkEdit(String item, String value, onTap) {
  return ListTile(
    minLeadingWidth: 30,
    title: Row(
      children: [
        Expanded(child: Text(value)),
        Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.edit,
              color: Colors.grey[600],
            )),
      ],
    ),
    onTap: onTap,
  );
}

Widget al(String item) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        item + ' : ',
        style: TextStyle(color: Colors.grey),
      ),
    ),
  );
}

Widget day(bool dy, paddin, String da) {
  return Padding(
    padding: paddin,
    child: ChoiceChip(
      backgroundColor: Color(Color.fromARGB(235, 68, 68, 68).value),
      labelStyle: TextStyle(color: Color.fromARGB(255, 247, 247, 247)),
      selectedColor: Color(Color.fromARGB(235, 62, 63, 145).value),
      label: Text(da),
      selected: dy,
    ),
  );
}

Widget day2(String sday, bool day, padding, onSelected) {
  return Padding(
    padding: padding,
    child: ChoiceChip(
      backgroundColor: Color(Color.fromARGB(235, 68, 68, 68).value),
      labelStyle: TextStyle(color: Color.fromARGB(255, 247, 247, 247)),
      selectedColor: Color(Color.fromARGB(235, 62, 63, 145).value),
      label: Text(sday),
      selected: day,
      onSelected: onSelected,
    ),
  );
}
