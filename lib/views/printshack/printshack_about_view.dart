import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/widgets/shared/mobile_navigation_drawer.dart';
import 'package:union_shop/widgets/shared/shared_header.dart';
import 'package:union_shop/widgets/shared/shared_footer.dart';

class PrintShackAboutPage extends StatelessWidget {
  const PrintShackAboutPage({super.key});

  void navigateToHome(BuildContext context) {
    context.go('/');
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('printshack_about_page'),
      endDrawer: const MobileNavigationDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            SharedHeader(
              onLogoTap: () => navigateToHome(context),
              onSearchTap: placeholderCallbackForButtons,
              onAccountTap: placeholderCallbackForButtons,
              onCartTap: () => context.go('/cart'),
              onMenuTap: placeholderCallbackForButtons,
            ),

            // Page Content
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Page Title
                      const Text(
                        'The Print Shack',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4d2963),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Introduction
                      const Text(
                        'Personalize Your Style',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Welcome to The Print Shack! We offer a unique text personalization service where you can add custom text to your favorite items. Make your purchases truly yours with our easy-to-use personalization options.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // What We Offer
                      const Text(
                        'What We Offer',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4d2963),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureCard(
                        icon: Icons.text_fields,
                        title: 'Custom Text',
                        description:
                            'Add your name, nickname, or any text up to 20 characters to personalize your items.',
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureCard(
                        icon: Icons.font_download,
                        title: 'Multiple Fonts',
                        description:
                            'Choose from a variety of professional fonts including Arial, Times New Roman, and Courier.',
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureCard(
                        icon: Icons.palette,
                        title: 'Color Options',
                        description:
                            'Select from multiple color options to match your style and preferences.',
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureCard(
                        icon: Icons.straighten,
                        title: 'Size Selection',
                        description:
                            'Choose from various sizes (S, M, L, XL) to get the perfect fit for your item.',
                      ),
                      const SizedBox(height: 32),

                      // Pricing Information
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4d2963).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF4d2963).withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.local_offer,
                                  color: Color(0xFF4d2963),
                                  size: 28,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Pricing',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4d2963),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildPricingRow('Small (S)', '£5.00'),
                            _buildPricingRow('Medium (M)', '£7.00'),
                            _buildPricingRow('Large (L)', '£9.00'),
                            _buildPricingRow('Extra Large (XL)', '£11.00'),
                            const SizedBox(height: 12),
                            const Text(
                              '* Prices include text personalization and printing',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Turnaround Time
                      const Text(
                        'Turnaround Time',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4d2963),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.green,
                              size: 32,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'All personalized items are processed within 3-5 business days. Express options available for urgent orders.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Call to Action
                      Center(
                        child: ElevatedButton(
                          onPressed: () =>
                              context.go('/printshack/personalisation'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4d2963),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'START PERSONALIZING',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            const SharedFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 32,
            color: const Color(0xFF4d2963),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingRow(String size, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            size,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4d2963),
            ),
          ),
        ],
      ),
    );
  }
}
