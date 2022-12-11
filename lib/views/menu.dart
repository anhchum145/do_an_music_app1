import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

String a = "";
Widget menu(BuildContext context) {
  return Container(
    padding: EdgeInsets.only(top: 80),
    height: 150,
    child: GroupButton(
        isRadio: true,
        buttons: const ["Home", "Album", "Download"],
        options: GroupButtonOptions(
          spacing: 50,
          selectedShadow: const [],
          selectedColor: Colors.black,
          unselectedShadow: const [],
          unselectedColor: Colors.black,
          unselectedTextStyle: TextStyle(
            color: Colors.grey[600],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        onSelected: (val, i, selected) {
          if (i == 1) {
            Navigator.pushNamed(context, '/a').then((value) => {
                  a = value.toString(),
                  Navigator.pushNamed(context, '/b'),
                });
          }
          if (i == 2) {
            // Navigator.pushNamed(context, "/b");
          }
          if (i == 0) {
            Navigator.pushNamed(context, "/b");
          }
        }),
  );
}

Future<String> _navigateAndDisplaySelection(
  BuildContext context,
) async {
  // Navigator.push returns a Future that completes after calling
  // Navigator.pop on the Selection Screen.
  final result = await Navigator.pushNamed(context, '/a');

  // When a BuildContext is used from a StatefulWidget, the mounted property
  // must be checked after an asynchronous gap.

  // After the Selection Screen returns a result, hide any previous snackbars
  return result.toString();
}
