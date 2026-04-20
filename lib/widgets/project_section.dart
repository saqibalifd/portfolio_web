import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myportfolio/constants/colors.dart';
import 'package:myportfolio/models/projects_model.dart';
import 'package:myportfolio/widgets/project_card_widget.dart';

class ProjectSection extends StatelessWidget {
  const ProjectSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('projects').snapshots(),
      builder: (context, snapshot) {
        // ── Loading state ──────────────────────────────────────────────
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _ProjectSkeletonLoader(screenWidth: screenWidth);
        }

        // ── Error state ────────────────────────────────────────────────
        if (snapshot.hasError) {
          return _ErrorState(message: snapshot.error.toString());
        }

        // ── Parse docs ────────────────────────────────────────────────
        final docs = snapshot.data?.docs ?? [];
        final allProjects = docs
            .map(
              (doc) =>
                  ProjectsModel.fromJson(doc.data() as Map<String, dynamic>),
            )
            .toList();

        final workProjects = allProjects
            .where((p) => p.projectType == 'work')
            .toList();
        final hobbyProjects = allProjects
            .where((p) => p.projectType == 'hobby')
            .toList();

        // ── Content ───────────────────────────────────────────────────
        return Container(
          width: screenWidth,
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
          child: Column(
            children: [
              // Work Projects
              _SectionTitle(title: 'Work Projects'),
              const SizedBox(height: 50),
              workProjects.isEmpty
                  ? _EmptyState(
                      icon: Icons.business_center_rounded,
                      label: 'No work projects yet',
                      color: const Color(0xFF6C63FF),
                    )
                  : ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: Wrap(
                        spacing: 25,
                        runSpacing: 25,
                        children: workProjects
                            .map((p) => ProjectCardWidget(project: p))
                            .toList(),
                      ),
                    ),

              const SizedBox(height: 80),

              // Hobby Projects
              _SectionTitle(title: 'Hobby Projects'),
              const SizedBox(height: 50),
              hobbyProjects.isEmpty
                  ? _EmptyState(
                      icon: Icons.palette_rounded,
                      label: 'No hobby projects yet',
                      color: const Color(0xFFFF6B6B),
                    )
                  : ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: Wrap(
                        spacing: 25,
                        runSpacing: 25,
                        children: hobbyProjects
                            .map((p) => ProjectCardWidget(project: p))
                            .toList(),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Section Title ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: CustomColor.whitePrimary,
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _EmptyState({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 900),
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF13131C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A2A3A)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFAAAAAA),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Projects added from the admin panel will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF555566), fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}

// ─── Error State ──────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0D0D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF5C5C).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFFF5C5C),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Failed to load projects: $message',
              style: const TextStyle(color: Color(0xFFFF5C5C), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Skeleton Loader ──────────────────────────────────────────────────────────

class _ProjectSkeletonLoader extends StatefulWidget {
  final double screenWidth;
  const _ProjectSkeletonLoader({required this.screenWidth});

  @override
  State<_ProjectSkeletonLoader> createState() => _ProjectSkeletonLoaderState();
}

class _ProjectSkeletonLoaderState extends State<_ProjectSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _shimmer = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (context, _) {
        final shimmerColor = Color.lerp(
          const Color(0xFF1E1E2A),
          const Color(0xFF2A2A3C),
          _shimmer.value,
        )!;
        final highlightColor = Color.lerp(
          const Color(0xFF2A2A3C),
          const Color(0xFF3A3A50),
          _shimmer.value,
        )!;

        return Container(
          width: widget.screenWidth,
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Section title skeleton
              _SkeletonBox(
                width: 160,
                height: 26,
                color: shimmerColor,
                highlight: highlightColor,
              ),
              const SizedBox(height: 40),
              // Cards row
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Wrap(
                  spacing: 25,
                  runSpacing: 25,
                  children: List.generate(
                    3,
                    (_) => _SkeletonCard(
                      base: shimmerColor,
                      highlight: highlightColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
              // Second section title
              _SkeletonBox(
                width: 180,
                height: 26,
                color: shimmerColor,
                highlight: highlightColor,
              ),
              const SizedBox(height: 40),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Wrap(
                  spacing: 25,
                  runSpacing: 25,
                  children: List.generate(
                    2,
                    (_) => _SkeletonCard(
                      base: shimmerColor,
                      highlight: highlightColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  final Color base;
  final Color highlight;
  const _SkeletonCard({required this.base, required this.highlight});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF13131C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail placeholder
          _SkeletonBox(
            width: double.infinity,
            height: 150,
            color: base,

            highlight: highlight,
            radius: 12,
          ),
          const SizedBox(height: 14),
          // Title
          _SkeletonBox(
            width: 160,
            height: 16,
            color: base,
            highlight: highlight,
          ),
          const SizedBox(height: 8),
          // Subtitle line 1
          _SkeletonBox(
            width: double.infinity,
            height: 12,
            color: base,
            highlight: highlight,
          ),
          const SizedBox(height: 6),
          // Subtitle line 2
          _SkeletonBox(
            width: 200,
            height: 12,
            color: base,
            highlight: highlight,
          ),
          const SizedBox(height: 14),
          // Tag chips
          Row(
            children: [
              _SkeletonBox(
                width: 60,
                height: 24,
                color: base,
                highlight: highlight,
                radius: 20,
              ),
              const SizedBox(width: 8),
              _SkeletonBox(
                width: 60,
                height: 24,
                color: base,
                highlight: highlight,
                radius: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Color highlight;
  final double radius;

  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.color,
    required this.highlight,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, highlight, color],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
