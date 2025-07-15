import 'package:flutter/material.dart';
// theme
import 'package:frontend/theme/colors.dart';
import 'package:frontend/theme/text_styles.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                  'assets/backgrounds/profile-bg.png',
                ), // 🔁 Update with your actual image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Profile content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile picture
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.cyan, width: 2),
                  ),
                  child: Icon(Icons.person, size: 60, color: Colors.grey[600]),
                ),

                SizedBox(height: 16),

                // Username
                Text(
                  'Joanalyn\nCadampog',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 32),

                // Buttons
                Column(
                  children: [
                    _buildProfileButton(
                      icon: Icons.edit,
                      text: 'Edit Profile',
                      onPressed: () {
                        // Handle edit profile
                      },
                    ),

                    SizedBox(height: 12),

                    _buildProfileButton(
                      icon: Icons.lock,
                      text: 'Change Password',
                      onPressed: () {
                        // Handle change password
                      },
                    ),

                    SizedBox(height: 12),

                    _buildProfileButton(
                      icon: Icons.logout,
                      text: 'Log Out',
                      onPressed: () {
                        // Handle log out
                      },
                    ),

                    SizedBox(height: 12),

                    _buildProfileButton(
                      icon: Icons.delete,
                      text: 'Delete Account',
                      onPressed: () {
                        // Handle delete account
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 200,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue.withOpacity(0.8),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, size: 20),
            SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
