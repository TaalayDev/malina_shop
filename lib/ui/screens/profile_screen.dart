import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app.dart';
import 'about_screen.dart';
import 'auth_screen.dart';
import 'delivery_address_screen.dart';
import 'help_screen.dart';
import 'profile_edit_screen.dart';
import 'reviews_screen.dart';
import 'order_history_screen.dart';
import 'bonus_program_screen.dart';
import 'payment_methods_screen.dart';
import 'promocodes_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Профиль',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideX(begin: -0.2, end: 0),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ProfileEditScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.settings_outlined),
                  ).animate().fadeIn(delay: 200.ms),
                ],
              ),
              const SizedBox(height: 24),
              const _ProfileHeader().animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 24),
              _buildSection(
                title: 'Заказы',
                items: [
                  _MenuItem(
                    icon: Icons.receipt_outlined,
                    title: 'История заказов',
                    showDivider: true,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const OrderHistoryScreen(),
                        ),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.star_outline,
                    title: 'Отзывы',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ReviewsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 24),
              _buildSection(
                title: 'Бонусы и промокоды',
                items: [
                  _MenuItem(
                    icon: Icons.card_giftcard,
                    title: 'Бонусная программа',
                    trailing: const Text('0 ₸'),
                    showDivider: true,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const BonusProgramScreen(),
                        ),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.local_offer_outlined,
                    title: 'Промокоды',
                    trailing: const Text('0'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PromoCodesScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 24),
              _buildSection(
                title: 'Личные данные',
                items: [
                  _MenuItem(
                    icon: Icons.person_outline,
                    title: 'Личная информация',
                    showDivider: true,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ProfileEditScreen(),
                        ),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Адреса доставки',
                    showDivider: true,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const DeliveryAddressScreen(),
                        ),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.payment,
                    title: 'Способы оплаты',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PaymentMethodsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 24),
              _buildSection(
                title: 'Настройки приложения',
                items: [
                  _MenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Уведомления',
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      thumbColor: WidgetStateProperty.all(Colors.white),
                    ),
                    showDivider: true,
                  ),
                  const _MenuItem(
                    icon: Icons.language,
                    title: 'Язык',
                    trailing: Text(
                      'Русский',
                      style: TextStyle(color: Colors.grey),
                    ),
                    showDivider: true,
                  ),
                  _MenuItem(
                    icon: Icons.dark_mode_outlined,
                    title: 'Тёмная тема',
                    trailing: Switch(
                      value: App.appTheme(context).isDark,
                      onChanged: (value) {
                        App.of(context).toggleTheme();
                      },
                      thumbColor: WidgetStateProperty.all(Colors.white),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 24),
              _buildSection(
                title: 'Поддержка',
                items: [
                  _MenuItem(
                    icon: Icons.help_outline,
                    title: 'Помощь',
                    showDivider: true,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HelpScreen(),
                        ),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.info_outline,
                    title: 'О приложении',
                    trailing: const Text('Версия 1.0.0'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AboutScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                label: const Text(
                  'Выйти',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ).animate().fadeIn(delay: 900.ms),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
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
            children: items,
          ),
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 30,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Гость',
                      style: GoogleFonts.sourceCodePro(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Войдите, чтобы получить доступ\nк бонусам и истории заказов',
                      style: GoogleFonts.sourceCodePro(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AuthScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Войти или зарегистрироваться',
                style: TextStyle(
                  fontSize: 16,
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

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final bool showDivider;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.showDivider = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: showDivider
                ? null
                : const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 24,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 8),
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
