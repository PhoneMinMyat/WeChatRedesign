
import 'package:flutter/material.dart';

extension NavigationUtility on Widget {


  void showSnackBarWithMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
