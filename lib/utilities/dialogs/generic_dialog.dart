import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();  // list of titles for every button inside map of string

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
}) {
  // T means any generic data type

  final options = optionsBuilder(); 
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTitle) { // every key inside our options map is an option title
          final T value = options[optionTitle];   // each title is mapped to a text button(value) 
                                                  // such that it has the route to where to go on press event
          return TextButton(
            onPressed: () {
              if (value != null) {
                Navigator.of(context).pop(value); // goes to route
              }
              else{
                Navigator.of(context).pop();  // route can be null as in the case of key 'okay'
              }
            },
            child: Text(optionTitle),
          );
        }).toList(),
      );
    },
  );
}
