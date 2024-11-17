import 'package:flutter/material.dart';

import '../widgets.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'qr_scan_screen.dart';
import 'cart_screen.dart';

enum MainNavScreenKey {
  home,
  favorites,
  qrScan,
  profile,
  cart,
}

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({
    super.key,
    this.initialScreen = MainNavScreenKey.home,
  });

  final MainNavScreenKey initialScreen;

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();

  static _MainNavScreenState of(BuildContext context) {
    return context.findAncestorStateOfType<_MainNavScreenState>()!;
  }
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _selectedIndex = 0;
  CartType _cartType = CartType.food;
  late final PageController _pageController;

  Map<MainNavScreenKey, Widget> _getScreens(BuildContext context) => {
        MainNavScreenKey.home: const HomeScreen(),
        MainNavScreenKey.favorites: const FavoritesScreen(),
        MainNavScreenKey.qrScan: const QrScanScreen(),
        MainNavScreenKey.profile: const ProfileScreen(),
        MainNavScreenKey.cart: CartScreen(type: _cartType),
      };

  @override
  void initState() {
    _pageController = PageController();
    _selectedIndex = _indexOf(widget.initialScreen);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigateTo(widget.initialScreen);
    });

    super.initState();
  }

  int _indexOf(MainNavScreenKey key) {
    return _getScreens(context)
        .entries
        .toList()
        .indexWhere((element) => element.key == key);
  }

  void navigateTo(MainNavScreenKey key) {
    final index = _indexOf(key);
    _onPageChanged(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == _indexOf(MainNavScreenKey.qrScan)) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const QrScanScreen(),
        ),
      );
      return;
    }

    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = _getScreens(context);

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: screens.values.toList(),
      ),
      bottomNavigationBar: _BottomNavBar(
        onSelected: navigateTo,
        onCartSelected: (type) {
          setState(() {
            _cartType = type;
            navigateTo(MainNavScreenKey.cart);
          });
        },
        selectedScreen: screens.keys.toList()[_selectedIndex],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    super.key,
    required this.onSelected,
    required this.selectedScreen,
    this.onCartSelected,
  });

  final Function(CartType)? onCartSelected;
  final Function(MainNavScreenKey) onSelected;
  final MainNavScreenKey selectedScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavBarItem(
                icon: AppIcons.feed,
                label: 'Лента',
                isSelected: selectedScreen == MainNavScreenKey.home,
                onTap: () => onSelected(MainNavScreenKey.home),
              ),
              _NavBarItem(
                icon: AppIcons.heart,
                label: 'Избранное',
                isSelected: selectedScreen == MainNavScreenKey.favorites,
                onTap: () => onSelected(MainNavScreenKey.favorites),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onSelected(MainNavScreenKey.qrScan),
                    borderRadius: BorderRadius.circular(50),
                    child: const AppIcon(
                      AppIcons.grid_4x4,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
              _NavBarItem(
                icon: AppIcons.person,
                label: 'Профиль',
                isSelected: selectedScreen == MainNavScreenKey.profile,
                onTap: () => onSelected(MainNavScreenKey.profile),
              ),
              _CartMenuItem(
                isSelected: selectedScreen == MainNavScreenKey.cart,
                onSelected: onCartSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartMenuItem extends StatefulWidget {
  const _CartMenuItem({
    super.key,
    this.isSelected = false,
    this.onSelected,
  });

  final bool isSelected;
  final Function(CartType)? onSelected;

  @override
  State<_CartMenuItem> createState() => _CartMenuItemState();
}

class _CartMenuItemState extends State<_CartMenuItem> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return CustomizedDropdownMenu(
      isOpen: _isOpen,
      direction: CustomizedPopupMenuDirection.top,
      menuWidth: 98,
      onClosed: () {
        setState(() {
          _isOpen = false;
        });
      },
      menuBuilder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CartPopupMenuItem(
                icon: AppIcons.food,
                label: 'Еда',
                onTap: () {
                  widget.onSelected?.call(CartType.food);
                  setState(() {
                    _isOpen = false;
                  });
                },
              ),
              const SizedBox(height: 8),
              _CartPopupMenuItem(
                icon: AppIcons.cosmetic,
                label: 'Товары',
                onTap: () {
                  widget.onSelected?.call(CartType.product);
                  setState(() {
                    _isOpen = false;
                  });
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
      child: _NavBarItem(
        icon: AppIcons.cart,
        label: 'Корзина',
        isSelected: widget.isSelected,
        onTap: () {
          setState(() {
            _isOpen = !_isOpen;
          });
        },
      ),
    );
  }
}

class _CartPopupMenuItem extends StatelessWidget {
  const _CartPopupMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  final AppIcons icon;
  final String label;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F6),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon(
                    icon,
                    color: Colors.black,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final AppIcons icon;
  final String label;
  final bool isSelected;
  final Color? backgroundColor;
  final Color? iconColor;
  final Function()? onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.backgroundColor,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: AppIcon(
              icon,
              color: iconColor ??
                  (isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey),
              size: 30,
            ),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
