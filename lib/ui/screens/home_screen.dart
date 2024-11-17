import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/assets.dart';
import '../widgets.dart';
import 'qr_scan_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Search Bar
                  _SearchBar()
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideX(begin: -0.2, end: 0),

                  const SizedBox(height: 16),

                  // QR Code Banner
                  _QRBanner()
                      .animate()
                      .fadeIn(delay: 200.ms)
                      .slideX(begin: 0.2, end: 0),

                  const SizedBox(height: 16),

                  // Food Category
                  _CategoryCard(
                    title: 'Еда',
                    subtitle: 'Из кафе и \nресторанов',
                    color: const Color(0xFFFFDF94),
                    image: Assets.images.foodBg,
                  ).animate().fadeIn(delay: 400.ms).scale(delay: 400.ms),

                  const SizedBox(height: 16),

                  // Beauty Category
                  _CategoryCard(
                    title: 'Бьюти',
                    subtitle: 'Салоны красоты\nи товары',
                    color: const Color(0xFFFFE8E8),
                    image: Assets.images.flowersBg,
                  ).animate().fadeIn(delay: 600.ms).scale(delay: 600.ms),

                  const SizedBox(height: 24),

                  // Coming Soon Section
                  const Text(
                    'Скоро в Malina',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ).animate().fadeIn(delay: 800.ms),

                  const SizedBox(height: 8),

                  // Quick Access Grid
                  _QuickAccessGrid().animate().fadeIn(delay: 1000.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          const AppIcon(
            AppIcons.search,
            color: Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Искать в Malina',
                hintStyle: TextStyle(
                  color: Colors.grey.withOpacity(0.8),
                  fontSize: 16,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QRBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const QrScanScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const AppIcon(
                  AppIcons.mobile_scan,
                  color: Colors.white,
                  size: 60,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Сканируй QR-код и заказывай\nпрямо в заведении',
                    style: GoogleFonts.sourceCodePro(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final String image;

  const _CategoryCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      constraints: const BoxConstraints(
        minHeight: 170,
        maxWidth: 400,
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(right: Radius.circular(12)),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAccessGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      ('Вакансии', Colors.blue[50]!),
      ('Маркет', Colors.orange[50]!),
      ('Цветы', Colors.pink[50]!),
      ('Товары', Colors.green[50]!),
      ('Скидки', Colors.purple[50]!),
    ];

    return SizedBox(
      height: 120,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: items
            .map((item) => Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: item.$2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(right: 16),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      item.$1,
                      style: GoogleFonts.sourceCodePro(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
