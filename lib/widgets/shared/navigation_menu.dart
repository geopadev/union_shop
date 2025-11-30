import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/data/navigation_data.dart';
import 'package:union_shop/widgets/shared/dropdown_menu_widget.dart';

/// Navigation menu widget displayed below the header banner
/// Shows horizontal navigation on desktop, integrates with dropdown menus
class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Only show on desktop/tablet
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 768) {
          return const SizedBox.shrink();
        }

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: NavigationData.mainNavigation.map((item) {
                  return _NavigationItem(item: item);
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavigationItem extends StatefulWidget {
  final dynamic item;

  const _NavigationItem({required this.item});

  @override
  State<_NavigationItem> createState() => _NavigationItemState();
}

class _NavigationItemState extends State<_NavigationItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final hasDropdown = widget.item.hasDropdown;

    if (hasDropdown) {
      return DropdownMenuWidget(
        trigger: _buildTrigger(),
        items: widget.item.children,
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: () {
          if (widget.item.route != null) {
            context.go(widget.item.route!);
          }
        },
        child: _buildTrigger(),
      ),
    );
  }

  Widget _buildTrigger() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _isHovering ? const Color(0xFF4d2963) : Colors.black87,
          decoration: _isHovering ? TextDecoration.underline : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.item.title),
            if (widget.item.hasDropdown) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: _isHovering ? const Color(0xFF4d2963) : Colors.black87,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
