import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ironman/common_widgets/Drawer/drawer.dart';

class DiabetesPredictionPage extends StatefulWidget {
  final String userName;
  final int userAge;
  final String userEmail;
  final int userPhone;
  
  const DiabetesPredictionPage({
    Key? key,
    required this.userName,
    required this.userAge,
    required this.userEmail,
    required this.userPhone,
  }) : super(key: key);

  @override
  _DiabetesPredictionPageState createState() => _DiabetesPredictionPageState();
}

class _DiabetesPredictionPageState extends State<DiabetesPredictionPage> {
  TextEditingController pregnanciesController = TextEditingController();
  TextEditingController glucoseController = TextEditingController();
  TextEditingController bloodPressureController = TextEditingController();
  TextEditingController skinThicknessController = TextEditingController();
  TextEditingController insulinController = TextEditingController();
  TextEditingController bmiController = TextEditingController();
  TextEditingController diabetesPedigreeFunctionController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  List<String> selectedModels = [];
  Map<String, String> predictions = {};
  ScrollController _scrollController = ScrollController();
  bool isGroundTruthSwitched = false; // Track the state of the ground truth switch
  int selectedSample = 1; // Track the selected sample index
  List<String> models = ['Decision Tree', 'Random Forest', 'SVM', 'XGBoost'];

  // Sample data for ground truth output
  Map<int, Map<String, dynamic>> sampleData = {
    1: {
      'Pregnancies': 6,
      'Glucose': 148,
      'BloodPressure': 72,
      'SkinThickness': 35,
      'Insulin': 0,
      'BMI': 33.6,
      'DiabetesPedigreeFunction': 0.627,
      'Age': 50,
      'Outcome': 1,
    },
    2: {
      'Pregnancies': 1,
      'Glucose': 85,
      'BloodPressure': 66,
      'SkinThickness': 29,
      'Insulin': 0,
      'BMI': 26.6,
      'DiabetesPedigreeFunction': 0.351,
      'Age': 31,
      'Outcome': 0,
    },
    3: {
      'Pregnancies': 8,
      'Glucose': 183,
      'BloodPressure': 64,
      'SkinThickness': 0,
      'Insulin': 0,
      'BMI': 23.3,
      'DiabetesPedigreeFunction': 0.672,
      'Age': 32,
      'Outcome': 1,
    },
    4: {
      'Pregnancies': 1,
      'Glucose': 89,
      'BloodPressure': 66,
      'SkinThickness': 23,
      'Insulin': 94,
      'BMI': 28.1,
      'DiabetesPedigreeFunction': 0.167,
      'Age': 21,
      'Outcome': 0,
    },
    5: {
      'Pregnancies': 0,
      'Glucose': 137,
      'BloodPressure': 40,
      'SkinThickness': 35,
      'Insulin': 168,
      'BMI': 43.1,
      'DiabetesPedigreeFunction': 2.288,
      'Age': 33,
      'Outcome': 1,
    },
    6: {
      'Pregnancies': 5,
      'Glucose': 116,
      'BloodPressure': 74,
      'SkinThickness': 0,
      'Insulin': 0,
      'BMI': 25.6,
      'DiabetesPedigreeFunction': 0.201,
      'Age': 30,
      'Outcome': 0,
    },
    7: {
      'Pregnancies': 3,
      'Glucose': 78,
      'BloodPressure': 50,
      'SkinThickness': 32,
      'Insulin': 88,
      'BMI': 31,
      'DiabetesPedigreeFunction': 0.248,
      'Age': 26,
      'Outcome': 1,
    },
  };
  
  @override
  void initState() {
    super.initState();
    updateFieldsWithSampleData(selectedSample);
  }

  void updateFieldsWithSampleData(int sampleIndex) {
    Map<String, dynamic> sample = sampleData[sampleIndex]!;
    pregnanciesController.text = sample['Pregnancies'].toString();
    glucoseController.text = sample['Glucose'].toString();
    bloodPressureController.text = sample['BloodPressure'].toString();
    skinThicknessController.text = sample['SkinThickness'].toString();
    insulinController.text = sample['Insulin'].toString();
    bmiController.text = sample['BMI'].toString();
    diabetesPedigreeFunctionController.text = sample['DiabetesPedigreeFunction'].toString();
    ageController.text = sample['Age'].toString();
  }

  Future<void> sendPredictionRequest() async {
    if (selectedModels.isEmpty) {
      // Show a snackbar or some validation to ensure at least one model is selected
      return;
    }
    // const url = 'https://flask-mobile-diacare.el.r.appspot.com/predict_diabetes';
    const url = 'http://192.168.29.231:5000/predict_diabetes';
    // const url = 'http://ec2-35-154-148-8.ap-south-1.compute.amazonaws.com:5000/predict_diabetes';
    // const url = 'http://mlmodel124.appspot.com/predict_diabetes' ;
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'Pregnancies': double.parse(pregnanciesController.text),
        'Glucose': double.parse(glucoseController.text),
        'BloodPressure': double.parse(bloodPressureController.text),
        'SkinThickness': double.parse(skinThicknessController.text),
        'Insulin': double.parse(insulinController.text),
        'BMI': double.parse(bmiController.text),
        'DiabetesPedigreeFunction': double.parse(diabetesPedigreeFunctionController.text),
        'Age': double.parse(ageController.text),
        'SelectedModels': selectedModels,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        predictions = Map<String, String>.from(data['predictions']);
      });

      // Store user input and predictions in Firestore
      await storePredictionInFirestore();

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      print('Failed to send data. Error: ${response.reasonPhrase}');
    }
  }

  // Show prediction dialogue box

  void showPredictionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('Prediction Results'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Prediction Results:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Display prediction results in the dialog
              ...predictions.entries.map((entry) {
                final modelName = entry.key;
                final prediction = entry.value;
                final resultText = '$modelName : $prediction';

                return Text(
                  resultText,
                  style: const TextStyle(fontSize: 16),
                );
              }).toList(),
              // Display ground truth only when the switch is on
              if (isGroundTruthSwitched)
                Text(
                  'Ground Truth: ${getGroundTruth(selectedSample)}',
                  style: const TextStyle(fontSize: 16),
                ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> storePredictionInFirestore() async {
  try {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Reference to the 'users' collection
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

      // Reference to the user's document inside 'users'
      DocumentReference userDocument = usersCollection.doc(user.uid);

      // Reference to the 'predictions' collection inside the user's document
      CollectionReference predictionsCollection = userDocument.collection('predictions');

      // Define the order of fields
      List<String> fieldOrder = [
        'Pregnancies',
        'Glucose',
        'BloodPressure',
        'SkinThickness',
        'Insulin',
        'BMI',
        'DiabetesPedigreeFunction',
        'Age',
        'SelectedModels',
        'Predictions',
        'GroundTruth',
        'Timestamp',
      ];

      // Create a Map with the specified order
      Map<String, dynamic> data = {
        for (String fieldName in fieldOrder)
          fieldName: _getFieldValue(fieldName),
        'Timestamp': FieldValue.serverTimestamp(),
      };

      // Store user input and predictions
      await predictionsCollection.add(data);

      print('User input and predictions stored in Firestore');
    } else {
      print('User not logged in.');
    }
  } catch (error) {
    print('Error storing data in Firestore: $error');
  }
}
dynamic _getFieldValue(String fieldName) {
  switch (fieldName) {
    case 'Pregnancies':
      return double.parse(pregnanciesController.text);
    case 'Glucose':
      return double.parse(glucoseController.text);
    case 'BloodPressure':
      return double.parse(bloodPressureController.text);
    case 'SkinThickness':
      return double.parse(skinThicknessController.text);
    case 'Insulin':
      return double.parse(insulinController.text);
    case 'BMI':
      return double.parse(bmiController.text);
    case 'DiabetesPedigreeFunction':
      return double.parse(diabetesPedigreeFunctionController.text);
    case 'Age':
      return double.parse(ageController.text);
    case 'SelectedModels':
      return selectedModels;
    case 'Predictions':
      return predictions;
    case 'GroundTruth':
      return isGroundTruthSwitched ? getGroundTruth(selectedSample) : '-';
    default:
      return null;
  }
}
  String getGroundTruth(int sampleIndex) {
    // Get ground truth based on the selected sample index
    int outcome = sampleData[sampleIndex]!['Outcome'];
    return outcome == 1 ? 'High risk' : 'Low risk';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text('Diabetes Prediction'),
      ),
  drawer: AppDrawer(
  userName: widget.userName,
  userAge: widget.userAge,
  userEmail: widget.userEmail,
  userPhone: widget.userPhone,
),


      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sample Dropdown and Ground Truth Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sample Dropdown
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<int>(
                    hint: const Text('Samples'),
                    value: selectedSample,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedSample = newValue!;
                        updateFieldsWithSampleData(selectedSample);
                      });
                    },
                    items: List.generate(8, (index) {
                      return DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text('Sample ${index + 1}'),
                      );
                    }),
                  ),
                ),
                // Ground Truth Switch
                Row(
                  children: [
                    const Text('Ground Truth'),
                    Switch(
                      value: isGroundTruthSwitched,
                      onChanged: (value) {
                        setState(() {
                          isGroundTruthSwitched = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Other widgets go here
            buildParameterTextField('Pregnancies', pregnanciesController),
            const SizedBox(height: 20),
            buildParameterTextField('Glucose', glucoseController),
            const SizedBox(height: 20),
            buildParameterTextField('Blood Pressure', bloodPressureController),
            const SizedBox(height: 20),
            buildParameterTextField('Skin Thickness', skinThicknessController),
            const SizedBox(height: 20),
            buildParameterTextField('Insulin', insulinController),
            const SizedBox(height: 20),
            buildParameterTextField('BMI', bmiController),
            const SizedBox(height: 20),
            buildParameterTextField('Diabetes Pedigree Function', diabetesPedigreeFunctionController),
            const SizedBox(height: 20),
            buildParameterTextField('Age', ageController),
            const SizedBox(height: 20),
            buildCheckboxList(models),
            const SizedBox(height: 20),
            ElevatedButton(
              // onPressed: sendPredictionRequest,
                 onPressed : () async{
                  await sendPredictionRequest();
                 showPredictionDialog(); 
                 },// Show dialog after receiving predictions
              child: const Text('Predict Diabetes'),
            ),
            const SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }

  Widget buildParameterTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget buildCheckboxList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items.map((String value) {
        return CheckboxListTile(
          title: Text(value),
          value: selectedModels.contains(value),
          onChanged: (bool? newValue) {
            setState(() {
              if (newValue != null) {
                if (newValue) {
                  selectedModels.add(value);
                } else {
                  selectedModels.remove(value);
                }
              }
            });
          },
        );
      }).toList(),
    );
  }
}
