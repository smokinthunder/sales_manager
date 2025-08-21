import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:sales_manager/ui/core/colors.dart';

// void showSnackBar(BuildContext context, String content) {
//   ScaffoldMessenger.of(context)
//     ..hideCurrentSnackBar()
//     ..showSnackBar(SnackBar(content: Text(content)));
// }

/// Displays a customizable snackbar with a message and an icon.
Future<void> showSnackBar(
  BuildContext context,
  String content, [
  bool isError = false,
]) async {
  Color headerColor = isError ? AppColors.red : AppColors.green;

  Flushbar(
    titleText: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isError
              ? Icons.error_outline_rounded
              : Icons.check_circle_outline_rounded,
          color: headerColor,
          size: 25,
        ),
        Text(
          isError ? " Error !" : " Success !",
          style: TextStyle(
            color: headerColor,
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
    message: content,
    messageText: Center(
      child: Text(
        content,
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    ),
    messageColor: Colors.black,
    backgroundColor: Colors.white,
    flushbarPosition: FlushbarPosition.TOP,
    borderRadius: BorderRadius.all(Radius.circular(20)),
    titleColor: Colors.green,
    duration: Duration(seconds: 2),
    boxShadows: [
      BoxShadow(
        spreadRadius: 10000,
        blurStyle: BlurStyle.solid,
        color: const Color.fromARGB(30, 0, 0, 0),
      ),
    ],
    margin: EdgeInsets.all(20),
    reverseAnimationCurve: Curves.decelerate,
    forwardAnimationCurve: Curves.elasticOut,
    isDismissible: true,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
  ).show(context);
}
