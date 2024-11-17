import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../config/assets.dart';
import '../widgets.dart';

class PromoCode {
  final String code;
  final String title;
  final String description;
  final DateTime expiryDate;
  final double discount;
  final bool isUsed;
  final bool isExpired;
  final PromoCodeType type;

  const PromoCode({
    required this.code,
    required this.title,
    required this.description,
    required this.expiryDate,
    required this.discount,
    this.isUsed = false,
    this.isExpired = false,
    required this.type,
  });
}

enum PromoCodeType {
  percentage,
  fixed,
  delivery;

  String getLabel(double value) {
    switch (this) {
      case PromoCodeType.percentage:
        return '-${value.toInt()}%';
      case PromoCodeType.fixed:
        return '-${value.toInt()} ₸';
      case PromoCodeType.delivery:
        return 'Бесплатная\nдоставка';
    }
  }

  Color getColor() {
    switch (this) {
      case PromoCodeType.percentage:
        return Colors.purple;
      case PromoCodeType.fixed:
        return Colors.blue;
      case PromoCodeType.delivery:
        return Colors.green;
    }
  }

  IconData getIcon() {
    switch (this) {
      case PromoCodeType.percentage:
        return Icons.percent;
      case PromoCodeType.fixed:
        return Icons.wallet;
      case PromoCodeType.delivery:
        return Icons.delivery_dining;
    }
  }
}

class PromoCodesScreen extends StatefulWidget {
  const PromoCodesScreen({super.key});

  @override
  State<PromoCodesScreen> createState() => _PromoCodesScreenState();
}

class _PromoCodesScreenState extends State<PromoCodesScreen> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<PromoCode> _activeCodes = [
    PromoCode(
      code: 'WELCOME15',
      title: 'Приветственная скидка',
      description: 'Скидка 15% на первый заказ',
      expiryDate: DateTime.now().add(const Duration(days: 7)),
      discount: 15,
      type: PromoCodeType.percentage,
    ),
    PromoCode(
      code: 'DELIVERY',
      title: 'Бесплатная доставка',
      description: 'Бесплатная доставка на заказ от 5000 ₸',
      expiryDate: DateTime.now().add(const Duration(days: 3)),
      discount: 0,
      type: PromoCodeType.delivery,
    ),
  ];

  final List<PromoCode> _usedCodes = [
    PromoCode(
      code: 'SUMMER500',
      title: 'Летняя скидка',
      description: 'Скидка 500 ₸ на заказ',
      expiryDate: DateTime.now().subtract(const Duration(days: 1)),
      discount: 500,
      isUsed: true,
      isExpired: true,
      type: PromoCodeType.fixed,
    ),
  ];

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Промокоды',
          style: GoogleFonts.sourceCodePro(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildPromoCodeInput(),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),
          const SizedBox(height: 32),
          if (_activeCodes.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Активные промокоды',
                style: GoogleFonts.sourceCodePro(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 16),
            _buildActiveCodesList(),
            const SizedBox(height: 32),
          ],
          if (_usedCodes.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Использованные промокоды',
                style: GoogleFonts.sourceCodePro(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 16),
            _buildUsedCodesList(),
          ],
        ],
      ),
    );
  }

  Widget _buildPromoCodeInput() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'У вас есть промокод?',
            style: GoogleFonts.sourceCodePro(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _codeController,
            textCapitalization: TextCapitalization.characters,
            style: const TextStyle(letterSpacing: 1.5),
            decoration: InputDecoration(
              hintText: 'Введите промокод',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _applyPromoCode,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите промокод';
              }
              return null;
            },
            onFieldSubmitted: (_) => _applyPromoCode(),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveCodesList() {
    return AnimationLimiter(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _activeCodes.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 600),
            child: SlideAnimation(
              verticalOffset: 50,
              child: FadeInAnimation(
                child: _PromoCodeCard(
                  promoCode: _activeCodes[index],
                  onTap: () => _showPromoCodeDetails(_activeCodes[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUsedCodesList() {
    return AnimationLimiter(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _usedCodes.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 600),
            child: SlideAnimation(
              verticalOffset: 50,
              child: FadeInAnimation(
                child: _PromoCodeCard(
                  promoCode: _usedCodes[index],
                  onTap: () => _showPromoCodeDetails(_usedCodes[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _applyPromoCode() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      // Add your promo code validation logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Промокод ${_codeController.text} применен',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      _codeController.clear();
    }
  }

  void _showPromoCodeDetails(PromoCode promoCode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _PromoCodeDetailsSheet(promoCode: promoCode),
    );
  }
}

class _PromoCodeCard extends StatelessWidget {
  final PromoCode promoCode;
  final VoidCallback onTap;

  const _PromoCodeCard({
    required this.promoCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: promoCode.type
                        .getColor()
                        .withOpacity(promoCode.isUsed ? 0.1 : 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    promoCode.type.getIcon(),
                    color: promoCode.type.getColor().withOpacity(
                          promoCode.isUsed ? 0.5 : 1,
                        ),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        promoCode.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:
                              promoCode.isUsed ? Colors.grey : Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        promoCode.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildExpiryBadge(context),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  promoCode.type.getLabel(promoCode.discount),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: promoCode.type
                        .getColor()
                        .withOpacity(promoCode.isUsed ? 0.5 : 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpiryBadge(BuildContext context) {
    if (promoCode.isUsed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Text(
          'Использован',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      );
    }

    final daysLeft = promoCode.expiryDate.difference(DateTime.now()).inDays;
    final isUrgent = daysLeft <= 3;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isUrgent ? Colors.red[50] : Colors.green[50],
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        'Действует еще $daysLeft ${_pluralizeDays(daysLeft)}',
        style: TextStyle(
          fontSize: 12,
          color: isUrgent ? Colors.red : Colors.green,
        ),
      ),
    );
  }

  String _pluralizeDays(int days) {
    if (days == 1) return 'день';
    if (days >= 2 && days <= 4) return 'дня';
    return 'дней';
  }
}

class _PromoCodeDetailsSheet extends StatelessWidget {
  final PromoCode promoCode;

  const _PromoCodeDetailsSheet({required this.promoCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: promoCode.type.getColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  promoCode.type.getIcon(),
                  color: promoCode.type.getColor(),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  promoCode.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _DetailItem(
            title: 'Промокод',
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    promoCode.code,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () {
                      // Copy to clipboard logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Промокод скопирован'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    tooltip: 'Копировать',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _DetailItem(
            title: 'Описание',
            child: Text(
              promoCode.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _DetailItem(
            title: 'Условия',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ConditionItem(
                  icon: Icons.check_circle_outline,
                  text: _getDiscountText(),
                ),
                if (promoCode.type == PromoCodeType.delivery)
                  const _ConditionItem(
                    icon: Icons.check_circle_outline,
                    text: 'Минимальная сумма заказа 5000 ₸',
                  ),
                const _ConditionItem(
                  icon: Icons.check_circle_outline,
                  text: 'Не суммируется с другими акциями',
                ),
                const _ConditionItem(
                  icon: Icons.check_circle_outline,
                  text: 'Одноразовое использование',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _DetailItem(
            title: 'Срок действия',
            child: Row(
              children: [
                Icon(
                  Icons.event_outlined,
                  size: 20,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'до ${_formatDate(promoCode.expiryDate)}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (!promoCode.isUsed)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Применить',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ).animate().slideY(
            begin: 0.2,
            end: 0,
            duration: 400.ms,
            curve: Curves.easeOutCubic,
          ),
    );
  }

  String _getDiscountText() {
    switch (promoCode.type) {
      case PromoCodeType.percentage:
        return 'Скидка ${promoCode.discount.toInt()}% на заказ';
      case PromoCodeType.fixed:
        return 'Скидка ${promoCode.discount.toInt()} ₸ на заказ';
      case PromoCodeType.delivery:
        return 'Бесплатная доставка';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}

class _DetailItem extends StatelessWidget {
  final String title;
  final Widget child;

  const _DetailItem({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _ConditionItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ConditionItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Add a floating animation effect to promo cards
extension PromoCardAnimations on Widget {
  Widget addFloatingEffect() {
    return MouseRegion(
      child: this
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.1))
          .moveY(
            begin: 0,
            end: -2,
            duration: 2000.ms,
            curve: Curves.easeInOut,
          ),
    );
  }
}
