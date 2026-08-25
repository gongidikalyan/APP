import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/upgrade_pro_modal.dart';
import '../theme/app_theme.dart';
import 'add_milestone_screen.dart';

class MilestonesScreen extends StatefulWidget {
  const MilestonesScreen({super.key});

  @override
  State<MilestonesScreen> createState() => _MilestonesScreenState();
}

class _MilestonesScreenState extends State<MilestonesScreen> {
  List<Map<String, String>> _milestones = [];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = Provider.of<AppProvider>(context);
    final isPremium = provider.user.isPremium;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: isDark ? Colors.white : AppTheme.lightTextPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Achieved Milestones',
          style: TextStyle(
            color: isDark ? Colors.white : AppTheme.lightTextPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'milestones_fab',
        backgroundColor: isDark ? AppTheme.darkPrimary : AppTheme.pastelGrowthIcon,
        shape: const CircleBorder(),
        elevation: 4,
        child: Icon(
          !isPremium ? Icons.lock_rounded : Icons.add,
          color: Colors.white,
          size: 26,
        ),
        onPressed: () {
          if (!isPremium) {
            showUpgradeProModal(
              context,
              featureTitle: 'Achieved Milestones',
              limitExplanation: 'Free plan gives you read-only access. Upgrade to Pro for ₹49/month to record, track, and celebrate personal achievements.',
            );
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddMilestoneScreen(),
            ),
          ).then((newMs) {
            if (newMs != null && newMs is Map<String, String>) {
              setState(() {
                _milestones.insert(0, newMs);
              });
            }
          });
        },
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        children: [
          Text(
            'Achieved Milestones',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Your journey of excellence and progress, recorded for clarity.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 20),

          ..._milestones.map((m) => _buildMilestoneCard(context, m)).toList(),
          const SizedBox(height: 10),

          // Dashed Achievement Container
          GestureDetector(
            onTap: () {
              if (!isPremium) {
                showUpgradeProModal(
                  context,
                  featureTitle: 'Add Milestone',
                  limitExplanation: 'Upgrade to Pro for ₹49/month to record custom milestones and achievements.',
                );
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddMilestoneScreen(),
                ),
              );
            },
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1F2B) : const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFCBD5E1),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    !isPremium ? Icons.lock_rounded : Icons.emoji_events_outlined,
                    color: const Color(0xFF94A3B8),
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    !isPremium ? "Add Milestone (Pro Feature)" : "What's your next big achievement?",
                    style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildMilestoneCard(BuildContext context, Map<String, String> m) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    IconData badgeIcon = Icons.check_circle_rounded;
    if (m['icon'] == 'chart') badgeIcon = Icons.show_chart_rounded;
    if (m['icon'] == 'medal') badgeIcon = Icons.workspace_premium_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCardBg : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: AppTheme.darkCardBorder, width: 1) : null,
        boxShadow: isDark ? AppTheme.darkCardShadow : AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkIconBg : AppTheme.pastelGrowth,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  m['category']!,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: isDark ? AppTheme.darkIconGlow : AppTheme.pastelGrowthIcon,
                  ),
                ),
              ),
              Text(
                m['date']!,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            m['title']!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppTheme.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            m['description']!,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(
                badgeIcon,
                size: 16,
                color: isDark ? AppTheme.darkIconGlow : AppTheme.pastelGrowthIcon,
              ),
              const SizedBox(width: 6),
              Text(
                m['badge']!,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
