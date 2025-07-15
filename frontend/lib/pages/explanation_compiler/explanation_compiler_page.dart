import 'package:flutter/material.dart';
import 'dart:io';
import '../../features/scan_code/application/image_sender.dart';

// theme
import 'package:frontend/theme/colors.dart';
import 'package:frontend/theme/text_styles.dart';
import 'package:frontend/widgets/compiler/compiler_tab_content.dart';

import 'package:frontend/widgets/compiler/tab_bar.dart';
import 'package:frontend/widgets/generic/custom_container.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

class ExplanationCompilerPage extends StatefulWidget {
  final File image;
  const ExplanationCompilerPage({Key? key, required this.image}) : super(key: key);

  @override
  State<ExplanationCompilerPage> createState() => _ExplanationCompilerPageState();
}

class _ExplanationCompilerPageState extends State<ExplanationCompilerPage> {
  String? _explanation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchExplanation();
  }

  void _fetchExplanation() async {
    final explanation = await sendImageToBackend(widget.image);
    setState(() {
      _explanation = explanation;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomTabBar(
        tabs: ['Explanation', 'Compiler'],
        tabContents: [
          Column(
            children: [
              Expanded(
                child: CustomContainer(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : MarkdownBody(
                          data: _explanation ?? 'No explanation found.',
                          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                            p: AppTextStyles.buttonText.copyWith(color: AppColors.ocean),
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
