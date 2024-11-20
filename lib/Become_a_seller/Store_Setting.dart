import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final Function(bool) toggleTheme;

  SettingsPage({required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildProfileSection(),
          _buildSettingsList(context),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 6,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/avatar.jpg'),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'johndoe@example.com',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return Column(
      children: [
        _buildSettingItem(
          context,
          icon: Icons.notifications,
          title: "Notifications",
          widget: Switch(
            value: true,
            onChanged: (bool value) {},
          ),
        ),
        _buildSettingItem(
          context,
          icon: Icons.nightlight_round,
          title: "Dark Mode",
          widget: Switch(
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (bool value) {
              toggleTheme(value);
            },
          ),
        ),
        _buildSettingItem(
          context,
          icon: Icons.account_circle,
          title: "Account Settings",
          widget: Icon(Icons.chevron_right),
        ),
        _buildSettingItem(
          context,
          icon: Icons.lock,
          title: "Privacy Policy",
          widget: Icon(Icons.chevron_right),
        ),
        _buildSettingItem(
          context,
          icon: Icons.info,
          title: "About App",
          widget: Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  Widget _buildSettingItem(BuildContext context, {
    required IconData icon,
    required String title,
    required Widget widget,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(bottom: 12),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title, style: TextStyle(fontSize: 16)),
        trailing: widget,
      ),
    );
  }
}
