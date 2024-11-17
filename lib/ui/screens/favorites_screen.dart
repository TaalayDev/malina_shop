import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../config/assets.dart';
import '../widgets.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _categories = ['Все', 'Еда', 'Бьюти', 'Другое'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    'Избранное',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideX(begin: -0.2, end: 0),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const AppIcon(AppIcons.search),
                  ).animate().fadeIn(delay: 200.ms),
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: _categories
                  .map((category) => Tab(text: category))
                  .toList()
                  .animate(interval: 100.ms)
                  .fadeIn()
                  .slideX(begin: 0.2, end: 0),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _categories.map((category) {
                  return _FavoritesGrid(category: category);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritesGrid extends StatelessWidget {
  final String category;

  const _FavoritesGrid({required this.category});

  List<_FavoriteItem> _getItems() {
    if (category == 'Еда' || category == 'Все') {
      return [
        _FavoriteItem(
          image: Assets.images.pizza1,
          title: 'Том ям',
          subtitle: 'Bellagio Coffee',
          price: '2500 ₸',
          tag: 'Еда',
        ),
      ];
    }
    if (category == 'Бьюти' || category == 'Все') {
      return [
        _FavoriteItem(
          image: Assets.images.cosmetic1,
          title: 'Шампунь восстанавливающий',
          subtitle: 'Hadat Cosmetics',
          price: '1900 ₸',
          tag: 'Бьюти',
        ),
        _FavoriteItem(
          image: Assets.images.cosmetic2,
          title: 'Увлажняющий кондиционер',
          subtitle: 'Hadat Cosmetics',
          price: '2000 ₸',
          tag: 'Бьюти',
        ),
        _FavoriteItem(
          image: Assets.images.cosmetic3,
          title: 'Шампунь для волос',
          subtitle: "L'Oreal Paris",
          price: '600 ₸',
          tag: 'Бьюти',
        ),
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final items = _getItems();

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Нет избранных товаров',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ).animate().fadeIn(duration: 600.ms),
      );
    }

    return AnimationLimiter(
      child: MasonryGridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            columnCount: 2,
            duration: const Duration(milliseconds: 600),
            child: SlideAnimation(
              verticalOffset: 50,
              child: FadeInAnimation(
                child: items[index],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FavoriteItem extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final String price;
  final String tag;

  const _FavoriteItem({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
