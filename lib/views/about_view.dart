import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/widgets/shared/shared_header.dart';
import 'package:union_shop/widgets/shared/shared_footer.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  void navigateToHome(BuildContext context) {
    context.go('/');
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('about_page'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            SharedHeader(
              onLogoTap: () => navigateToHome(context),
              onSearchTap: placeholderCallbackForButtons,
              onAccountTap: placeholderCallbackForButtons,
              onCartTap: placeholderCallbackForButtons,
              onMenuTap: placeholderCallbackForButtons,
            ),

            // About Content
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Page Title
                      const Text(
                        'About Us',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Introduction
                      const Text(
                        'Welcome to the University of Portsmouth Students\' Union Shop',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'We are your one-stop destination for all things University of Portsmouth! From exclusive merchandise and clothing to everyday essentials, we provide students with high-quality products that celebrate university life and Portsmouth pride.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.8,
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Two Column Section
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 700) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildMissionCard()),
                                const SizedBox(width: 40),
                                Expanded(child: _buildValuesCard()),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                _buildMissionCard(),
                                const SizedBox(height: 40),
                                _buildValuesCard(),
                              ],
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 48),

                      // Why Choose Us Section
                      Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Why Choose Us?',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4d2963),
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildFeatureRow(
                              Icons.verified,
                              'Quality Products',
                              'We source and create products that meet the highest standards.',
                            ),
                            const SizedBox(height: 24),
                            _buildFeatureRow(
                              Icons.people,
                              'Student Community',
                              'Supporting student life through exclusive collections and events.',
                            ),
                            const SizedBox(height: 24),
                            _buildFeatureRow(
                              Icons.eco,
                              'Sustainability',
                              'Committed to environmentally responsible practices.',
                            ),
                            const SizedBox(height: 24),
                            _buildFeatureRow(
                              Icons.local_offer,
                              'Affordable Pricing',
                              'Quality products at student-friendly prices.',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Contact Section
                      Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4d2963),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Get in Touch',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Have questions or feedback? We\'d love to hear from you!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildContactInfo(
                                Icons.email, 'shop@upsu.net', Colors.white),
                            const SizedBox(height: 12),
                            _buildContactInfo(
                                Icons.phone, '023 9284 3000', Colors.white),
                            const SizedBox(height: 12),
                            _buildContactInfo(
                              Icons.location_on,
                              'Students\' Union, Cambridge Road, Portsmouth, PO1 2EF',
                              Colors.white,
                            ),
                          ],
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

  Widget _buildMissionCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            Icons.flag,
            size: 48,
            color: const Color(0xFF4d2963),
          ),
          const SizedBox(height: 16),
          const Text(
            'Our Mission',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'To provide students with high-quality products that enhance the university experience and celebrate Portsmouth pride.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValuesCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            Icons.favorite,
            size: 48,
            color: const Color(0xFF4d2963),
          ),
          const SizedBox(height: 16),
          const Text(
            'Our Values',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Quality, community, sustainability, and affordability are at the heart of everything we do.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String title, String description) {
    return Row(
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo(IconData icon, String text, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: color,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
