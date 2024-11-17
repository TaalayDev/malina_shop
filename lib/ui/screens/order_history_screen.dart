import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../config/assets.dart';
import '../widgets.dart';

enum OrderStatus {
  completed,
  cancelled,
  inProgress,
  processing;

  String get label {
    switch (this) {
      case OrderStatus.completed:
        return 'Выполнен';
      case OrderStatus.cancelled:
        return 'Отменён';
      case OrderStatus.inProgress:
        return 'В пути';
      case OrderStatus.processing:
        return 'Готовится';
    }
  }

  Color getColor(BuildContext context) {
    switch (this) {
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.inProgress:
        return Theme.of(context).colorScheme.primary;
      case OrderStatus.processing:
        return Colors.orange;
    }
  }
}

class Order {
  final String id;
  final DateTime date;
  final String storeName;
  final OrderStatus status;
  final List<OrderItem> items;
  final double totalAmount;
  final String? comment;
  final String address;
  final PaymentMethod paymentMethod;
  final OrderType type;

  const Order({
    required this.id,
    required this.date,
    required this.storeName,
    required this.status,
    required this.items,
    required this.totalAmount,
    this.comment,
    required this.address,
    required this.paymentMethod,
    required this.type,
  });
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;
  final String image;

  const OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.image,
  });
}

enum PaymentMethod {
  card,
  cash;

  String get label {
    switch (this) {
      case PaymentMethod.card:
        return 'Картой';
      case PaymentMethod.cash:
        return 'Наличными';
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.cash:
        return Icons.payments_outlined;
    }
  }
}

enum OrderType {
  food,
  product;

  String get label {
    switch (this) {
      case OrderType.food:
        return 'Еда';
      case OrderType.product:
        return 'Товары';
    }
  }

  AppIcons get icon {
    switch (this) {
      case OrderType.food:
        return AppIcons.food;
      case OrderType.product:
        return AppIcons.cosmetic;
    }
  }
}

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final List<Order> _mockOrders = [
    Order(
      id: '#123456',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      storeName: 'Bellagio Coffee',
      status: OrderStatus.completed,
      items: [
        OrderItem(
          name: 'Том ям',
          quantity: 1,
          price: 2500,
          image: Assets.images.pizza1,
        ),
      ],
      totalAmount: 2500,
      address: 'ул. Абая 150',
      paymentMethod: PaymentMethod.card,
      type: OrderType.food,
    ),
    Order(
      id: '#123455',
      date: DateTime.now().subtract(const Duration(days: 1)),
      storeName: 'Hadat Cosmetics',
      status: OrderStatus.cancelled,
      items: [
        OrderItem(
          name: 'Шампунь восстанавливающий',
          quantity: 1,
          price: 1900,
          image: Assets.images.cosmetic1,
        ),
        OrderItem(
          name: 'Увлажняющий кондиционер',
          quantity: 1,
          price: 2000,
          image: Assets.images.cosmetic2,
        ),
      ],
      totalAmount: 3900,
      address: 'ул. Абая 150',
      paymentMethod: PaymentMethod.cash,
      type: OrderType.product,
      comment: 'Отменено клиентом',
    ),
  ];

  OrderType? _selectedType;
  OrderStatus? _selectedStatus;
  final _scrollController = ScrollController();

  List<Order> get _filteredOrders {
    return _mockOrders.where((order) {
      if (_selectedType != null && order.type != _selectedType) {
        return false;
      }
      if (_selectedStatus != null && order.status != _selectedStatus) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.white,
              title: Text(
                'История заказов',
                style: GoogleFonts.sourceCodePro(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(58),
                child: _buildFilters(),
              ),
            ),
          ];
        },
        body: _filteredOrders.isEmpty
            ? _buildEmptyState()
            : AnimationLimiter(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = _filteredOrders[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 600),
                      child: SlideAnimation(
                        verticalOffset: 50,
                        child: FadeInAnimation(
                          child: Hero(
                            tag: 'order_${order.id}',
                            child: _OrderCard(
                              order: order,
                              onTap: () => _showOrderDetails(order),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _FilterChip(
            label: 'Все',
            icon: Icons.all_inclusive,
            isSelected: _selectedType == null && _selectedStatus == null,
            onTap: () => setState(() {
              _selectedType = null;
              _selectedStatus = null;
            }),
          ),
          ...OrderType.values.map((type) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _FilterChip(
                  label: type.label,
                  icon: type == OrderType.food
                      ? Icons.restaurant
                      : Icons.shopping_bag,
                  isSelected: _selectedType == type,
                  onTap: () => setState(() {
                    _selectedType = type;
                    _selectedStatus = null;
                  }),
                ),
              )),
          ...OrderStatus.values.map((status) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _FilterChip(
                  label: status.label,
                  icon: _getStatusIcon(status),
                  isSelected: _selectedStatus == status,
                  onTap: () => setState(() {
                    _selectedStatus = status;
                    _selectedType = null;
                  }),
                ),
              )),
        ].animate(interval: 100.ms).fadeIn().slideX(begin: 0.2, end: 0),
      ),
    );
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.completed:
        return Icons.check_circle_outline;
      case OrderStatus.cancelled:
        return Icons.cancel_outlined;
      case OrderStatus.inProgress:
        return Icons.delivery_dining;
      case OrderStatus.processing:
        return Icons.hourglass_empty;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Нет заказов',
            style: GoogleFonts.sourceCodePro(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          if (_selectedType != null || _selectedStatus != null) ...[
            const SizedBox(height: 12),
            Text(
              'Попробуйте изменить фильтры',
              style: GoogleFonts.sourceCodePro(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () => setState(() {
                _selectedType = null;
                _selectedStatus = null;
              }),
              icon: const Icon(Icons.filter_alt_off),
              label: const Text('Сбросить фильтры'),
            ),
          ],
        ],
      ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),
    );
  }

  void _showOrderDetails(Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _OrderDetailsSheet(order: order),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.white,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[300]!,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const _OrderCard({
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AppIcon(
                      order.type.icon,
                      size: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.storeName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          DateFormat('dd MMMM, HH:mm').format(order.date),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: order.status.getColor(context).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(order.status),
                          size: 16,
                          color: order.status.getColor(context),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          order.status.label,
                          style: TextStyle(
                            color: order.status.getColor(context),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (order.items.isNotEmpty) ...[
                const SizedBox(height: 16),
                SizedBox(
                  height: 64,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: order.items.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final item = order.items[index];
                      return _OrderItemPreview(item: item);
                    },
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        order.paymentMethod.icon,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        order.paymentMethod.label,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${order.totalAmount.toStringAsFixed(0)} ₸',
                    style: GoogleFonts.sourceCodePro(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.completed:
        return Icons.check_circle_outline;
      case OrderStatus.cancelled:
        return Icons.cancel_outlined;
      case OrderStatus.inProgress:
        return Icons.delivery_dining;
      case OrderStatus.processing:
        return Icons.hourglass_empty;
    }
  }
}

class _OrderItemPreview extends StatelessWidget {
  final OrderItem item;

  const _OrderItemPreview({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              item.image,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
          if (item.quantity > 1)
            Positioned(
              right: 4,
              bottom: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '×${item.quantity}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OrderDetailsSheet extends StatelessWidget {
  final Order order;

  const _OrderDetailsSheet({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Заказ ${order.id}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: order.status.getColor(context).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        order.status.label,
                        style: TextStyle(
                          color: order.status.getColor(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Детали заказа',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _DetailItem(
                  icon: order.type.icon,
                  title: order.storeName,
                  subtitle: order.type.label,
                ),
                _DetailItem(
                  icon: AppIcons.mobile_scan,
                  title: DateFormat('dd MMMM yyyy, HH:mm').format(order.date),
                  subtitle: 'Дата и время заказа',
                ),
                _DetailItem(
                  icon: AppIcons.person,
                  iconData: Icons.location_on_outlined,
                  title: order.address,
                  subtitle: 'Адрес доставки',
                ),
                _DetailItem(
                  iconData: order.paymentMethod.icon,
                  title: order.paymentMethod.label,
                  subtitle: 'Способ оплаты',
                ),
                if (order.comment != null)
                  _DetailItem(
                    iconData: Icons.comment_outlined,
                    title: order.comment!,
                    subtitle: 'Комментарий',
                  ),
                const SizedBox(height: 24),
                const Text(
                  'Состав заказа',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              item.image,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${item.quantity} × ${item.price.toStringAsFixed(0)} ₸',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${(item.quantity * item.price).toStringAsFixed(0)} ₸',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Итого',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${order.totalAmount.toStringAsFixed(0)} ₸',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (order.status == OrderStatus.completed)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Повторить заказ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                if (order.status == OrderStatus.completed)
                  const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      order.status == OrderStatus.completed
                          ? 'Закрыть'
                          : 'Вернуться к заказам',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final AppIcons? icon;
  final IconData? iconData;
  final String title;
  final String subtitle;

  const _DetailItem({
    this.icon,
    this.iconData,
    required this.title,
    required this.subtitle,
  }) : assert(icon != null || iconData != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: icon != null
                ? AppIcon(
                    icon!,
                    color: Colors.grey[700],
                    size: 20,
                  )
                : Icon(
                    iconData,
                    color: Colors.grey[700],
                    size: 20,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
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
