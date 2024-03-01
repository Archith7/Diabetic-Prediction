import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _predictionsCollection =
      FirebaseFirestore.instance.collection('users');

  late User _user;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _predictionsStream;
  int? expandedCardIndex; // Index of the currently expanded card, if any

  @override
  void initState() {
    super.initState();

    _user = _auth.currentUser!;
    _predictionsStream = _predictionsCollection
        .doc(_user.uid)
        .collection('predictions')
        .orderBy('Timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prediction History'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _predictionsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No predictions available.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var predictionData = snapshot.data!.docs[index].data();

              return index == expandedCardIndex
                  ? ExpandedPredictionCard(
                      predictionData: predictionData,
                      onTap: () {
                        setState(() {
                          expandedCardIndex = null; // Close the expanded card
                        });
                      },
                    )
                  : SmallPredictionCard(
                      predictionData: predictionData,
                      onTap: () {
                        setState(() {
                          expandedCardIndex = index; // Expand the tapped card
                        });
                      },
                    );
            },
          );
        },
      ),
    );
  }
}

class SmallPredictionCard extends StatelessWidget {
  final Map<String, dynamic> predictionData;
  final Function onTap;

  SmallPredictionCard({required this.predictionData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    String formattedDate = _formatTimestamp(predictionData['Timestamp']);
    String predictedOutput = _getPredictedOutput(predictionData);

    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          contentPadding: EdgeInsets.all(8),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date: $formattedDate',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Prediction: $predictedOutput',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    return formattedDate;
  }

  String _getPredictedOutput(Map<String, dynamic> predictionData) {
    // Implement your logic to extract and format the predicted output
    return predictionData['Predictions'] == 'Diabetic' ? 'Diabetic Risk' : 'No Risk';
  }
}

class ExpandedPredictionCard extends StatelessWidget {
  final Map<String, dynamic> predictionData;
  final Function onTap;

  ExpandedPredictionCard({required this.predictionData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    String formattedTimestamp = _formatTimestamp(predictionData['Timestamp']);
    List<String> selectedModels = List<String>.from(predictionData['SelectedModels']);
    Map<String, dynamic> predictions = Map<String, dynamic>.from(predictionData['Predictions']);

    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Prediction Time: $formattedTimestamp',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildDetailRow('Pregnancies', predictionData['Pregnancies']),
              _buildDetailRow('Glucose', predictionData['Glucose']),
              _buildDetailRow('BloodPressure', predictionData['BloodPressure']),
              _buildDetailRow('SkinThickness', predictionData['SkinThickness']),
              _buildDetailRow('Insulin', predictionData['Insulin']),
              _buildDetailRow('BMI', predictionData['BMI']),
              _buildDetailRow(
                  'DiabetesPedigreeFunction', predictionData['DiabetesPedigreeFunction']),
              _buildDetailRow('Age', predictionData['Age']),
              _buildDetailRow('SelectedModels', predictionData['SelectedModels']),
              // Display predictions for each selected model
              for (String model in selectedModels)
                if (predictions.containsKey(model))
                  _buildDetailRow('$model Prediction:', predictions[model] ?? 'N/A'),
              _buildDetailRow('Ground Truth', predictionData['GroundTruth']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text('$label: $value'),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('dd-MM-yyyy, HH:mm').format(dateTime);
    return formattedDate;
  }
}


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prediction App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HistoryPage(),
    );
  }
}