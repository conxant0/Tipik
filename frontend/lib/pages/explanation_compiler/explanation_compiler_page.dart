import 'package:flutter/material.dart';
import 'dart:io';
import '../../features/scan_code/application/image_sender.dart';
import '../../features/scan_code/application/follow_up.dart';

// theme
import 'package:frontend/theme/colors.dart';
import 'package:frontend/theme/text_styles.dart';
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgrounds/result-bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: CustomContainer(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: MarkdownBody(
                            data: _explanation ?? 'No explanation found.',
                            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                              p: AppTextStyles.buttonText.copyWith(color: AppColors.ocean),
                            ),
                          ),
                        ),
                ),
              ),
              if (!_isLoading && _explanation != null) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      openFollowUpChat(context, _explanation!);
                    },
                    child: const Text('Ask a follow-up question'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}