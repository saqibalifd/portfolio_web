import 'package:flutter/material.dart';
import 'package:myportfolio/constants/colors.dart';
import 'package:myportfolio/constants/sns_links.dart';
import 'package:web/web.dart' as web;

class MainDesktop extends StatelessWidget {
  const MainDesktop({super.key});

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
          Image.asset("assets/images/flutterlogo.png", width: screenWidth / 2),
        ],
      ),
    );
  }
}
