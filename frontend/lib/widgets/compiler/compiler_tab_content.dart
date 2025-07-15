import 'package:flutter/material.dart';

// theme
import 'package:frontend/theme/colors.dart';
import 'package:frontend/theme/text_styles.dart';
import 'package:frontend/widgets/generic/custom_container.dart';
import 'package:frontend/widgets/generic/gradient_button.dart';

class CompilerTabContent extends StatefulWidget {
  const CompilerTabContent({Key? key}) : super(key: key);

  @override
  State<CompilerTabContent> createState() => _CompilerTabContentState();
}

class _CompilerTabContentState extends State<CompilerTabContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool get _isSourceTab =>
      _tabController.index == 0 && !_tabController.indexIsChanging;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Update state when tab changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Inner TabBar
        Container(
          margin: EdgeInsets.only(top: 30, left: 50, right: 50),
          color: AppColors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.white,
            labelStyle: AppTextStyles.buttonText.copyWith(
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelColor: AppColors.ocean,
            indicator: BoxDecoration(
              gradient: AppColors.buttonGradient, // your custom gradient
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(text: 'Source Code'),
              Tab(text: 'Output'),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Inner TabBarView
        Expanded(
          child: CustomContainer(
            child: TabBarView(
              controller: _tabController,
              children: [
                Center(child: Text('Source Code')),
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 200),
                      Image.asset(
                        'assets/icons/empty-output-icon.png',
                        height: 80,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Output of your code appears here',
                        style: AppTextStyles.label1.copyWith(
                          color: AppColors.ocean,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // buttons for source code tab
        if (_isSourceTab)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: GradientButton(
                    text: 'TAKE A PICTURE',
                    onPressed: () {
                      // Handle button press
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GradientButton(
                    text: 'RUN CODE',
                    onPressed: () {
                      // Handle button press
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
