import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:frontend/widgets/generic/custom_container.dart';
import 'package:frontend/widgets/generic/gradient_button.dart';
import '../application/image_picker_service.dart';
import '../application/image_sender.dart';

// theme
import 'package:frontend/theme/colors.dart';
import 'package:frontend/theme/text_styles.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  File? _image;
  String? _explanation;
  bool _isLoading = false;

  final _pickerService = ImagePickerService();

  void _handleBack() {
    if (_image == null) {
      Navigator.of(context).pushNamedAndRemoveUntil('/nav', (route) => false);
    } else {
      _resetState();
    }
  }

  void _resetState() {
    setState(() {
      _image = null;
      _explanation = null;
    });
  }

  void _pickFromCamera() async {
    final img = await _pickerService.pickImageFromCamera();
    if (img != null) {
      setState(() => _image = img);
      _explanation = null; // Clear old explanation
    }
  }

  void _pickFromGallery() async {
    final img = await _pickerService.pickImageFromGallery();
    if (img != null) {
      setState(() => _image = img);
      _explanation = null; // Clear old explanation
    }
  }

  void _navigateToExplanationCompiler() {
    if (_image != null) {
      Navigator.pushNamed(context, '/explanation-compiler', arguments: _image);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select an image first.')));
    }
  }

  // void _handleExplain() async {
  //   if (_image == null) return;

  //   setState(() {
  //     _isLoading = true;
  //     _explanation = null;
  //   });

  //   final explanation = await sendImageToBackend(_image!);

  //   setState(() {
  //     _explanation = explanation;
  //     _isLoading = false;
  //   });
  // }

  void _handleRun() async {
    if (_image == null) return;

    setState(() => _isLoading = true);
    final code = await extractCodeOnly(_image!);
    setState(() => _isLoading = false);

    if (code.startsWith('INVALID')) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No valid code found in image.')));
      return;
    }

    Navigator.pushNamed(context, '/ide', arguments: code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _handleBack,
          icon: _image == null
              ? Image.asset('assets/icons/back-icon-light.png')
              : Image.asset('assets/icons/back-icon-dark.png'),
        ),

        title: _image == null
            ? Text(
                'Scan Code',
                style: AppTextStyles.heading.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,

        backgroundColor: _image == null ? AppColors.ocean : AppColors.white,
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
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
          Column(
            children: <Widget>[
              CustomContainer(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      if (_image != null)
                        Column(
                          children: [
                            SizedBox(
                              height: 300,
                              width: double.infinity,
                              child: Image.file(_image!, fit: BoxFit.cover),
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),
                      if (_isLoading) const CircularProgressIndicator(),
                      if (_explanation != null && !_isLoading)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: MarkdownBody(
                            data: _explanation!,
                            selectable: true,
                            styleSheet:
                                MarkdownStyleSheet.fromTheme(
                                  Theme.of(context),
                                ).copyWith(
                                  p: const TextStyle(fontSize: 16),
                                  h3: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: _image == null
                      ? [
                          Expanded(
                            child: GradientButton(
                              text: 'TAKE A PICTURE',
                              onPressed: _pickFromCamera,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GradientButton(
                              text: 'UPLOAD FROM GALLERY',
                              onPressed: _pickFromGallery,
                            ),
                          ),
                        ]
                      : [
                          Expanded(
                            child: GradientButton(
                              text: 'EXPLAIN',
                              onPressed: _navigateToExplanationCompiler,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GradientButton(
                              text: 'RUN CODE',
                              onPressed: _handleRun,
                            ),
                          ),
                        ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
