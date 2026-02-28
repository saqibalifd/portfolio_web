import 'package:flutter/material.dart';
import 'package:myportfolio/constants/colors.dart';
import 'package:myportfolio/constants/sns_links.dart';
import 'package:web/web.dart' as web;

class MainMobile extends StatelessWidget {
  const MainMobile({super.key});

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
              onPressed: () {
                web.window.open(SnsLinks.linkedin, "_blank");
              },
              child: Text(
                'Get in touch',
                style: TextStyle(color: CustomColor.whitePrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
