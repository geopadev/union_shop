import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:union_shop/widgets/shared/mobile_navigation_drawer.dart';
import 'package:union_shop/widgets/shared/shared_header.dart';
import 'package:union_shop/widgets/shared/shared_footer.dart';

class EmailAuthPage extends StatefulWidget {
  const EmailAuthPage({super.key});

  @override
  State<EmailAuthPage> createState() => _EmailAuthPageState();
}

class _EmailAuthPageState extends State<EmailAuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;
  String? _verificationError;

  @override
  void initState() {
    super.initState();
    // Check if this is a deep link from email verification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForEmailLink();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// Check if the current URL is an email verification link
  Future<void> _checkForEmailLink() async {
    final authService = context.read<AuthService>();

    // Get the current URL
    final currentUrl = Uri.base.toString();

    // Check if this is a sign-in link
    if (authService.isSignInWithEmailLink(currentUrl)) {
      setState(() => _isLoading = true);

      try {
        // Get the stored email from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final email = prefs.getString('emailForSignIn');

        if (email == null) {
          // Email not found - ask user to enter it again
          setState(() {
            _isLoading = false;
            _verificationError =
                'Please enter your email address to complete sign-in';
          });
          return;
        }

        // Complete the sign-in with the email link
        await authService.signInWithEmailLink(
          email: email,
          link: currentUrl,
        );

        // Clear the stored email
        await prefs.remove('emailForSignIn');

        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully signed in!'),
              backgroundColor: Color(0xFF4d2963),
              duration: Duration(seconds: 2),
            ),
          );

          // Navigate to account dashboard
          context.go('/account');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          _verificationError = e.toString();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  void _navigateToHome(BuildContext context) {
    context.go('/');
  }

  void _placeholderCallback() {
    // Placeholder for buttons that don't work yet
  }

  Future<void> _sendSignInLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = context.read<AuthService>();
      final email = _emailController.text.trim();

      // Store email in SharedPreferences for verification later
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('emailForSignIn', email);

      // Send sign-in link to email
      await authService.sendSignInLinkToEmail(email: email);

      setState(() {
        _emailSent = true;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification email sent to $email'),
            backgroundColor: const Color(0xFF4d2963),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _verifyEmailManually() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = context.read<AuthService>();
      final email = _emailController.text.trim();
      final currentUrl = Uri.base.toString();

      // Complete the sign-in with the email link
      await authService.signInWithEmailLink(
        email: email,
        link: currentUrl,
      );

      // Clear the stored email
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('emailForSignIn');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully signed in!'),
            backgroundColor: Color(0xFF4d2963),
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to account dashboard
        context.go('/account');
      }
    } catch (e) {
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('email_auth_page'),
      endDrawer: const MobileNavigationDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            SharedHeader(
              onLogoTap: () => _navigateToHome(context),
              onSearchTap: _placeholderCallback,
              onAccountTap: _placeholderCallback,
              onCartTap: () => context.go('/cart'),
              onMenuTap: _placeholderCallback,
            ),

            // Email Auth Form
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),

                      // Page Title
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4d2963),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),

                      // Description or Error Message
                      if (_verificationError != null) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                size: 48,
                                color: Colors.orange,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _verificationError!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.orange,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ] else
                        Text(
                          _emailSent
                              ? 'Check your email for the verification link'
                              : 'Enter your email address to receive a sign-in link',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),

                      const SizedBox(height: 40),

                      if (!_emailSent || _verificationError != null) ...[
                        // Email Form
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Email Input
                              TextFormField(
                                key: const Key('email_input'),
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Email Address',
                                  hintText: 'your.email@example.com',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  prefixIcon: const Icon(Icons.email_outlined),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your email address';
                                  }
                                  // Basic email validation
                                  final emailRegex = RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                  );
                                  if (!emailRegex.hasMatch(value.trim())) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 24),

                              // Continue/Verify Button
                              SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  key: const Key('continue_button'),
                                  onPressed: _isLoading
                                      ? null
                                      : (_verificationError != null
                                          ? _verifyEmailManually
                                          : _sendSignInLink),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4d2963),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          _verificationError != null
                                              ? 'VERIFY'
                                              : 'CONTINUE',
                                          style: const TextStyle(
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
                      ] else ...[
                        // Email Sent Confirmation
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.mark_email_read,
                                size: 64,
                                color: Colors.green,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Verification Email Sent!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'We sent a verification link to:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _emailController.text.trim(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Click the link in the email to complete sign in',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Resend Button
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _emailSent = false;
                              _verificationError = null;
                            });
                          },
                          child: const Text('Send to a different email'),
                        ),
                      ],

                      const SizedBox(height: 40),

                      // Info Text
                      Text(
                        'By signing in, you agree to our Terms of Service and Privacy Policy',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 60),
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
}
