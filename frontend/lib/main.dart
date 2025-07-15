import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/features/scan_code/presentation/scan_page.dart';
import 'package:frontend/pages/explanation_compiler/explanation_compiler_page.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/pages/notif_page.dart';
import 'package:frontend/pages/onboarding/onboarding-screen.dart';
import 'package:frontend/pages/profile_page.dart';
import 'package:frontend/pages/projects_page.dart';
import 'package:frontend/widgets/navbar/nav_controller.dart';
import 'pages/ide_page.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeSnap',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OnboardingPage(),
      // debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => const MainPage(),
        '/nav': (context) => const NavController(),
        '/scan': (context) => const ScanPage(),
        '/ide': (context) => const IDEPage(),
        '/notif': (context) => const NotifPage(),
        '/projects': (context) => const ProjectsPage(),
        '/profile': (context) => const ProfilePage(),
        '/explanation-compiler': (context) => const ExplanationCompilerPage(),
      },
    );
  }
}
