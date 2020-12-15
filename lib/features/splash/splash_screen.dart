import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SplashScreen());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Icon(
            Icons.all_inclusive,
            size: 150,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
      );
}
