import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AllMessagesAdminScreen extends StatelessWidget {
  const AllMessagesAdminScreen({super.key});

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
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: const Text(
                'Messages',
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
                              const Color(0xFF00C9B1).withValues(alpha: 0.12),
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
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('messages')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: _LoadingIndicator()),
                );
              }
              if (snapshot.hasError) {
                // Fallback: try without orderBy in case index not set up
                return SliverFillRemaining(
                  child: _ErrorState(error: snapshot.error.toString()),
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
                      child: _MessageCard(
                        index: index,
                        data: data,
                        onDelete: () async {
                          final confirmed = await _showDeleteDialog(context);
                          if (confirmed == true) {
                            await FirebaseFirestore.instance
                                .collection('messages')
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
          'Delete Message?',
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

// ─── Message Card ────────────────────────────────────────────────────────────

class _MessageCard extends StatefulWidget {
  final int index;
  final QueryDocumentSnapshot data;
  final VoidCallback onDelete;

  const _MessageCard({
    required this.index,
    required this.data,
    required this.onDelete,
  });

  @override
  State<_MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<_MessageCard> {
  bool _expanded = false;

  static const _avatarColors = [
    Color(0xFF6C63FF),
    Color(0xFF00C9B1),
    Color(0xFFFF6B6B),
    Color(0xFF9B5DE5),
    Color(0xFFFFBE0B),
  ];

  @override
  Widget build(BuildContext context) {
    final name = widget.data['name'] as String? ?? 'Unknown';
    final email = widget.data['email'] as String? ?? '';
    final message = widget.data['message'] as String? ?? '';
    final accent = _avatarColors[widget.index % _avatarColors.length];

    // Format timestamp if available
    String timeLabel = '';
    try {
      final ts = widget.data['createdAt'];
      if (ts != null && ts is Timestamp) {
        final dt = ts.toDate();
        final now = DateTime.now();
        final diff = now.difference(dt);
        if (diff.inMinutes < 60) {
          timeLabel = '${diff.inMinutes}m ago';
        } else if (diff.inHours < 24) {
          timeLabel = '${diff.inHours}h ago';
        } else if (diff.inDays < 7) {
          timeLabel = '${diff.inDays}d ago';
        } else {
          timeLabel = '${dt.day}/${dt.month}/${dt.year}';
        }
      }
    } catch (_) {}

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF13131C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A3A), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
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
            onTap: () => setState(() => _expanded = !_expanded),
            splashColor: accent.withValues(alpha: 0.6),
            highlightColor: accent.withValues(alpha: 0.03),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header row ──
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              accent.withValues(alpha: 0.35),
                              accent.withValues(alpha: 0.12),
                            ],
                          ),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : '?',
                            style: TextStyle(
                              color: accent,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Name + email
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.5,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(
                                  Icons.mail_outline_rounded,
                                  size: 11,
                                  color: Color(0xFF555566),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    email,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xFF666677),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Time + actions
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (timeLabel.isNotEmpty)
                            Text(
                              timeLabel,
                              style: const TextStyle(
                                color: Color(0xFF444455),
                                fontSize: 11,
                              ),
                            ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              _SmallAction(
                                icon: Icons.copy_rounded,
                                color: const Color(0xFF00C9B1),
                                tooltip: 'Copy email',
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: email));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: const Color(0xFF00C9B1),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      content: const Text(
                                        'Email copied!',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 6),
                              _SmallAction(
                                icon: Icons.delete_rounded,
                                color: const Color(0xFFFF5C5C),
                                tooltip: 'Delete',
                                onTap: widget.onDelete,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  // ── Message preview / expanded ──
                  if (message.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E0E16),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF222230),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message,
                            maxLines: _expanded ? null : 2,
                            overflow: _expanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFBBBBCC),
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                          if (message.length > 80) ...[
                            const SizedBox(height: 6),
                            Text(
                              _expanded ? 'Show less ▲' : 'Read more ▼',
                              style: TextStyle(
                                color: accent,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Small icon action button ─────────────────────────────────────────────────

class _SmallAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _SmallAction({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 15),
        ),
      ),
    );
  }
}

// ─── States ───────────────────────────────────────────────────────────────────

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
            valueColor: const AlwaysStoppedAnimation(Color(0xFF00C9B1)),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Loading messages...',
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
              color: const Color(0xFF00C9B1).withValues(alpha: 0.1),
            ),
            child: const Icon(
              Icons.mark_email_unread_rounded,
              color: Color(0xFF00C9B1),
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No messages yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Messages from your portfolio will appear here.',
            style: TextStyle(color: Color(0xFF555566), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String error;
  const _ErrorState({required this.error});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF5C5C).withValues(alpha: 0.1),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFFF5C5C),
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Something went wrong',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF555566), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
