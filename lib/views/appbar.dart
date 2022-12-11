import 'package:flutter/material.dart';

PreferredSizeWidget appBar(String title) {
  return AppBar(
    key: const Key("appBar"),
    automaticallyImplyLeading: false,
    backgroundColor: Colors.black,
    elevation: 100,
    actions: [
      IconButton(onPressed: null, icon: Icon(Icons.account_box)),
    ],
    title: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w300,
      ),
    ),
  );
}
