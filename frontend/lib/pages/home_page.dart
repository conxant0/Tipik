import 'package:flutter/material.dart';

// theme
import 'package:frontend/theme/colors.dart';
import 'package:frontend/theme/text_styles.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/backgrounds/home-bg.png',
                ), // 🔁 Update with your actual image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Text(
              'Welcome to CodeSnap!',
              style: AppTextStyles.heading.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
