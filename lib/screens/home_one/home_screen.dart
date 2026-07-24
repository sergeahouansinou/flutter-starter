import 'package:cardifly/config/provider/view/view_state.dart';
import 'package:cardifly/core/models/breed.dart';
import 'package:cardifly/core/viewmodels/breed_list_model.dart';
import 'package:cardifly/ui/components/app_drawer.dart';
import 'package:cardifly/ui/components/app_drawer_icon.dart';
import 'package:cardifly/ui/components/app_empty_state.dart';
import 'package:cardifly/ui/components/app_error_state.dart';
import 'package:cardifly/ui/components/app_list_skeleton.dart';
import 'package:cardifly/ui/components/app_pull_to_refresh.dart';
import 'package:cardifly/ui/components/app_shimmer.dart';
import 'package:cardifly/ui/components/skeleton.dart';
import 'package:cardifly/ui/theme/app_text.dart';
import 'package:cardifly/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Kick off the initial breeds fetch as soon as the first frame settles
    // so the ViewState skeleton renders once, without re-triggering on
    // subsequent rebuilds.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BreedListModel>().initData();
    });
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
        title: const Text('Cardifly · Dog API'),
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
      body: const Column(
        children: [
          _HomeHeader(),
          Expanded(child: _BreedsBody()),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => context.read<BreedListModel>().refresh(),
        tooltip: 'Actualiser',
        child: const Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Body — consumes BreedListModel end-to-end
// ─────────────────────────────────────────────────────────────

class _BreedsBody extends StatelessWidget {
  const _BreedsBody();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<BreedListModel>();

    // Full-screen skeleton while the first page loads.
    if (model.busy && model.list.isEmpty) {
      return const AppListSkeleton();
    }

    // Hard error on the first page — no data to show at all.
    if (model.viewState == ViewState.error && model.list.isEmpty) {
      return AppErrorState(
        message: model.errorMessage ?? 'Impossible de charger les races.',
        onRetry: model.initData,
      );
    }

    // No results returned by the API.
    if (model.viewState == ViewState.empty && model.list.isEmpty) {
      return AppEmptyState(
        title: 'Aucune race',
        message: 'La collection est vide pour le moment.',
        icon: Icons.pets_rounded,
        actionLabel: 'Actualiser',
        onAction: model.refresh,
      );
    }

    return AppPullToRefresh(
      controller: model.refreshController,
      onRefresh: () => model.refresh().then((_) {}),
      onLoadMore: () => model.loadMore().then((_) {}),
      child: CustomScrollView(
        controller: model.refreshController.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            sliver: SliverToBoxAdapter(
              child: _HomeSectionHeader(count: model.list.length),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.separated(
              itemCount: model.list.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) => _BreedTile(
                breed: model.list[index],
                index: index,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: AppLoadMoreFooter(controller: model.refreshController),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 64)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Presentation
// ─────────────────────────────────────────────────────────────

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

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
              Icons.pets_rounded,
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
                  'Bonjour 👋',
                  style: AppTextStyle.caption(color: Colors.white70),
                ),
                const SizedBox(height: 1),
                Text(
                  'Découvrez les races',
                  style: AppTextStyle.h4(color: Colors.white),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.cloud_done_rounded,
            color: Colors.white70,
            size: 16,
          ),
        ],
      ),
    );
  }
}

class _HomeSectionHeader extends StatelessWidget {
  const _HomeSectionHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text('Races chargées', style: AppTextStyle.h4()),
        ),
        Text(
          '$count',
          style: AppTextStyle.caption(color: Constants.appPrimaryColor)
              .copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _BreedTile extends StatelessWidget {
  const _BreedTile({required this.breed, required this.index});

  final Breed breed;
  final int index;

  static const _palette = [
    Constants.appPrimaryColor,
    Color(0xFF00B894),
    Color(0xFFEB6F92),
    Color(0xFF9B5DE5),
    Color(0xFFF15BB5),
    Color(0xFFF9A825),
  ];

  Color get _accent => _palette[index % _palette.length];

  @override
  Widget build(BuildContext context) {
    final subtle = Theme.of(context).textTheme.displaySmall?.color;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: Constants.softShadow,
        border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BreedAvatar(breed: breed, accent: _accent),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            breed.name,
                            style: AppTextStyle.bodyEmphasis(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (breed.hypoallergenic) ...[
                          const SizedBox(width: 6),
                          const _HypoBadge(),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      breed.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.caption(color: subtle),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _InfoChip(
                          icon: Icons.timer_outlined,
                          label: breed.lifeSpanLabel,
                        ),
                        _InfoChip(
                          icon: Icons.monitor_weight_outlined,
                          label: breed.weightLabel,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.black26,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 60×60 rounded image with:
///   * shimmer skeleton while the remote picture loads,
///   * a bundled `assets/dogs` photo when the API ships no image or the URL
///     fails,
///   * gradient + initial letter as a last resort.
class _BreedAvatar extends StatelessWidget {
  const _BreedAvatar({required this.breed, required this.accent});

  final Breed breed;
  final Color accent;

  static const double _size = 60;
  static const double _radius = 12;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      height: _size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: breed.hasRemoteImage ? _remoteImage() : _assetFallback(),
      ),
    );
  }

  Widget _remoteImage() {
    return Image.network(
      breed.imageUrl!,
      fit: BoxFit.cover,
      width: _size,
      height: _size,
      gaplessPlayback: true,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const AppShimmer(child: Skeleton(radius: _radius));
      },
      errorBuilder: (_, _, _) => _assetFallback(),
      frameBuilder: (context, child, frame, wasSyncLoaded) {
        if (wasSyncLoaded || frame != null) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: child,
          );
        }
        return const AppShimmer(child: Skeleton(radius: _radius));
      },
    );
  }

  /// Local picture from `assets/dogs`, deterministic per breed.
  Widget _assetFallback() {
    return Image.asset(
      breed.placeholderAsset,
      fit: BoxFit.cover,
      width: _size,
      height: _size,
      errorBuilder: (_, _, _) => _initialFallback(),
    );
  }

  Widget _initialFallback() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accent, accent.withValues(alpha: 0.7)],
        ),
      ),
      child: Center(
        child: Text(
          breed.initial,
          style: AppTextStyle.h2(color: Colors.white),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 10, color: Colors.black54),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyle.overline(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class _HypoBadge extends StatelessWidget {
  const _HypoBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: Text(
          'Hypo',
          style: AppTextStyle.overline(color: Colors.green.shade700),
        ),
      ),
    );
  }
}
