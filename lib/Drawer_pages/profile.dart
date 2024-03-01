import 'package:flutter/material.dart';
import 'package:ironman/constants/image_strings.dart';

class UserDetailsPage extends StatelessWidget {
  final String userName;
  final int userAge;
  final String userEmail;
  final int userPhone;

  UserDetailsPage({
    required this.userName,
    required this.userAge,
    required this.userEmail,
    required this.userPhone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 60.0,
                backgroundImage: AssetImage(dp), // Add your image path
              ),
              SizedBox(height: 16.0),
              // User Details Box
              Container(
                padding: EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Name :  ',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        Text('$userName',style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Text(
                          'Age    :  ',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                            Text('$userAge',style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Text(
                          'Email : ',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        Text('$userEmail',style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Text(
                          'Phone:  ',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                            Text('$userPhone',style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
