import 'package:flutter/material.dart';
import 'package:union_shop/models/navigation_item.dart';

/// Dropdown menu widget that displays child navigation items
/// Supports hover behavior on desktop and tap behavior on mobile
class DropdownMenuWidget extends StatefulWidget {
  final NavigationItem item;
  final Widget trigger;

  const DropdownMenuWidget({
    super.key,
    required this.item,
    required this.trigger,
  });

  @override
  State<DropdownMenuWidget> createState() => _DropdownMenuWidgetState();
}

class _DropdownMenuWidgetState extends State<DropdownMenuWidget> {
  bool _isHovering = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() => _isHovering = false);
          _removeOverlay();
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(color: Colors.transparent),
            ),
            Positioned(
              width: 250,
              child: CompositedTransformFollower(
                link: _layerLink,
                targetAnchor: Alignment.bottomLeft,
                followerAnchor: Alignment.topLeft,
                offset: const Offset(0, 4),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: widget.item.children!.map((child) {
                        return _buildMenuItem(child);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildMenuItem(NavigationItem child) {
    return Semantics(
      button: true,
      label: 'Navigate to ${child.title}',
      child: InkWell(
        onTap: () {
          if (child.route != null) {
            Navigator.pushNamed(context, child.route!);
            setState(() => _isHovering = false);
            _removeOverlay();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            child.title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${widget.item.title} menu',
      hint: 'Activate to open dropdown menu',
      child: CompositedTransformTarget(
        link: _layerLink,
        child: MouseRegion(
          onEnter: (_) {
            setState(() => _isHovering = true);
            _showOverlay();
          },
          onExit: (_) {
            setState(() => _isHovering = false);
            _removeOverlay();
          },
          child: GestureDetector(
            onTap: () {
              if (_isHovering) {
                setState(() => _isHovering = false);
                _removeOverlay();
              } else {
                setState(() => _isHovering = true);
                _showOverlay();
              }
            },
            child: widget.trigger,
          ),
        ),
      ),
    );
  }
}
