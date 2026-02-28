import 'package:flutter/material.dart';
import 'package:myportfolio/constants/colors.dart';
import 'package:myportfolio/responsive/responsive.dart';
import 'package:myportfolio/widgets/contact_section.dart';
import 'package:myportfolio/widgets/drawer_mobile.dart';
import 'package:myportfolio/widgets/footer.dart';
import 'package:myportfolio/widgets/header_desktop.dart';

import 'package:myportfolio/widgets/header_mobile.dart';
import 'package:myportfolio/widgets/main_desktop.dart';
import 'package:myportfolio/widgets/main_mobile.dart';
import 'package:myportfolio/widgets/project_section.dart';
import 'package:myportfolio/widgets/skills_desktop.dart';
import 'package:myportfolio/widgets/skills_mobile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();
  final List<GlobalKey> navbarKeys = List.generate(4, (index) => GlobalKey());
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: CustomColor.scaffoldBg,
      endDrawer: Responsive.isDesktop(context)
          ? null
          : DrawerMobile(
              onNavItemTap: (int navIndex) {
                scrollToSection(navIndex);
                scaffoldKey.currentState?.closeEndDrawer();
              },
            ),
      body: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(key: navbarKeys[0]),
            //header
            Responsive.widget(
              context: context,
              mobile: HeaderMobile(
                onMenuTap: scaffoldKey.currentState?.openEndDrawer,
              ),
              desktop: HeaderDesktop(
                onNavItemTap: (int navIndex) {
                  scrollToSection(navIndex);
                },
              ),
            ),

            //main
            Responsive.widget(
              context: context,
              mobile: MainMobile(),
              desktop: MainDesktop(),
            ),

            //skills
            Container(
              key: navbarKeys[1],
              width: screenWidth,
              color: CustomColor.bgLight1,
              padding: EdgeInsets.fromLTRB(25, 20, 25, 60),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "What I can do",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: CustomColor.whitePrimary,
                    ),
                  ),
                  SizedBox(height: 50),
                  Responsive.widget(
                    context: context,
                    mobile: SkillsMobile(),
                    desktop: SkillsDesktop(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            //  project
            ProjectSection(key: navbarKeys[2]),
            SizedBox(height: 30),
            //contact
            ContactSection(key: navbarKeys[3]),
            SizedBox(height: 30),

            //footer
            Footer(),
          ],
        ),
      ),
    );
  }

  void scrollToSection(int navIndex) {
    final key = navbarKeys[navIndex];
    Scrollable.ensureVisible(
      key.currentContext!,

      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
