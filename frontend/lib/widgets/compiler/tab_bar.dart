import 'package:flutter/material.dart';
import 'package:frontend/theme/colors.dart';
import 'package:frontend/theme/text_styles.dart';

class CustomTabBar extends StatefulWidget {
  final List<String> tabs;
  final List<Widget> tabContents;
  final String? backgroundImage;

  const CustomTabBar({
    Key? key,
    required this.tabs,
    required this.tabContents,
    this.backgroundImage,
  }) : super(key: key);

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tabs.length,
      child: Stack(
        children: [
          // Optional background
          if (widget.backgroundImage != null)
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.backgroundImage!),
                  fit: BoxFit.cover,
                ),
              ),
            ),

          // Content with tab bar
          Column(
            children: [
              Container(
                color: AppColors.white,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.oceanBlue,
                  indicatorWeight: 3.0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: AppColors.ocean,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: AppTextStyles.buttonText.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: widget.tabs.map((title) => Tab(text: title)).toList(),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: widget.tabContents,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
