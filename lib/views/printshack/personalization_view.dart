import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/personalization_form.dart';
import 'package:union_shop/models/personalization_option.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/view_models/cart_view_model.dart';
import 'package:union_shop/widgets/shared/mobile_navigation_drawer.dart';
import 'package:union_shop/widgets/shared/shared_header.dart';
import 'package:union_shop/widgets/shared/shared_footer.dart';

class PersonalizationPage extends StatefulWidget {
  const PersonalizationPage({super.key});

  @override
  State<PersonalizationPage> createState() => _PersonalizationPageState();
}

class _PersonalizationPageState extends State<PersonalizationPage> {
  late PersonalizationForm _form;

  @override
  void initState() {
    super.initState();
    _form = PersonalizationForm.createDefault();
  }

  void navigateToHome(BuildContext context) {
    context.go('/');
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  void _updateOption(String id, String value) {
    setState(() {
      _form.updateOption(id, value);
    });
  }

  Future<void> _addToCart(BuildContext context) async {
    if (!_form.isComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields before adding to cart'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create personalized product
    final textOption = _form.getOption('text');
    final sizeOption = _form.getOption('size');
    final personalizedProduct = Product(
      id: 'personalized_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Personalized: ${textOption?.value ?? "Custom Text"}',
      price: _form.formattedPrice,
      imageUrl:
          'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
      description: _form.getPreviewText(),
    );

    // Build selected options map
    final selectedOptions = <String, String>{};
    for (var option in _form.options) {
      selectedOptions[option.label] = option.value;
    }

    final cartViewModel = context.read<CartViewModel>();
    await cartViewModel.addToCart(
      personalizedProduct,
      1,
      selectedOptions: selectedOptions,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Personalized item added to cart!'),
          backgroundColor: Color(0xFF4d2963),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('personalization_page'),
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
                        'Personalize Your Item',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4d2963),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Customize your text and see a live preview',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Preview Section
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.visibility,
                                  color: Color(0xFF4d2963),
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Live Preview',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4d2963),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _form.getPreviewText(),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Form Section
                      const Text(
                        'Customization Options',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Render each option
                      ..._form.options.map((option) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _buildOptionWidget(option),
                        );
                      }).toList(),

                      const SizedBox(height: 16),

                      // Price Display
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4d2963).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF4d2963).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Price:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              _form.formattedPrice,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4d2963),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Add to Cart Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          key: const Key('add_personalized_to_cart'),
                          onPressed: () => _addToCart(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4d2963),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'ADD TO CART',
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

  Widget _buildOptionWidget(PersonalizationOption option) {
    switch (option.type) {
      case PersonalizationOptionType.text:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              option.label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              key: Key('personalization_text_input'),
              decoration: InputDecoration(
                hintText: 'Enter your text here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              maxLength: 20,
              onChanged: (value) => _updateOption(option.id, value),
            ),
          ],
        );

      case PersonalizationOptionType.dropdown:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              option.label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              hint: Text('Select ${option.label}'),
              value: option.value.isEmpty ? null : option.value,
              items: option.options?.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  _updateOption(option.id, value);
                }
              },
            ),
          ],
        );

      case PersonalizationOptionType.color:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              option.label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              hint: const Text('Select Color'),
              value: option.value.isEmpty ? null : option.value,
              items: option.options?.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  _updateOption(option.id, value);
                }
              },
            ),
          ],
        );
    }
  }
}
