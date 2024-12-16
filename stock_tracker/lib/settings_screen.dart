import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeNotifier;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final User? _user = FirebaseAuth.instance.currentUser;

  SettingsScreen({required this.themeNotifier}) {
    _emailController.text = _user?.email ?? '';
    
  }

  Future<void> _updateAccount(BuildContext context) async {
    try {
      if (_emailController.text.isNotEmpty) {
        await _user?.updateEmail(_emailController.text.trim());
      }
      if (_nameController.text.isNotEmpty) {
        await _user?.updateDisplayName(_nameController.text.trim());
      }
      if (_passwordController.text.isNotEmpty) {
        await _user?.updatePassword(_passwordController.text.trim());
      }
      await _user?.reload(); // Reload user data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account information updated successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Dark Mode Toggle
          ListTile(
            title: Text('Dark Mode'),
            trailing: Switch(
              value: themeNotifier.value == ThemeMode.dark,
              onChanged: (value) {
                themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ),
          Divider(),
          // Account Information Update Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Edit Account Information', style: TextStyle(fontSize: 18)),
          ),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'New Password'),
            obscureText: true,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _updateAccount(context),
            child: Text('Save Changes'),
          ),
          Divider(),
          // Logout Button
          ListTile(
            title: Text('Log Out'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Index for the Settings screen
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Stocks'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'News'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/stock_feed'); // Navigate to Stocks
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/news_feed'); // Navigate to News
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/settings'); // Navigate to Settings
              break;
          }
        },
      ),
    );
  }
}
