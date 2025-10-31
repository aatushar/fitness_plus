import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Color Constants
  static const Color _backgroundColor = Color(0xFF1A1A2E);
  static const Color _primaryColor = Color(0xFFE94560);
  static const Color _secondaryColor = Color(0xFF16213E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _secondaryColor,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Backup & Restore Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _secondaryColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Backup & Restore',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Synchronize your data',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.sync,
                        color: _primaryColor,
                        size: 30,
                      ),
                      onPressed: () {
                        // TODO: Implement sync functionality
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Settings Section
              const Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),

              // Settings Items
              _buildSettingsItem(
                icon: Icons.person,
                iconColor: const Color(0xFF4A5AFF),
                title: 'My Profile',
                onTap: () {
                  // TODO: Navigate to profile page
                },
              ),
              _buildSettingsItem(
                icon: Icons.settings,
                iconColor: const Color(0xFFF4A460),
                title: 'General Settings',
                onTap: () {
                  // TODO: Navigate to general settings
                },
              ),
              _buildSettingsItem(
                icon: Icons.language,
                iconColor: const Color(0xFF00CED1),
                title: 'Language',
                trailing: 'System default',
                onTap: () {
                  // TODO: Open language selection
                },
              ),
              _buildSettingsItem(
                icon: Icons.remove_circle_outline,
                iconColor: const Color(0xFF8A2BE2),
                title: 'Remove Ads',
                onTap: () {
                  // TODO: Implement ad removal
                },
              ),
              _buildSettingsItem(
                icon: Icons.star_border,
                iconColor: const Color(0xFFFF6347),
                title: 'Rate Us',
                onTap: () {
                  // TODO: Open app store rating
                },
              ),
              _buildSettingsItem(
                icon: Icons.feedback_outlined,
                iconColor: const Color(0xFF20B2AA),
                title: 'Feedback',
                onTap: () {
                  // TODO: Open feedback mechanism
                },
              ),

              const SizedBox(height: 30),

              // Version Information
              Center(
                child: Text(
                  'Version 1.5.1',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _secondaryColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Training',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Custom',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Me',
            activeIcon: Icon(Icons.person, color: _primaryColor),
          ),
        ],
        currentIndex: 4, // Me page is selected
        onTap: (index) {
          // TODO: Implement navigation logic
        },
      ),
    );
  }

  // Helper method to build settings items
  Widget _buildSettingsItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: _secondaryColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailing != null)
              Text(
                trailing,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            const SizedBox(width: 10),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}