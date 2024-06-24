import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'themeProvider.dart';
import 'main.dart'; // Import main.dart to access LoginPage

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return Text(
              'Profile Settings',
              style: TextStyle(
                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
              ),
            );
          },
        ),
        backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode
            ? Colors.black
            : Colors.grey,
        iconTheme: IconThemeData(
          color: Provider.of<ThemeProvider>(context).isDarkMode
              ? Colors.white
              : Colors.black,
        ),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Container(
            color: themeProvider.isDarkMode ? Colors.black : Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/profile.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  'Neil Andrew Llagas',
                  style: TextStyle(
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Icon(
                    Icons.email,
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                  title: Text(
                    'llagasneilandrew@gmail.com',
                    style: TextStyle(
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.phone,
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                  title: Text(
                    '+000000000',
                    style: TextStyle(
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.dark_mode,
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                  title: Text(
                    'Dark Mode',
                    style: TextStyle(
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        themeProvider.isDarkMode ? Colors.red : Colors.red[400],
                  ),
                  onPressed: () {
                    // Handle Logout
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
