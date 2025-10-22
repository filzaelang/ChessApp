import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, String text) {
  // cancel button
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the button
  Widget okButton = TextButton(child: Text("OK"), onPressed: () {});

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("My title"),
    content: Text(text),
    actions: [cancelButton, okButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
