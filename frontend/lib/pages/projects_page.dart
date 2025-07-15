import 'package:flutter/material.dart';

// theme
import 'package:frontend/theme/colors.dart';
import 'package:frontend/theme/text_styles.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
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
                  'assets/backgrounds/scan-code-bg.png',
                ), // 🔁 Update with your actual image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Text(
              'projects page',
              style: AppTextStyles.heading.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
