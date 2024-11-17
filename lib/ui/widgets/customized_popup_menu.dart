import 'package:flutter/material.dart';

Future<T?> showCustomizedMenu<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color barrierColor = Colors.transparent,
  Offset? position,
  bool barrierDismissible = true,
  double barrierRadius = 0.0,
  String barrierLabel = '',
  Duration transitionDuration = const Duration(milliseconds: 200),
  CustomizedPopupMenuDirection direction = CustomizedPopupMenuDirection.bottom,
  required Size anchorSize,
}) {
  return Navigator.of(context, rootNavigator: true).push<T>(
    CustomizedPopupRoute<T>(
      builder: builder,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierRadius: barrierRadius,
      barrierLabel: barrierLabel,
      transitionDuration: transitionDuration,
      position: position,
      direction: direction,
      anchorSize: anchorSize,
    ),
  );
}

enum CustomizedPopupMenuDirection {
  bottom,
  top,
}

class CustomizedDropdownMenu extends StatefulWidget {
  const CustomizedDropdownMenu({
    super.key,
    this.isOpen = false,
    this.onClosed,
    this.menuWidth,
    required this.menuBuilder,
    this.direction = CustomizedPopupMenuDirection.bottom,
    required this.child,
  });

  final bool isOpen;
  final Function()? onClosed;
  final double? menuWidth;
  final Widget Function(BuildContext context) menuBuilder;
  final CustomizedPopupMenuDirection direction;
  final Widget child;

  @override
  State<CustomizedDropdownMenu> createState() => _CustomzedDropdownMenuState();
}

class _CustomzedDropdownMenuState<T> extends State<CustomizedDropdownMenu> {
  final _key = GlobalKey();

  double _calculatePosition() {
    final RenderBox renderBox =
        _key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final menuHeight = renderBox.size.height;
    final direction = widget.direction;

    if (direction == CustomizedPopupMenuDirection.bottom) {
      return position.dy + renderBox.size.height;
    } else {
      return screenHeight - position.dy - menuHeight;
    }
  }

  void openMenu() async {
    final RenderBox renderBox =
        _key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final menuWidth = widget.menuWidth ?? renderBox.size.width;

    await showCustomizedMenu(
      context: context,
      builder: (context) {
        return SizedBox(
          width: menuWidth,
          child: widget.menuBuilder(context),
        );
      },
      position: Offset(
        position.dx,
        position.dy +
            (widget.direction == CustomizedPopupMenuDirection.bottom
                ? renderBox.size.height
                : 0),
      ),
      direction: widget.direction,
      anchorSize: renderBox.size,
    );
    widget.onClosed?.call();
  }

  @override
  void didUpdateWidget(CustomizedDropdownMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen && !oldWidget.isOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        openMenu();
      });
    } else if (!widget.isOpen && oldWidget.isOpen) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: _key,
      child: widget.child,
    );
  }
}

class CustomizedPopupRoute<T> extends PopupRoute<T> {
  CustomizedPopupRoute({
    required this.builder,
    required this.barrierColor,
    required this.barrierLabel,
    this.barrierDismissible = true,
    this.barrierRadius = 0.0,
    this.transitionDuration = const Duration(milliseconds: 200),
    this.position,
    super.settings,
    this.direction = CustomizedPopupMenuDirection.bottom,
    required this.anchorSize,
  });

  final WidgetBuilder builder;
  final Color barrierColor;
  final bool barrierDismissible;
  final double barrierRadius;
  final String barrierLabel;
  final Duration transitionDuration;
  final Offset? position;
  final CustomizedPopupMenuDirection direction;
  final Size anchorSize;

  @override
  bool get maintainState => false;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return this.builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curveTween = CurveTween(curve: Curves.easeInOut);
    final animationCurve = animation.drive(curveTween);
    final secondaryAnimationCurve = secondaryAnimation.drive(curveTween);

    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: FadeTransition(
        opacity: animationCurve,
        child: CustomSingleChildLayout(
          delegate: _PopupDialogRouteLayout(
            progress: animationCurve,
            secondaryProgress: secondaryAnimationCurve,
            position: position ?? Offset.zero,
            direction: direction,
            anchorSize: anchorSize,
          ),
          child: Material(
            color: Colors.transparent,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _PopupDialogRouteLayout extends SingleChildLayoutDelegate {
  _PopupDialogRouteLayout({
    required this.progress,
    required this.secondaryProgress,
    required this.position,
    required this.direction,
    required this.anchorSize,
  });

  final Offset position;
  final Animation<double> progress;
  final Animation<double> secondaryProgress;
  final CustomizedPopupMenuDirection direction;
  final Size anchorSize;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.loose(constraints.biggest);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double left = position.dx + (anchorSize.width - childSize.width) / 2;

    // Ensure the menu stays within screen bounds horizontally
    left = left.clamp(0.0, size.width - childSize.width);

    double top;
    if (direction == CustomizedPopupMenuDirection.bottom) {
      top = position.dy;
    } else {
      top = position.dy - childSize.height;
    }

    // Ensure the menu stays within screen bounds vertically
    top = top.clamp(0.0, size.height - childSize.height);

    return Offset(left, top);
  }

  @override
  bool shouldRelayout(_PopupDialogRouteLayout oldDelegate) {
    return position != oldDelegate.position ||
        direction != oldDelegate.direction ||
        anchorSize != oldDelegate.anchorSize;
  }
}
