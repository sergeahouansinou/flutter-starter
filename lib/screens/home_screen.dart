import 'package:cardifly/ui/components/app_drawer.dart';
import 'package:cardifly/ui/components/app_drawer_icon.dart';
import 'package:cardifly/ui/components/app_empty_state.dart';
import 'package:cardifly/ui/components/app_error_state.dart';
import 'package:cardifly/ui/components/app_list_skeleton.dart';
import 'package:cardifly/ui/components/app_pull_to_refresh.dart';
import 'package:cardifly/utils/constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum _LoadState { loading, ready, empty, error }

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  static const int _pageSize = 8;

  late final AppRefreshController _refreshController;
  late final AnimationController _entryController;

  _LoadState _state = _LoadState.loading;
  List<_HomeCard> _cards = [];

  @override
  void initState() {
    super.initState();
    _refreshController = AppRefreshController();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _initialLoad();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  Future<void> _initialLoad() async {
    setState(() => _state = _LoadState.loading);
    try {
      final data = await _fetchPage(page: 1);
      if (!mounted) return;
      setState(() {
        _cards = data;
        _state = data.isEmpty ? _LoadState.empty : _LoadState.ready;
      });
      _entryController.forward(from: 0);
      if (data.length < _pageSize) _refreshController.loadNoData();
    } catch (_) {
      if (!mounted) return;
      setState(() => _state = _LoadState.error);
    }
  }

  Future<void> _onRefresh() async {
    final data = await _fetchPage(page: 1);
    if (!mounted) return;
    setState(() {
      _cards = data;
      _state = data.isEmpty ? _LoadState.empty : _LoadState.ready;
    });
    _entryController.forward(from: 0);
    if (data.length < _pageSize) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
  }

  Future<void> _onLoadMore() async {
    final next = await _fetchPage(page: (_cards.length ~/ _pageSize) + 1);
    if (!mounted) return;
    setState(() => _cards = [..._cards, ...next]);
    if (next.length < _pageSize) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
  }

  /// Simulated fetch — swap for a real repository call when wiring the API.
  Future<List<_HomeCard>> _fetchPage({required int page}) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (page > 3) return const [];
    return List.generate(_pageSize, (i) {
      final index = (page - 1) * _pageSize + i;
      return _HomeCard(
        id: index,
        title: 'Carte #${index + 1}',
        subtitle: 'MàJ · ${(index % 12) + 1}h',
        accent: _paletteFor(index),
      );
    });
  }

  Color _paletteFor(int index) {
    const palette = [
      Constants.appPrimaryColor,
      Color(0xFF00B894),
      Color(0xFFEB6F92),
      Color(0xFF9B5DE5),
      Color(0xFFF15BB5),
      Color(0xFFF9A825),
    ];
    return palette[index % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        leading: Builder(
          builder: (ctx) => Center(
            child: AppDrawerIcon(
              onTap: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
        ),
        titleSpacing: 0,
        title: const Text('Cardifly'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, size: 18),
            onPressed: () {},
            splashRadius: 16,
            tooltip: 'Rechercher',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, size: 18),
            onPressed: () {},
            splashRadius: 16,
            tooltip: 'Notifications',
          ),
          const SizedBox(width: 4),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          _HomeHeader(onRefresh: _onRefresh),
          Expanded(child: _buildBody()),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case _LoadState.loading:
        return const AppListSkeleton();
      case _LoadState.error:
        return AppErrorState(
          message: 'Impossible de charger vos cartes.',
          onRetry: _initialLoad,
        );
      case _LoadState.empty:
        return AppEmptyState(
          title: 'Aucune carte',
          message: 'Ajoutez votre première carte pour commencer.',
          icon: Icons.credit_card_outlined,
          actionLabel: 'Actualiser',
          onAction: _onRefresh,
        );
      case _LoadState.ready:
        return AppPullToRefresh(
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoadMore: _onLoadMore,
          child: CustomScrollView(
            controller: _refreshController.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
                sliver: SliverToBoxAdapter(child: _HomeSectionHeader()),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList.separated(
                  itemCount: _cards.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return _HomeCardTile(
                      card: _cards[index],
                      entry: _entryController,
                      index: index,
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: AppLoadMoreFooter(controller: _refreshController),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 64)),
            ],
          ),
        );
    }
  }
}

// ────────────────────────────────────────────────────────────────
// Sub-widgets — all compact
// ────────────────────────────────────────────────────────────────

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Constants.appPrimaryColor,
            Constants.appPrimaryColor.withValues(alpha: 0.85),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Constants.appPrimaryColor.withValues(alpha: 0.22),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.credit_card_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour 👋',
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
                SizedBox(height: 1),
                Text(
                  'Vos cartes Cardifly',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            color: Colors.white,
            splashRadius: 16,
            constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
            padding: EdgeInsets.zero,
            tooltip: 'Actualiser',
          ),
        ],
      ),
    );
  }
}

class _HomeSectionHeader extends StatelessWidget {
  const _HomeSectionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Récent',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Tout voir'),
        ),
      ],
    );
  }
}

class _HomeCardTile extends StatelessWidget {
  const _HomeCardTile({
    required this.card,
    required this.entry,
    required this.index,
  });

  final _HomeCard card;
  final AnimationController entry;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: entry,
      builder: (context, child) {
        final delayed = ((entry.value * 2) - (index * 0.06)).clamp(0.0, 1.0);
        return Opacity(
          opacity: delayed,
          child: Transform.translate(
            offset: Offset(0, (1 - delayed) * 10),
            child: child,
          ),
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: Constants.softShadow,
          border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [card.accent, card.accent.withValues(alpha: 0.7)],
                  ),
                ),
                child: const Icon(
                  Icons.credit_card_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      card.subtitle,
                      style: TextStyle(
                        fontSize: 10,
                        color:
                            Theme.of(context).textTheme.displaySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.black26,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeCard {
  const _HomeCard({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.accent,
  });

  final int id;
  final String title;
  final String subtitle;
  final Color accent;
}
