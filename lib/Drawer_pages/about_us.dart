import 'package:flutter/material.dart';
import 'package:ironman/constants/image_strings.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About us',),
        // backgroundColor: tPrimaryColor,
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : Colors.white,
      body: SingleChildScrollView(
        
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                aboutus, // Replace with your image asset path
                height: 150.0, // Adjust the height as needed
              ),
              SizedBox(height: 16.0),
              Text(
                'Diabetes Prediction App',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Welcome to the Diabetes Prediction App! This app utilizes machine learning and deep learning models to predict the likelihood of diabetes based on input data.',
                style: TextStyle(fontSize: 16.0),
              ),
              
              SizedBox(height: 16.0),
              Text(
                'Key Features:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              FeatureItem(
                title: 'Machine Learning Model',
                description:
                    'Our app uses a machine learning model to analyze input data and provide predictions on the risk of diabetes.',
              ),
              FeatureItem(
                title: 'Deep Learning Model',
                description:
                    'In addition to traditional machine learning, we employ a deep learning model to enhance the accuracy of diabetes predictions.',
              ),
              FeatureItem(
                title: 'User-Friendly Interface',
                description:
                    'The app features an intuitive and user-friendly interface, making it easy for users to input data and receive predictions.',
              ),
              FeatureItem(
                title: 'Quick and Accurate Results',
                description:
                    'Get quick and accurate predictions, allowing users to take proactive measures for their health.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String title;
  final String description;

  const FeatureItem({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.0),
        Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          description,
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
