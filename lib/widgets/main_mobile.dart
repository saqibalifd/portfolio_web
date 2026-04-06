import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myportfolio/constants/colors.dart';
import 'package:web/web.dart' as web;

class MainMobile extends StatefulWidget {
  const MainMobile({super.key});

  @override
  State<MainMobile> createState() => _MainMobileState();
}

class _MainMobileState extends State<MainMobile> {
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
      height: screenHeight,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      constraints: BoxConstraints(maxHeight: 560),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //avatar image
          ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [
                  CustomColor.scaffoldBg.withValues(alpha: 0.6),
                  CustomColor.scaffoldBg.withValues(alpha: 0.6),
                ],
              ).createShader(bounds);
            },
            child: Image.asset(
              "assets/images/flutterlogo.png",
              width: screenWidth,
              height: screenHeight / 3,
            ),
          ),
          SizedBox(height: 5),
          //intro
          Text(
            "Hi, \nI'm Saqib Ali \nA Flutter Developer",
            style: TextStyle(
              height: 1.5,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: CustomColor.whitePrimary,
            ),
          ),
          SizedBox(height: 20),

          //button
          SizedBox(
            width: 190,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  CustomColor.yellowPrimary,
                ),
              ),
              onPressed: isLoading
                  ? null
                  : () {
                      web.window.open(resumeLink, "_blank");
                    },
              child: Text(
                'View Resume',
                style: TextStyle(color: CustomColor.whitePrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
