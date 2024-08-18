import 'package:flutter/material.dart';
import 'package:shop1/layout/login/login_screen.dart';
import 'package:shop1/network/local/cache_helper.dart';

void navigateTo(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void navigateAndFinish(BuildContext context, Widget widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
        (route) => false,
  );
}

void signOut(BuildContext context) {
  CacheHelper.clearData(key: 'token').then((value) {
    if (value) {
      navigateAndFinish(context, const Login());
    }
  });
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800}');
  for (final match in pattern.allMatches(text)) {
    print(match.group(0));
  }
}
Widget myDivider() => const Padding(
  padding: EdgeInsets.symmetric(vertical: 10.0),
  child: Divider(),
);