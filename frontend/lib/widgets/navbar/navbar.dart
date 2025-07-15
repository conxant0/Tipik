import 'package:flutter/material.dart';
import 'package:frontend/theme/colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.ocean,
            borderRadius: BorderRadius.circular(40), // Oval shape
            boxShadow: [
              BoxShadow(
                color: AppColors.indigo,
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(iconPath: 'assets/icons/home-icon.png', index: 0),
              _buildNavItem(iconPath: 'assets/icons/notif-icon.png', index: 1),
              _buildNavItem(
                iconPath: 'assets/icons/add-icon.png',
                index: 2,
                isStaticColor: true,
              ),
              _buildNavItem(iconPath: 'assets/icons/learn-icon.png', index: 3),
              _buildNavItem(
                iconPath: 'assets/icons/profile-icon.png',
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required int index,
    bool isStaticColor = false,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            height: currentIndex == index ? 30 : 26,
            color: isStaticColor
                ? AppColors.yellow
                : currentIndex == index
                ? AppColors.cyan
                : AppColors.lightGray,
          ),
          const SizedBox(height: 4),
          if (!isStaticColor)
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentIndex == index
                    ? AppColors.cyan
                    : Colors.transparent,
              ),
            ),
        ],
      ),
    );
  }
}
