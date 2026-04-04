import 'package:cloud_firestore/cloud_firestore.dart';
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

  bool _isSending = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _sendMessage() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final message = messageController.text.trim();

    // ── Validation ──
    if (name.isEmpty) {
      _showSnackbar('Please enter your name.', isError: true);
      return;
    }
    if (email.isEmpty) {
      _showSnackbar('Please enter your email.', isError: true);
      return;
    }
    if (!_isValidEmail(email)) {
      _showSnackbar('Please enter a valid email address.', isError: true);
      return;
    }
    if (message.isEmpty) {
      _showSnackbar('Please enter your message.', isError: true);
      return;
    }

    setState(() => _isSending = true);

    try {
      await FirebaseFirestore.instance.collection('messages').add({
        'name': name,
        'email': email,
        'message': message,
        'createdAt': FieldValue.serverTimestamp(),
      });

      nameController.clear();
      emailController.clear();
      messageController.clear();

      _showSnackbar('Message sent! I\'ll get back to you soon 🎉');
    } catch (e) {
      _showSnackbar('Failed to send message. Please try again.', isError: true);
    } finally {
      setState(() => _isSending = false);
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError
            ? const Color(0xFFFF5C5C)
            : const Color(0xFF00C9B1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 60),
      color: CustomColor.bgLight1,
      child: Column(
        children: [
          // Title
          Text(
            "Get in touch",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: CustomColor.whitePrimary,
            ),
          ),
          const SizedBox(height: 50),

          // Name + Email fields
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700, maxHeight: 100),
            child: Responsive.widget(
              context: context,
              mobile: buildNameEmailFieldMobile(),
              desktop: buildNameEmailFieldDesktop(),
            ),
          ),
          const SizedBox(height: 15),

          // Message field
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: CustomTextfield(
              hintText: 'Your message',
              controller: messageController,
              maxLine: 16,
            ),
          ),
          const SizedBox(height: 20),

          // Send button
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: _isSending ? null : _sendMessage,
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    _isSending
                        ? CustomColor.yellowPrimary.withOpacity(0.5)
                        : CustomColor.yellowPrimary,
                  ),
                ),
                child: _isSending
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Get in touch',
                        style: TextStyle(color: CustomColor.whitePrimary),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: const Divider(),
          ),
          const SizedBox(height: 15),

          // SNS icon buttons
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              InkWell(
                onTap: () => web.window.open(SnsLinks.github, "_blank"),
                child: Image.asset("assets/images/githubwhite.png", width: 28),
              ),
              InkWell(
                onTap: () => web.window.open(SnsLinks.linkedin, "_blank"),
                child: Image.asset(
                  "assets/images/linkedinwhite.png",
                  width: 28,
                ),
              ),
              InkWell(
                onTap: () => web.window.open(SnsLinks.patreon, "_blank"),
                child: Image.asset("assets/images/patreonwhite.png", width: 28),
              ),
              InkWell(
                onTap: () => web.window.open(SnsLinks.facebook, "_blank"),
                child: Image.asset(
                  "assets/images/facebookwhite.png",
                  width: 28,
                ),
              ),
              InkWell(
                onTap: () => web.window.open(SnsLinks.tiktok, "_blank"),
                child: Image.asset("assets/images/tiktokwhite.png", width: 28),
              ),
              InkWell(
                onTap: () => web.window.open(SnsLinks.insta, "_blank"),
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
        Flexible(
          child: CustomTextfield(
            hintText: 'Your name',
            controller: nameController,
          ),
        ),
        const SizedBox(width: 15),
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
        Flexible(
          child: CustomTextfield(
            hintText: 'Your name',
            controller: nameController,
          ),
        ),
        const SizedBox(height: 15),
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
