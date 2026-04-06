import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myportfolio/models/projects_model.dart';

class AddNewProjectAdminScreen extends StatefulWidget {
  final ProjectsModel? projectArg;

  const AddNewProjectAdminScreen({super.key, this.projectArg});

  @override
  State<AddNewProjectAdminScreen> createState() =>
      _AddNewProjectAdminScreenState();
}

class _AddNewProjectAdminScreenState extends State<AddNewProjectAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _projectType = 'work';

  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController thumbnailController = TextEditingController();
  final TextEditingController androidLinkController = TextEditingController();
  final TextEditingController iosLinkController = TextEditingController();
  final TextEditingController webLinkController = TextEditingController();
  final TextEditingController sourcecodeLinkController =
      TextEditingController();

  @override
  void initState() {
    super
        .initState(); // ✅ FIXED: must be first, was calling super.dispose() before
    if (widget.projectArg != null) {
      final p = widget.projectArg!;
      titleController.text = p.title;
      subtitleController.text =
          p.subtitle; // ✅ FIXED: was p.title (copy-paste bug)
      thumbnailController.text = p.thumbnail;
      androidLinkController.text = p.androidLink ?? '';
      iosLinkController.text = p.iosLink ?? '';
      webLinkController.text = p.webLink ?? '';
      sourcecodeLinkController.text = p.sourceCode ?? '';
      _projectType = p.projectType ?? 'work'; // ✅ restore saved type
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    subtitleController.dispose();
    thumbnailController.dispose();
    androidLinkController.dispose();
    iosLinkController.dispose();
    webLinkController.dispose();
    sourcecodeLinkController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      String docId =
          widget.projectArg?.projectId ??
          DateTime.now().millisecondsSinceEpoch.toString();
      final docRef = FirebaseFirestore.instance
          .collection('projects')
          .doc(docId);
      final projectsModel = ProjectsModel(
        thumbnail: thumbnailController.text.trim(),
        title: titleController.text.trim(),
        subtitle: subtitleController.text.trim(),
        androidLink: androidLinkController.text.trim(),
        iosLink: iosLinkController.text.trim(),
        sourceCode: sourcecodeLinkController.text.trim(),
        webLink: webLinkController.text.trim(),
        projectType: _projectType,
        projectId: docRef.id,
      );
      await docRef.set(projectsModel.toJson());
      if (!mounted) return;
      _showSuccessSnackbar();
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackbar(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF00C9B1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text(
              'Project added successfully!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFFF5C5C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.error_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Error: $msg',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0F),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF2A2A3A)),
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
        title: Text(
          widget.projectArg != null ? 'Edit Project' : 'Add New Project',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          children: [
            Container(
              height: 3,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF9B5DE5)],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            _SectionHeader(
              label: 'Basic Info',
              icon: Icons.info_outline_rounded,
            ),
            const SizedBox(height: 12),
            _FormField(
              controller: titleController,
              label: 'Project Title',
              hint: 'e.g. Portfolio App',
              icon: Icons.title_rounded,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Title is required' : null,
            ),
            const SizedBox(height: 12),
            _FormField(
              controller: subtitleController,
              label: 'Short Description',
              hint: 'e.g. A Flutter portfolio showcasing my work',
              icon: Icons.short_text_rounded,
              maxLines: 3,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Description is required' : null,
            ),
            const SizedBox(height: 12),
            _FormField(
              controller: thumbnailController,
              label: 'Thumbnail URL',
              hint: 'https://example.com/image.png',
              icon: Icons.image_rounded,
            ),
            const SizedBox(height: 20),
            _ProjectTypeToggle(
              selected: _projectType,
              onChanged: (v) => setState(() => _projectType = v),
            ),
            const SizedBox(height: 28),
            _SectionHeader(label: 'Platform Links', icon: Icons.link_rounded),
            const SizedBox(height: 4),
            const Text(
              'All links are optional — fill in what applies.',
              style: TextStyle(color: Color(0xFF555566), fontSize: 12),
            ),
            const SizedBox(height: 14),
            _FormField(
              controller: androidLinkController,
              label: 'Android',
              hint: 'Play Store URL',
              icon: Icons.android_rounded,
              iconColor: const Color(0xFF78C257),
            ),
            const SizedBox(height: 12),
            _FormField(
              controller: iosLinkController,
              label: 'iOS',
              hint: 'App Store URL',
              icon: Icons.apple_rounded,
              iconColor: const Color(0xFFAAAAAA),
            ),
            const SizedBox(height: 12),
            _FormField(
              controller: webLinkController,
              label: 'Web',
              hint: 'Live website URL',
              icon: Icons.language_rounded,
              iconColor: const Color(0xFF00C9B1),
            ),
            const SizedBox(height: 12),
            _FormField(
              controller: sourcecodeLinkController,
              label: 'Source Code',
              hint: 'GitHub / GitLab URL',
              icon: Icons.code_rounded,
              iconColor: const Color(0xFF6C63FF),
            ),
            const SizedBox(height: 36),
            _SubmitButton(isLoading: _isLoading, onTap: _submit),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SectionHeader({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF6C63FF), size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final Color? iconColor;
  final int maxLines;
  final String? Function(String?)? validator;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.iconColor,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? const Color(0xFF6C63FF);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFAAAAAA),
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF3A3A4A),
              fontSize: 13.5,
            ),
            filled: true,
            fillColor: const Color(0xFF13131C),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2A2A3A), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2A2A3A), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: color, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFFF5C5C),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFFF5C5C),
                width: 1.5,
              ),
            ),
            errorStyle: const TextStyle(
              color: Color(0xFFFF5C5C),
              fontSize: 11.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProjectTypeToggle extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const _ProjectTypeToggle({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.category_rounded,
                color: Color(0xFF6C63FF),
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Project Type',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF13131C),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF2A2A3A)),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              _TypeOption(
                value: 'work',
                selected: selected,
                label: 'Work',
                icon: Icons.business_center_rounded,
                activeColor: const Color(0xFF6C63FF),
                onTap: () => onChanged('work'),
              ),
              _TypeOption(
                value: 'hobby',
                selected: selected,
                label: 'Hobby',
                icon: Icons.palette_rounded,
                activeColor: const Color(0xFFFF6B6B),
                onTap: () => onChanged('hobby'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          selected == 'work'
              ? 'A client or professional project.'
              : 'A personal or fun side project.',
          style: const TextStyle(color: Color(0xFF555566), fontSize: 11.5),
        ),
      ],
    );
  }
}

class _TypeOption extends StatelessWidget {
  final String value;
  final String selected;
  final String label;
  final IconData icon;
  final Color activeColor;
  final VoidCallback onTap;

  const _TypeOption({
    required this.value,
    required this.selected,
    required this.label,
    required this.icon,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = selected == value;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? activeColor.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isActive
                ? Border.all(
                    color: activeColor.withValues(alpha: 0.4),
                    width: 1.5,
                  )
                : Border.all(color: Colors.transparent),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: isActive ? activeColor : const Color(0xFF555566),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? activeColor : const Color(0xFF555566),
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;
  const _SubmitButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 54,
        decoration: BoxDecoration(
          gradient: isLoading
              ? const LinearGradient(
                  colors: [Color(0xFF3A3A5A), Color(0xFF3A3A5A)],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6C63FF), Color(0xFF9B5DE5)],
                ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: isLoading
              ? []
              : [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white54),
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rocket_launch_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Publish Project',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
