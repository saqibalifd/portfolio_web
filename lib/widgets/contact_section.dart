import 'package:flutter/material.dart';
import 'package:myportfolio/constants/colors.dart';
import 'package:myportfolio/constants/sns_links.dart';
import 'package:myportfolio/responsive/responsive.dart';
import 'package:myportfolio/widgets/custom_textfield.dart';
import 'package:web/web.dart' as web;

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 20, 25, 60),
      color: CustomColor.bgLight1,
      child: Column(
        children: [
          //title
          Text(
            "Get in touch",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: CustomColor.whitePrimary,
            ),
          ),
          SizedBox(height: 50),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 700, maxHeight: 100),
            child: Responsive.widget(
              context: context,
              mobile: buildNameEmailFieldMobile(),
              desktop: buildNameEmailFieldDesktop(),
            ),
          ),
          SizedBox(height: 15),

          //message
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 700),

            child: CustomTextfield(
              hintText: 'Your message',

              controller: messageController,
              maxLine: 16,
            ),
          ),
          SizedBox(height: 20),
          // send button
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 700),

            child: SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  nameController.clear();
                  emailController.clear();
                  messageController.clear();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    CustomColor.yellowPrimary,
                  ),
                ),
                child: Text(
                  'Get in touch',
                  style: TextStyle(color: CustomColor.whitePrimary),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 300),
            child: const Divider(),
          ),
          SizedBox(height: 15),

          //sns icon button links
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  web.window.open(SnsLinks.github, "_blank");
                },
                child: Image.asset("assets/images/githubwhite.png", width: 28),
              ),
              InkWell(
                onTap: () {
                  web.window.open(SnsLinks.linkedin, "_blank");
                },
                child: Image.asset(
                  "assets/images/linkedinwhite.png",
                  width: 28,
                ),
              ),
              InkWell(
                onTap: () {
                  web.window.open(SnsLinks.patreon, "_blank");
                },
                child: Image.asset("assets/images/patreonwhite.png", width: 28),
              ),
              InkWell(
                onTap: () {
                  web.window.open(SnsLinks.facebook, "_blank");
                },
                child: Image.asset(
                  "assets/images/facebookwhite.png",
                  width: 28,
                ),
              ),
              InkWell(
                onTap: () {
                  web.window.open(SnsLinks.tiktok, "_blank");
                },
                child: Image.asset("assets/images/tiktokwhite.png", width: 28),
              ),
              InkWell(
                onTap: () {
                  web.window.open(SnsLinks.insta, "_blank");
                },
                child: Image.asset("assets/images/instawhite.png", width: 28),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row buildNameEmailFieldDesktop() {
    return Row(
      children: [
        //name
        Flexible(
          child: CustomTextfield(
            hintText: 'Your name',
            controller: nameController,
          ),
        ),
        SizedBox(width: 15),
        //email
        Flexible(
          child: CustomTextfield(
            hintText: 'Your email',
            controller: emailController,
          ),
        ),
      ],
    );
  }

  Column buildNameEmailFieldMobile() {
    return Column(
      children: [
        //name
        Flexible(
          child: CustomTextfield(
            hintText: 'Your name',
            controller: nameController,
          ),
        ),
        SizedBox(height: 15),
        //email
        Flexible(
          child: CustomTextfield(
            hintText: 'Your email',
            controller: emailController,
          ),
        ),
      ],
    );
  }
}
