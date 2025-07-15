import 'package:flutter/material.dart';

// theme
import 'package:frontend/theme/colors.dart';
import 'package:frontend/theme/text_styles.dart';
import 'package:frontend/widgets/compiler/compiler_tab_content.dart';

import 'package:frontend/widgets/compiler/tab_bar.dart';
import 'package:frontend/widgets/generic/custom_container.dart';

class ExplanationCompilerPage extends StatefulWidget {
  const ExplanationCompilerPage({Key? key}) : super(key: key);

  @override
  State<ExplanationCompilerPage> createState() =>
      _ExplanationCompilerPageState();
}

class _ExplanationCompilerPageState extends State<ExplanationCompilerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('assets/icons/back-icon-dark.png'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
      ),
      body: CustomTabBar(
        tabs: ['Explanation', 'Compiler'],
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Press here to talk and ask some questions.',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: AppColors.cyan, width: 3),
                      ),
                      fillColor: AppColors.white,
                      filled: true,
                    ),
                  ),
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
