import 'package:flutter/material.dart';
import 'package:ironman/constants/color.dart';
import 'package:ironman/constants/image_strings.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              contactus, // Replace with your image asset path
              height: 180.0, // Adjust the height as needed
            ),
            SizedBox(height: 16.0),
            Text(
              'Get in Touch',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Feel free to contact us for any questions or feedback. We are here to help!',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email, color: tPrimaryColor, size: 24.0),
                SizedBox(width: 8.0),
                Text(
                  'kmitengineer1@gmail.com',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone, color: tPrimaryColor, size: 24.0),
                SizedBox(width: 8.0),
                Text(
                  '+91 9392768819',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

