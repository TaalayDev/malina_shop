import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../config/assets.dart';
import '../widgets.dart';

enum CartType { food, product }

class ProductGroup {
  final String title;
  final List<ProductModel> products;

  ProductGroup({
    required this.title,
    required this.products,
  });
}

class ProductModel {
  final String image;
  final String title;
  final String subtitle;
  final String price;

  ProductModel({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
  });
}

final List<ProductGroup> _products = [
  ProductGroup(
    title: 'Hair',
    products: [
      ProductModel(
        image: Assets.images.cosmetic1,
        title: 'Hadat Cosmetics',
        subtitle:
            'Шампунь интенсивно восстанавливающий Hydro Intensive Repair Shampoo 250 мл',
        price: '1900 ₸',
      ),
      ProductModel(
        image: Assets.images.cosmetic2,
        title: 'Hadat Cosmetics',
        subtitle: 'Увлажняющий кондиционер 150 мл',
        price: '2000 ₸',
      ),
    ],
  ),
  ProductGroup(
    title: 'Preen Beauty',
    products: [
      ProductModel(
        image: Assets.images.cosmetic3,
        title: "L'Oreal Paris Elseve",
        subtitle: 'Шампунь для ослабленных волос',
        price: '600 ₸',
      ),
    ],
  ),
];

final List<ProductGroup> _foodProducts = [
  ProductGroup(
    title: 'Bellagio Coffee',
    products: [
      ProductModel(
        image: Assets.images.pizza1,
        title: 'Том ям',
        subtitle: 'Пицца с соусом том ям 230 гр',
        price: '250 ₸',
      ),
    ],
  ),
];

class CartScreen extends StatelessWidget {
  const CartScreen({
    super.key,
    required this.type,
  });

  final CartType type;

  @override
  Widget build(BuildContext context) {
    final products = type == CartType.food ? _foodProducts : _products;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        centerTitle: false,
        title: const Text(
          'Корзина',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Очистить',
              style: TextStyle(
                color: Color(0xFF1D1D1D),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          if (type == CartType.food) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _DeliveryTabBar()
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: -0.2, end: 0),
            )
          ],
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 24,
                top: 8,
              ),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final storeProducts = products[index].products;
                final total = storeProducts.fold<int>(
                  0,
                  (previousValue, element) =>
                      previousValue + int.parse(element.price.split(' ')[0]),
                );

                return _StoreSection(
                  storeName: products[index].title,
                  items: storeProducts
                      .map(
                        (product) => CartItem(
                          image: product.image,
                          title: product.title,
                          subtitle: product.subtitle,
                          price: product.price,
                        ),
                      )
                      .toList(),
                  onAddExtra: type == CartType.food ? () {} : null,
                  total: '$total ₸',
                ).animate().fadeIn(
                      duration: 400.ms,
                      delay: index == 0 ? 0.ms : 200.ms,
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryTabBar extends StatefulWidget {
  @override
  State<_DeliveryTabBar> createState() => _DeliveryTabBarState();
}

class _DeliveryTabBarState extends State<_DeliveryTabBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              title: 'Доставка',
              isSelected: _selectedIndex == 0,
              onTap: () => setState(() => _selectedIndex = 0),
            ),
          ),
          Expanded(
            child: _TabButton(
              title: 'В заведении',
              isSelected: _selectedIndex == 1,
              onTap: () => setState(() => _selectedIndex = 1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
          borderRadius: BorderRadius.circular(100),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _StoreSection extends StatelessWidget {
  final String storeName;
  final List<CartItem> items;
  final String total;
  final Function()? onAddExtra;

  const _StoreSection({
    required this.storeName,
    required this.items,
    required this.total,
    this.onAddExtra,
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  storeName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          const Divider(height: 1),
          ...items,
          if (onAddExtra != null) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: onAddExtra,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  shadowColor: Colors.transparent,
                  backgroundColor: const Color(0xFFf8f8f8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  children: [
                    AppIcon(
                      AppIcons.plus_circle,
                      size: 30,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Добавки',
                      style: TextStyle(
                        color: Color(0xFF1D1D1D),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Заказать',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    total,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final String price;

  const CartItem({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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
                const Row(
                  children: [
                    _QuantityButton(icon: Icons.remove),
                    SizedBox(width: 16),
                    Text(
                      '1',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 16),
                    _QuantityButton(icon: Icons.add),
                    Spacer(),
                    AppIcon(
                      AppIcons.delete,
                      size: 30,
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

class _QuantityButton extends StatelessWidget {
  final IconData icon;

  const _QuantityButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFF8F8F8),
      ),
      child: Icon(icon, size: 16, color: Colors.grey[600]),
    );
  }
}
