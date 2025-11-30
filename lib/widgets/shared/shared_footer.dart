import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/data/footer_data.dart';

class SharedFooter extends StatelessWidget {
  final Widget? additionalContent;

  const SharedFooter({
    super.key,
    this.additionalContent,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Page footer with navigation links and information',
      container: true,
      child: Container(
        key: const Key('footer_main'),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          border: Border(
            top: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
        ),
        child: Column(
          children: [
            if (additionalContent != null) ...[
              additionalContent!,
              const SizedBox(height: 24),
            ],

            // Main footer content
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 768;

                if (isDesktop) {
                  return _buildDesktopLayout();
                } else {
                  return _buildMobileLayout();
                }
              },
            ),

            // Divider
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Divider(color: Colors.grey[400], height: 1),
            ),

            // Bottom section
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildShopSection()),
              const SizedBox(width: 40),
              Expanded(child: _buildHelpSection()),
              const SizedBox(width: 40),
              Expanded(child: _buildAboutSection()),
              const SizedBox(width: 40),
              Expanded(child: _buildSocialSection()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShopSection(),
          const SizedBox(height: 32),
          _buildHelpSection(),
          const SizedBox(height: 32),
          _buildAboutSection(),
          const SizedBox(height: 32),
          _buildSocialSection(),
        ],
      ),
    );
  }

  Widget _buildShopSection() {
    return Column(
      key: const Key('footer_shop'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SHOP',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        ...FooterData.shopLinks.map((link) => _buildFooterLink(link)),
      ],
    );
  }

  Widget _buildHelpSection() {
    return Column(
      key: const Key('footer_help'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'HELP',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        ...FooterData.helpLinks.map((link) => _buildFooterLink(link)),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      key: const Key('footer_about'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ABOUT',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        ...FooterData.aboutLinks.map((link) => _buildFooterLink(link)),
      ],
    );
  }

  Widget _buildSocialSection() {
    return Column(
      key: const Key('footer_social'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'FOLLOW US',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: FooterData.socialLinks.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _buildSocialIcon(entry.key, entry.value),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const Text(
          FooterData.newsletterTitle,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          FooterData.newsletterDescription,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLink(dynamic link) {
    return _FooterLinkItem(link: link);
  }

  Widget _buildSocialIcon(String platform, String url) {
    IconData icon;
    switch (platform.toLowerCase()) {
      case 'facebook':
        icon = Icons.facebook;
        break;
      case 'instagram':
        icon = Icons.camera_alt;
        break;
      case 'twitter':
        icon = Icons
            .flutter_dash; // Using placeholder, you can add url_launcher package for real links
        break;
      default:
        icon = Icons.link;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFF4d2963),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Center(
        child: Text(
          FooterData.copyright,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _FooterLinkItem extends StatefulWidget {
  final dynamic link;

  const _FooterLinkItem({required this.link});

  @override
  State<_FooterLinkItem> createState() => _FooterLinkItemState();
}

class _FooterLinkItemState extends State<_FooterLinkItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final hasRoute = widget.link.route != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MouseRegion(
        cursor: hasRoute ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: hasRoute ? (_) => setState(() => _isHovering = true) : null,
        onExit: hasRoute ? (_) => setState(() => _isHovering = false) : null,
        child: GestureDetector(
          onTap: hasRoute ? () => context.go(widget.link.route!) : null,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 13,
              color: hasRoute
                  ? (_isHovering
                      ? const Color(0xFF4d2963)
                      : const Color(0xFF4d2963))
                  : Colors.grey[600],
              decoration: _isHovering && hasRoute
                  ? TextDecoration.underline
                  : (hasRoute ? TextDecoration.underline : null),
              height: 1.5,
            ),
            child: Text(widget.link.title),
          ),
        ),
      ),
    );
  }
}
