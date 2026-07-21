import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/algorithm_data.dart';
import '../models/algorithm.dart';
import '../services/progress_store.dart';
import '../theme/app_theme.dart';
import '../widgets/quiz_score_badge.dart';
import 'algorithm_detail_screen.dart';

class AlgorithmListScreen extends StatefulWidget {
  const AlgorithmListScreen({super.key});

  @override
  State<AlgorithmListScreen> createState() => _AlgorithmListScreenState();
}

class _AlgorithmListScreenState extends State<AlgorithmListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static const Map<String, IconData> _icons = {
    'two_pointers': Icons.compare_arrows,
    'sliding_window': Icons.view_carousel_outlined,
    'stack': Icons.layers_outlined,
    'queue': Icons.linear_scale,
    'linked_list': Icons.link,
    'doubly_linked_list': Icons.sync_alt,
    'circular_linked_list': Icons.all_inclusive,
    'binary_search': Icons.search,
    'trees': Icons.account_tree_outlined,
    'sorting': Icons.sort,
    'heap': Icons.filter_list,
    'backtracking': Icons.call_split,
    'graph': Icons.hub_outlined,
    'greedy': Icons.trending_up,
    'hashing': Icons.tag,
    'dynamic_programming': Icons.grid_view_outlined,
    'union_find': Icons.group_work_outlined,
    'intervals': Icons.timeline_outlined,
    'trie': Icons.text_fields,
    'bit_manipulation': Icons.memory,
    'matrix_traversal': Icons.grid_on_outlined,
    'math_geometry': Icons.calculate_outlined,
  };

  IconData _iconFor(Algorithm algorithm) =>
      _icons[algorithm.id] ?? Icons.auto_awesome_outlined;

  @override
  Widget build(BuildContext context) {
    final algorithms = AlgorithmData.getAlgorithms();
    final Map<String, List<Algorithm>> categorized = {};
    for (final algorithm in algorithms) {
      categorized.putIfAbsent(algorithm.category, () => []).add(algorithm);
    }

    final query = _query.trim().toLowerCase();
    bool matches(Algorithm a) =>
        query.isEmpty ||
        a.name.toLowerCase().contains(query) ||
        a.description.toLowerCase().contains(query);

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Data Structures & Algorithms')),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            sliver: SliverToBoxAdapter(
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search algorithms',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() {
                            _searchController.clear();
                            _query = '';
                          }),
                        ),
                ),
              ),
            ),
          ),
          for (final entry in categorized.entries)
            if (entry.value.where(matches).toList() case final filtered when filtered.isNotEmpty) ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    entry.key,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                sliver: SliverList.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final algorithm = filtered[index];
                    return _AlgorithmCard(
                      algorithm: algorithm,
                      icon: _iconFor(algorithm),
                    );
                  },
                ),
              ),
            ],
          if (categorized.values.every((list) => !list.any(matches)))
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptySearchState(query: _query),
            ),
          const SliverPadding(padding: EdgeInsets.only(bottom: AppSpacing.xl)),
        ],
      ),
    );
  }
}

class _AlgorithmCard extends StatelessWidget {
  final Algorithm algorithm;
  final IconData icon;

  const _AlgorithmCard({required this.algorithm, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final result = context
        .watch<ProgressStore>()
        .resultFor(ProgressDomain.algorithm, algorithm.id);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlgorithmDetailScreen(algorithm: algorithm),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, color: theme.colorScheme.onPrimaryContainer, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(algorithm.name, style: theme.textTheme.titleMedium),
                        ),
                        if (result != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          QuizScoreBadge(result: result),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      algorithm.description,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(Icons.chevron_right, color: theme.colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  final String query;
  const _EmptySearchState({required this.query});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No algorithms match "$query"',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
