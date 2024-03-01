import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:ironman/common_widgets/Drawer/drawer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_switch/flutter_switch.dart';

class DeepLearn extends StatefulWidget {
  final String userName;
  final int userAge;
  final String userEmail;
  final int userPhone;

  const DeepLearn({
    Key? key,
    required this.userName,
    required this.userAge,
    required this.userEmail,
    required this.userPhone,
  }) : super(key: key);

  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<DeepLearn> {
  File? _image;
  String _predictionResult = '';
  int _selectedSample = 1;
  bool _groundTruthEnabled = false;

  Map<int, String> sampleImages = {
    1: '10_left.jpeg',
    2: '10_right.jpeg',
    3: '4723_left.jpeg',
    4: '4723_right.jpeg',
  };

  Map<int, String> groundTruthLabels = {
    1: 'Non Diabetic',
    2: 'Non Diabetic',
    3: 'Diabetic',
    4: 'Diabetic',
  };

  Future<void> _sendImage(String imagePath) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.29.231:5000/predict'),
      );
      final byteData = await rootBundle.load('assets/images/dl/$imagePath');
      final file = File('${(await getTemporaryDirectory()).path}/$imagePath');
      await file.writeAsBytes(
        byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
      );
      request.files.add(await http.MultipartFile.fromPath('image', file.path));
      var response = await request.send();
      if (response.statusCode == 200) {
        var result = await response.stream.bytesToString();
        var groundTruth = groundTruthLabels[_selectedSample] ?? 'Unknown'; // Replace 'Unknown' with your default value
         _showResultDialog(groundTruth , result);
        setState(() {
          _predictionResult = 'DL model prediction: $result';
        });
      } else {
        print('Failed to send image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending image: $e');
    }
  }

  void _selectSample(int sampleNumber) {
    setState(() {
      _selectedSample = sampleNumber;
      _image = null;
      _predictionResult = '';
    });
  }

  void _showResultDialog(String groundTruth, String prediction) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Prediction Result'),
        content: Column(
           mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Ground Truth: $groundTruth'),
            SizedBox(height: 10),
            Text('$prediction'),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
  title: const Text('Diabetes Prediction'),
  backgroundColor: Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : Colors.white,

      ),
      drawer: AppDrawer(
          userName: widget.userName,
          userAge: widget.userAge,
          userEmail: widget.userEmail,
          userPhone: widget.userPhone,
        ),
      backgroundColor:Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : Colors.white, // Dark background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Dropdown for selecting samples
            DropdownButton<int>(
              value: _selectedSample,
              onChanged: (value) => _selectSample(value!),
              items: List.generate(
                sampleImages.length,
                (index) => DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text('Sample ${index + 1}', style: TextStyle(color: Color.fromARGB(255, 138, 129, 129))), // White text color
                ),
              ),
            ),
            SizedBox(height: 20),
            // Display selected image or default text
            _image == null
                ? Image.asset(
                    'assets/images/dl/${sampleImages[_selectedSample]!}',
                    height: 200,
                    width: 200,
                  )
                : Image.file(
                    _image!,
                    height: 200,
                    width: 200,
                  ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _sendImage(sampleImages[_selectedSample]!),
              style: ElevatedButton.styleFrom(
                primary:Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black, // Purple button color
              ),
              child: Text('Predict',),
            ),
            SizedBox(height: 20),
            // Display Ground Truth if enabled
            // if (_groundTruthEnabled)
            //   Text(
            //     'Ground Truth: ${groundTruthLabels[_selectedSample]}',
            //     style: TextStyle(color: Color.fromARGB(255, 0, 0, 0),fontSize: 20), // White text color
            //   ),
            // SizedBox(height: 20),
            // // Display the prediction result
            // Text(
              // _predictionResult,
            //   style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)), // White text color
            // ),
            SizedBox(height: 20),
            // Toggle switch for ground truth
            FlutterSwitch(
              width: 60.0,
              height: 30.0,
              valueFontSize: 12.0,
              toggleSize: 20.0,
              value: _groundTruthEnabled,
              borderRadius: 30.0,
              padding: 2.0,
              activeColor: Colors.black,
              activeToggleColor: Color.fromARGB(255, 255, 254, 254),
              activeSwitchBorder: Border.all(
                color: const Color.fromARGB(255, 234, 229, 235),
                width: 2.0,
              ),
              inactiveToggleColor: Colors.grey,
              inactiveSwitchBorder: Border.all(
                color: Colors.grey,
                width: 2.0,
              ),
              onToggle: (value) {
                setState(() {
                  _groundTruthEnabled = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}