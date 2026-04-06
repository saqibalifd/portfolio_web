import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myportfolio/constants/colors.dart';
import 'package:web/web.dart' as web;

class MainDesktop extends StatefulWidget {
  const MainDesktop({super.key});

  @override
  State<MainDesktop> createState() => _MainDesktopState();
}

class _MainDesktopState extends State<MainDesktop> {
  // ADD THESE TWO LINES
  String resumeLink = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchResumeLink(); // ADD THIS
  }

  // ADD THIS METHOD
  Future<void> fetchResumeLink() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('about')
          .doc('cv')
          .get();

      if (doc.exists && doc.data() != null) {
        setState(() {
          resumeLink = doc.data()!['link'] ?? '';
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching resume link: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: screenHeight / 1.2,
      constraints: BoxConstraints(maxHeight: 350),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Hi, \nI'm Saqib Ali \nA Flutter Developer",
                style: TextStyle(
                  height: 1.5,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: CustomColor.whitePrimary,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      CustomColor.yellowPrimary,
                    ),
                  ),
                  onPressed: () {
                    isLoading ? null : web.window.open(resumeLink, "_blank");
                  },
                  child: Text(
                    'View Resume',
                    style: TextStyle(color: CustomColor.whitePrimary),
                  ),
                ),
              ),
            ],
          ),
          Image.asset("assets/images/flutterlogo.png", width: screenWidth / 2),
        ],
      ),
    );
  }
}
