import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate to AuthGate which will show MainScreen for authenticated users
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/auth');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? 'Login failed.')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _goToRegister() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF13ec5b);
    const backgroundLight = Color(0xFFffffff);
    const textColor = Color(0xFF0d1b12);

    return Scaffold(
      backgroundColor: backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.chevron_left, color: textColor),
                    style: IconButton.styleFrom(
                      backgroundColor: primaryColor.withOpacity(0.1),
                    ),
                  ),
                  Text(
                    'LOGIN',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: textColor.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(width: 48), // Spacer
                ],
              ),
              const SizedBox(height: 32),

              // Hero / Branding
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.filter_center_focus,
                  color: primaryColor,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Fuel Your Day',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Scan, analyze, and track your nutrition effortlessly.',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  color: textColor.withOpacity(0.6),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Form
              _buildTextField(
                label: 'EMAIL ADDRESS',
                icon: Icons.alternate_email,
                controller: _emailController,
                primaryColor: primaryColor,
                textColor: textColor,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'PASSWORD',
                icon: Icons.lock_open,
                controller: _passwordController,
                primaryColor: primaryColor,
                textColor: textColor,
                isPassword: true,
                obscureText: _obscurePassword,
                onToggleVisibility: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {}, // TODO: Implement Forgot Password
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: textColor,
                    elevation: 0,
                    shadowColor: primaryColor.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(textColor),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign In',
                              style: GoogleFonts.manrope(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 32), // Spacer
              // Footer
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: textColor.withOpacity(0.1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR CONTINUE WITH',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textColor.withOpacity(0.4),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: textColor.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () {
                  // TODO: Implement Google Sign In
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black.withOpacity(0.05)),
                  ),
                  child: Center(
                    // Google Icon SVG representation or generic icon
                    child: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/768px-Google_%22G%22_logo.svg.png',
                      width: 24,
                      height: 24,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.g_mobiledata,
                        size: 32,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New here?',
                    style: GoogleFonts.manrope(
                      color: textColor.withOpacity(0.6),
                    ),
                  ),
                  TextButton(
                    onPressed: _goToRegister,
                    child: Text(
                      'Create an account.',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required Color primaryColor,
    required Color textColor,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: textColor.withOpacity(0.8),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.03),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: GoogleFonts.manrope(
              fontSize: 16,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: textColor.withOpacity(0.4),
                size: 20,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility : Icons.visibility_off,
                        color: textColor.withOpacity(0.4),
                        size: 20,
                      ),
                      onPressed: onToggleVisibility,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              hintText: isPassword
                  ? '••••••••'
                  : label.contains('EMAIL')
                  ? 'hello@example.com'
                  : '',
              hintStyle: TextStyle(color: textColor.withOpacity(0.3)),
            ),
          ),
        ),
      ],
    );
  }
}
