import 'package:flutter/material.dart';

ButtonStyle kLoadingButtonStyle = ElevatedButton.styleFrom(
  minimumSize: const Size.fromHeight(50),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18.0),
    side: const BorderSide(
      color: Colors.teal,
      // width: 2.0,
    ),
  ),
);

ButtonStyle kSubTextStyle = TextButton.styleFrom(
  primary: Colors.black,
);

BorderRadius kBorderRounded = BorderRadius.circular(20.0);

EdgeInsets kPagePadding = const EdgeInsets.all(20.0);

double kFormMaxWidth = 500;
