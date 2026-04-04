import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myportfolio/admin/add_new_project_admin_screen.dart';
import 'package:myportfolio/admin/all_message_admin_screen.dart';
import 'package:myportfolio/models/projects_model.dart';

class AllProjectAdminScreen extends StatelessWidget {
  const AllProjectAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: const Color(0xFF0A0A0F),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: const Text(
                'Projects',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0D0D1A), Color(0xFF0A0A0F)],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -30,
                      right: -30,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF6C63FF).withOpacity(0.15),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 8),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _MessagesButton(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const AllMessagesAdminScreen(), // your screen here
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 8),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _AddButton(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddNewProjectAdminScreen(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('projects')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: _LoadingIndicator()),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const SliverFillRemaining(child: _EmptyState());
              }
              final docs = snapshot.data!.docs;
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final data = docs[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ProjectCard(
                        index: index,
                        data: data,
                        onEdit: () {
                          // ✅ FIXED: was wrapped in an extra anonymous closure that was never called
                          final ProjectsModel projectsModel = ProjectsModel(
                            thumbnail: data['thumbnail'] ?? '',
                            title: data['title'] ?? '',
                            subtitle: data['subtitle'] ?? '',
                            androidLink: data['androidLink'] ?? '',
                            iosLink: data['iosLink'] ?? '',
                            projectType: data['projectType'] ?? 'work',
                            sourceCode: data['sourceCode'] ?? '',
                            webLink: data['webLink'] ?? '',
                            projectId: data['projectId'] ?? '',
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddNewProjectAdminScreen(
                                projectArg: projectsModel,
                              ),
                            ),
                          );
                        },
                        onDelete: () async {
                          final confirmed = await _showDeleteDialog(context);
                          if (confirmed == true) {
                            await FirebaseFirestore.instance
                                .collection('projects')
                                .doc(data.id)
                                .delete();
                          }
                        },
                      ),
                    );
                  }, childCount: docs.length),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF16161F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF2A2A3A)),
        ),
        title: const Text(
          'Delete Project?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'This action cannot be undone.',
          style: TextStyle(color: Color(0xFF888899)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF888899)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFFF5C5C)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sub-widgets ────────────────────────────────────────────────────────────
class _MessagesButton extends StatelessWidget {
  final VoidCallback onTap;
  const _MessagesButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00C9B1), Color(0xFF0BA895)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00C9B1).withOpacity(0.30),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 16),
            SizedBox(width: 6),
            Text(
              'Messages',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF9B5DE5)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, color: Colors.white, size: 18),
            SizedBox(width: 6),
            Text(
              'New Project',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final int index;
  final QueryDocumentSnapshot data;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProjectCard({
    required this.index,
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final thumbnail = data['thumbnail'] as String? ?? '';
    final title = data['title'] as String? ?? 'Untitled';
    final subtitle = data['subtitle'] as String? ?? '';
    final projectType = data['projectType'] as String? ?? 'work';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF13131C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A3A), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onEdit,
            splashColor: const Color(0xFF6C63FF).withOpacity(0.08),
            highlightColor: const Color(0xFF6C63FF).withOpacity(0.04),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _ProjectThumbnail(url: thumbnail, index: index),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF777788),
                            fontSize: 12.5,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // ✅ Project type badge — visible on the card
                        _TypeBadge(type: projectType),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      _IconAction(
                        icon: Icons.edit_rounded,
                        color: const Color(0xFF6C63FF),
                        onTap: onEdit,
                      ),
                      const SizedBox(height: 6),
                      _IconAction(
                        icon: Icons.delete_rounded,
                        color: const Color(0xFFFF5C5C),
                        onTap: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String type;
  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final isWork = type == 'work';
    final color = isWork ? const Color(0xFF6C63FF) : const Color(0xFFFF6B6B);
    final icon = isWork ? Icons.business_center_rounded : Icons.palette_rounded;
    final label = isWork ? 'Work' : 'Hobby';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectThumbnail extends StatelessWidget {
  final String url;
  final int index;
  const _ProjectThumbnail({required this.url, required this.index});

  static const _colors = [
    Color(0xFF6C63FF),
    Color(0xFF9B5DE5),
    Color(0xFF00C9B1),
    Color(0xFFFF6B6B),
    Color(0xFFFFBE0B),
  ];

  @override
  Widget build(BuildContext context) {
    final accent = _colors[index % _colors.length];
    if (url.isNotEmpty) {
      return Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent.withOpacity(0.4), width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.5),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallback(accent),
          ),
        ),
      );
    }
    return _fallback(accent);
  }

  Widget _fallback(Color accent) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accent.withOpacity(0.3), accent.withOpacity(0.1)],
        ),
        border: Border.all(color: accent.withOpacity(0.4), width: 1.5),
      ),
      child: Icon(Icons.folder_rounded, color: accent, size: 22),
    );
  }
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _IconAction({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: const AlwaysStoppedAnimation(Color(0xFF6C63FF)),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Loading projects...',
          style: TextStyle(color: Color(0xFF555566), fontSize: 13),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF6C63FF).withOpacity(0.1),
            ),
            child: const Icon(
              Icons.layers_rounded,
              color: Color(0xFF6C63FF),
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No projects yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap "New Project" to add your first one.',
            style: TextStyle(color: Color(0xFF555566), fontSize: 13),
          ),
        ],
      ),
    );
  }
}
