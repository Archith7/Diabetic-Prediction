import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ironman/Drawer_pages/about_us.dart';
import 'package:ironman/Drawer_pages/contact_us.dart';
import 'package:ironman/Drawer_pages/history.dart';
import 'package:ironman/Drawer_pages/profile.dart';
import 'package:ironman/common_widgets/App_theme.dart';
import 'package:ironman/constants/color.dart';
import 'package:ironman/success_page.dart';
import 'package:ironman/welcome_screen.dart';

class AppDrawer extends StatelessWidget {
  final String userName;
  final int userAge;
  final String userEmail;
  final int userPhone;

  const AppDrawer({
    Key? key,
    required this.userName,
    required this.userAge,
    required this.userEmail,
    required this.userPhone,
  }) : super(key: key);
  
  Future<void> _logout(BuildContext context) async {
    // Show confirmation dialog
    bool confirmLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout' , style: TextStyle(
            fontWeight: FontWeight.w500,
              ),
            ),
          content: Text('Do you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User pressed No
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User pressed Yes
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    // Check user's confirmation
    if (confirmLogout == true) {
      try {
        await FirebaseAuth.instance.signOut();
        Get.to(() => const WelcomeScreen());
      } catch (e) {
        print('Error logging out: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
   final ThemeController themeController = Get.put(ThemeController());
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  
                  accountEmail: Text(userEmail,style: TextStyle(
                    color: Colors.black, fontSize: 17),),
                  accountName: Text(userName,style: TextStyle(
                    color: Colors.black ,fontWeight: FontWeight.w700 , fontSize: 20)),
                  decoration: BoxDecoration(
                    color: tPrimaryColor, // Change the color here
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text("Home"),
                  onTap: () => Get.to(() => SuccessPage()),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Profile"),
                  onTap: () => Get.to(() => UserDetailsPage(
                    userName: userName, 
                    userEmail: userEmail, 
                    userAge: userAge, 
                    userPhone: userPhone,)),
                ),
                ListTile(
                  leading: Icon(Icons.history),
                  title: Text("History"),
                  onTap: () => Get.to(() => HistoryPage()),
                ),
                ListTile(
                  leading: Icon(Icons.contact_page),
                  title: Text("Contact us"),
                  onTap: () => Get.to(() => ContactUsPage()),
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text("About us"),
                  onTap: () => Get.to(() => AboutUs()),
                ),
                 ListTile(
            leading: Icon(Icons.brightness_6), // Theme switch icon
            title: Text("Theme"),
            trailing:Switch(
                value: themeController.themeMode.value == ThemeMode.dark,
                onChanged: (_) => themeController.toggleTheme(),
              ),
          ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {
          // Show confirmation dialog before logout
          // Perform logout action here
          _logout(context);            },
          ),
        ],
      ),
    );
  }
}