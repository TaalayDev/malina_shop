import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AppIcons {
  cart,
  cosmetic,
  delete,
  feed,
  food,
  grid_4x4,
  heart,
  mobile_scan,
  person,
  search,
  plus_circle,
}

class AppIcon extends StatelessWidget {
  final AppIcons icon;
  final double? size;
  final Color? color;
  final bool originalColor;

  const AppIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.originalColor = false, // const Color(0xff636363),
  });

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? IconTheme.of(context).size ?? 24.0;
    Widget image = SvgPicture.asset(
      'assets/vectors/${icon.name}.svg',
      height: size,
      width: size,
      color: originalColor ? null : color ?? IconTheme.of(context).color,
    );

    return SizedBox(
      height: size,
      width: size,
      child: Center(child: image),
    );
  }
}
