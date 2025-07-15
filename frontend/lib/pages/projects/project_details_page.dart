import 'package:flutter/material.dart';
import 'package:frontend/theme/colors.dart';
import 'package:frontend/theme/text_styles.dart';
import 'package:frontend/widgets/compiler/compiler_tab_content.dart';
import 'package:frontend/widgets/compiler/tab_bar.dart';
import 'package:frontend/widgets/generic/custom_container.dart';

class ProjectDetailPage extends StatelessWidget {
  final String title;
  final String imagePath;

  const ProjectDetailPage({
    Key? key,
    required this.title,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: AppTextStyles.label1.copyWith(
            fontSize: 30,
            color: AppColors.ocean,
          ),
        ),
        backgroundColor: AppColors.white,
      ),
      body: CustomTabBar(
        tabs: ['Index', 'Compiler'],
        tabContents: [
          Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: CustomContainer(
                        child: Center(
                          child: Text(
                            'Explanation Content',
                            style: AppTextStyles.buttonText.copyWith(
                              color: AppColors.ocean,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Center(child: CompilerTabContent()),
        ],
        backgroundImage: 'assets/backgrounds/result-bg.png',
      ),
    );
  }
}
