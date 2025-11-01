// lib/main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    final lightAccent = const Color(0xFF14B8A6);
    final darkAccent = const Color(0xFFFF6B6B);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modern Landing Page - Flutter',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: lightAccent,
        scaffoldBackgroundColor: const Color(0xFFFEFEFE),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF8F9FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 28,
          ),
          bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: darkAccent,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF0F1724),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF374151)),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 28,
          ),
          bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: LoginScreen(
        onToggleTheme: () => setState(() => isDark = !isDark),
        isDark: isDark,
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;

  const LoginScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDark,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _remember = false;
  bool _isMobileView = true;
  bool _submitted = false;

  // for entrance animation
  late AnimationController _animController;
  late Animation<double> _opacityAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _opacityAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(_animController);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _toggleView() {
    setState(() {
      _isMobileView = !_isMobileView;
    });
  }

  void _tryLogin() {
    setState(() => _submitted = true);
    if (_formKey.currentState?.validate() ?? false) {
      // Demo: show snackbar success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Demo: Fitur masuk berhasil!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green[600],
        ),
      );
    } else {
      // show error briefly
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Periksa kembali input Anda.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String? _emailValidator(String? v) {
    if (v == null || v.isEmpty) {
      return 'Masukkan alamat email.';
    }
    final emailReg = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailReg.hasMatch(v)) return 'Email tidak valid — coba lagi.';
    return null;
  }

  String? _passValidator(String? v) {
    if (v == null || v.isEmpty) return 'Masukkan kata sandi.';
    if (v.length < 8) return 'Kata sandi harus minimal 8 karakter.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final accentColor = Theme.of(context).primaryColor;
    final cardBg = Theme.of(context).inputDecorationTheme.fillColor;
    final textSecondary = isDark
        ? const Color(0xFF9CA3AF)
        : const Color(0xFF6B7280);

    final containerWidth = _isMobileView ? 430.0 : 900.0;
    final horizontalPadding = _isMobileView ? 24.0 : 48.0;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 12),
            child: FadeTransition(
              opacity: _opacityAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: containerWidth,
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 36,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top controls: view toggle + theme toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // view toggle
                          ElevatedButton(
                            onPressed: _toggleView,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: cardBg,
                              foregroundColor: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                            ),
                            child: Text(_isMobileView ? 'Desktop' : 'Mobile'),
                          ),

                          // theme toggle
                          IconButton(
                            onPressed: widget.onToggleTheme,
                            tooltip: 'Toggle theme',
                            icon: Icon(
                              widget.isDark
                                  ? Icons.dark_mode
                                  : Icons.light_mode,
                            ),
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Logo & headings
                      Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  // ignore: deprecated_member_use
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.flash_on,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Selamat Datang',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Bergabunglah dengan komunitas kreatif kami',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: textSecondary),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Email
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              decoration: InputDecoration(
                                hintText: 'Masukan email anda',
                                prefixIcon: const Icon(Icons.email_outlined),
                              ),
                              validator: _emailValidator,
                              autovalidateMode: _submitted
                                  ? AutovalidateMode.always
                                  : AutovalidateMode.disabled,
                            ),

                            const SizedBox(height: 16),

                            // Password
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _passCtrl,
                              obscureText: _obscure,
                              decoration: InputDecoration(
                                hintText: 'Masukkan password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscure
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () =>
                                      setState(() => _obscure = !_obscure),
                                ),
                              ),
                              validator: _passValidator,
                              autovalidateMode: _submitted
                                  ? AutovalidateMode.always
                                  : AutovalidateMode.disabled,
                            ),

                            const SizedBox(height: 12),

                            // Remember & Forgot
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _remember,
                                      onChanged: (v) => setState(
                                        () => _remember = v ?? false,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      activeColor: accentColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Ingat saya',
                                      style: TextStyle(color: textSecondary),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Lupa password? - Demo'),
                                      ),
                                    );
                                  },
                                  child: const Text('Lupa password?'),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Primary Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _tryLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  elevation: 8,
                                  // ignore: deprecated_member_use
                                  shadowColor: Colors.black.withOpacity(0.12),
                                ),
                                child: const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Google Button (mock)
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Masuk dengan Google'),
                                    ),
                                  );
                                },
                                icon: Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'G',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                label: const Text(
                                  'Masuk dengan Google',
                                  style: TextStyle(fontSize: 15),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  side: BorderSide(
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  foregroundColor: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).inputDecorationTheme.fillColor,
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),
                          ],
                        ),
                      ),

                      // Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Belum punya akun? ',
                            style: TextStyle(color: textSecondary),
                          ),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Daftar - Demo')),
                              );
                            },
                            child: Text(
                              'Daftar',
                              style: TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}