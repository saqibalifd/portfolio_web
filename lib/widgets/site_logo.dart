import 'package:flutter/material.dart';
import 'package:myportfolio/admin/all_project_admin_screen.dart.dart';
import 'package:myportfolio/constants/colors.dart';

class SiteLogo extends StatefulWidget {
  final VoidCallback? onTap;
  const SiteLogo({super.key, this.onTap});

  @override
  State<SiteLogo> createState() => _SiteLogoState();
}

class _SiteLogoState extends State<SiteLogo>
    with SingleTickerProviderStateMixin {
  int _tapCount = 0;
  static const int _requiredTaps = 5;

  late AnimationController _glitchController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _glitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnim =
        TweenSequence([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 40),
          TweenSequenceItem(tween: Tween(begin: 1.15, end: 0.92), weight: 30),
          TweenSequenceItem(tween: Tween(begin: 0.92, end: 1.0), weight: 30),
        ]).animate(
          CurvedAnimation(parent: _glitchController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _glitchController.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onTap?.call();
    setState(() => _tapCount++);
    _glitchController.forward(from: 0);

    if (_tapCount >= _requiredTaps) {
      setState(() => _tapCount = 0);
      Future.delayed(const Duration(milliseconds: 250), () {
        if (!mounted) return;
        _showPasswordDialog();
      });
    }
  }

  void _showPasswordDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (_) => _PasswordDialog(
        onSuccess: () {
          Navigator.of(context).pop(); // close dialog
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, animation, __) => FadeTransition(
                opacity: animation,
                child: const AllProjectAdminScreen(),
              ),
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Text(
              'Portfolio',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: CustomColor.yellowSecondary,
              ),
            ),
            if (_tapCount > 0)
              Positioned(
                bottom: -8,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_requiredTaps, (i) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: i < _tapCount ? 5 : 4,
                      height: i < _tapCount ? 5 : 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i < _tapCount
                            ? CustomColor.yellowSecondary
                            : CustomColor.yellowSecondary.withValues(
                                alpha: 0.2,
                              ),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Password Dialog ──────────────────────────────────────────────────────────

class _PasswordDialog extends StatefulWidget {
  final VoidCallback onSuccess;
  const _PasswordDialog({required this.onSuccess});

  @override
  State<_PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<_PasswordDialog>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  bool _obscure = true;
  bool _hasError = false;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnim;

  static const _correctPassword = 'saqibfd';

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim =
        TweenSequence([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 20),
          TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 20),
          TweenSequenceItem(tween: Tween(begin: 10.0, end: -8.0), weight: 20),
          TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 20),
          TweenSequenceItem(tween: Tween(begin: 8.0, end: 0.0), weight: 20),
        ]).animate(
          CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_controller.text.trim() == _correctPassword) {
      widget.onSuccess();
    } else {
      setState(() => _hasError = true);
      _shakeController.forward(from: 0);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _hasError = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _shakeAnim,
        builder: (context, child) => Transform.translate(
          offset: Offset(_shakeAnim.value, 0),
          child: child,
        ),
        child: Container(
          width: 340,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFF13131C),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _hasError
                  ? const Color(0xFFFF5C5C).withValues(alpha: 0.6)
                  : const Color(0xFF2A2A3A),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_rounded,
                  color: Color(0xFF6C63FF),
                  size: 28,
                ),
              ),
              const SizedBox(height: 18),

              // Title
              const Text(
                'Admin Access',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Enter password to continue',
                style: TextStyle(color: Color(0xFF555566), fontSize: 13),
              ),
              const SizedBox(height: 24),

              // Password field
              TextField(
                controller: _controller,
                obscureText: _obscure,
                autofocus: true,
                onSubmitted: (_) => _submit(),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: const TextStyle(
                    color: Color(0xFF3A3A4A),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF0A0A0F),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() => _obscure = !_obscure),
                    child: Icon(
                      _obscure
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: const Color(0xFF555566),
                      size: 18,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2A2A3A)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _hasError
                          ? const Color(0xFFFF5C5C)
                          : const Color(0xFF2A2A3A),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _hasError
                          ? const Color(0xFFFF5C5C)
                          : const Color(0xFF6C63FF),
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              // Error message
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: _hasError
                    ? const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              color: Color(0xFFFF5C5C),
                              size: 14,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Incorrect password. Try again.',
                              style: TextStyle(
                                color: Color(0xFFFF5C5C),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 22),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF2A2A3A)),
                        ),
                        child: const Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFFAAAAAA),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: _submit,
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C63FF), Color(0xFF9B5DE5)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF6C63FF,
                              ).withValues(alpha: 0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Enter',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
