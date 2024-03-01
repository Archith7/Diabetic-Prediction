import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ironman/DL.dart';
import 'package:ironman/common_widgets/Drawer/drawer.dart';
import 'package:ironman/constants/color.dart';
import 'package:ironman/constants/image_strings.dart';
import 'package:ironman/constants/sizes.dart';
import 'package:ironman/constants/text_string.dart';
import 'package:ironman/ML.dart';



class SuccessPage extends StatefulWidget {
  final String? message;
  const SuccessPage({Key? key, this.message}) : super(key: key);

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  String userName = "";
  int userAge = 0;
  String userEmail = "";
  int userPhone = 0;
  bool isFirstTime = true;
  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance.collection('users').doc(_user.uid).get();

      print(userDoc.data()); // Add this line
      print('hiiiii*******************************************');
      if (userDoc.exists) {
        setState(() {
         userName = userDoc.data()!['name'] ?? "";
          userAge = int.tryParse(userDoc.data()!['age'] ?? "") ?? 0;
          // userAge = userDoc.data()!['age'] ?? "";
          userEmail = userDoc.data()!['email'] ?? "";
          // userPhone = userDoc.data()!['phoneNumber'] ?? 0;
          userPhone = int.tryParse(userDoc.data()!['phoneNumber'] ?? "") ?? 0;
        });
      }
    } catch (error) {
      print('Error loading user data: $error');
    }
  }


@override
Widget build(BuildContext context) {
  // Show a snackbar when the page is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isFirstTime && widget.message != null) {
        _showSuccessSnackbar(context, widget.message!);
        isFirstTime = false;
      }
    });
  return WillPopScope(
      onWillPop: () async {
        
        SystemNavigator.pop();
        return true; 
      },
      child:Scaffold(
    appBar: AppBar(
      title: Text('Welcome, $userName'), 
      backgroundColor: Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : tPrimaryColor,
    ),
drawer: AppDrawer(
  userName: userName,
  userAge: userAge,
  userEmail: userEmail,
  userPhone: userPhone,
),
    backgroundColor: Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : tPrimaryColor,
    body:  Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Image(image: AssetImage(HomeImage1), height: 180),
            Column(
              children: [
               const Text(
                      Predict,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      
                      ),
                    ),
                Text(stitle,
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.to(() => DiabetesPredictionPage(
                       userName: userName,
                       userAge: userAge,
                       userEmail: userEmail,
                       userPhone: userPhone,)),
                    child: Text(ML.toUpperCase()),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => DeepLearn(
                      userName: userName,
                       userAge: userAge,
                       userEmail: userEmail,
                       userPhone: userPhone
                    )),
                    child: Text(DL.toUpperCase()),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
 }
 void _showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}