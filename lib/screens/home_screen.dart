import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'algorithm_list_screen.dart';
import 'system_design_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'AllGoldRhythm',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.school,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
      children: const [
        Text(
          'A Data Structures & Algorithms and System Design interview-prep app.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const _AppDrawer(),
      appBar: AppBar(
        title: const Text('AllGoldRhythm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: () => _showAbout(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text('What do you want to practice?', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Pick a track to get started.',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
          ),
          const SizedBox(height: AppSpacing.lg),
          _FocusCard(
            icon: Icons.code,
            title: 'Data Structures & Algorithms',
            description: 'Simulate, review, and quiz yourself on 21 core patterns.',
            color: theme.colorScheme.primaryContainer,
            onColor: theme.colorScheme.onPrimaryContainer,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AlgorithmListScreen()),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _FocusCard(
            icon: Icons.architecture_outlined,
            title: 'System Design',
            description: 'Learn the fundamentals, then practice on an interactive design canvas.',
            color: theme.colorScheme.tertiaryContainer,
            onColor: theme.colorScheme.onTertiaryContainer,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SystemDesignListScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Color onColor;
  final VoidCallback onTap;

  const _FocusCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      color: color,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: onColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, size: 26, color: onColor),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: onColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(color: onColor.withValues(alpha: 0.85)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(Icons.arrow_forward_ios, size: 16, color: onColor.withValues(alpha: 0.7)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: theme.colorScheme.primary),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'AllGoldRhythm',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Data Structures & Algorithms'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AlgorithmListScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.architecture_outlined),
            title: const Text('System Design'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SystemDesignListScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: const Text('Licenses'),
            onTap: () {
              Navigator.pop(context);
              showLicensePage(
                context: context,
                applicationName: 'AllGoldRhythm',
                applicationVersion: '1.0.0',
                applicationIcon: Icon(
                  Icons.school,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
