// Copyright (C) 2026 Daily You TH3 Learning English
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/layouts/mobile_scaffold.dart';
import 'package:daily_you/models/user.dart';
import 'package:daily_you/providers/user_session_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isRegisterMode = false;
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = context.read<UserSessionProvider>();
      if (session.allUsers.isNotEmpty) {
        final firstUser = session.currentUser ?? session.allUsers.first;
        _usernameController.text = firstUser.email ?? firstUser.name;
        _passwordController.text = firstUser.password ?? '123456';
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final session = context.read<UserSessionProvider>();

    try {
      if (_isRegisterMode) {
        final name = _nameController.text.trim();
        final email = _usernameController.text.trim();
        final password = _passwordController.text.trim();

        await session.registerUser(
          name: name,
          email: email.isNotEmpty ? email : null,
          password: password.isNotEmpty ? password : '123456',
        );

        if (mounted) {
          _navigateToHome();
        }
      } else {
        final identifier = _usernameController.text.trim();
        final password = _passwordController.text.trim();

        final success = await session.login(
          identifier: identifier,
          password: password,
        );

        if (!success) {
          setState(() {
            _errorMessage =
                'Tài khoản hoặc mật khẩu không chính xác. Mật khẩu mặc định là 123456.';
            _isLoading = false;
          });
          return;
        }

        if (mounted) {
          _navigateToHome();
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Đã xảy ra lỗi: $e';
        _isLoading = false;
      });
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MobileScaffold()),
    );
  }

  void _selectUser(User user) {
    setState(() {
      _usernameController.text = user.email ?? user.name;
      _passwordController.text = user.password ?? '123456';
      _isRegisterMode = false;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = context.watch<UserSessionProvider>();
    final users = session.allUsers;

    return Scaffold(
      backgroundColor: const Color(0xFFEEF1FF), // Soft Ice White
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              elevation: 4,
              shadowColor: const Color(0xFFB1B2FF).withAlpha(80),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(color: Color(0xFFD2DAFF), width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // LOGO & TÊN ỨNG DỤNG
                      Center(
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFB1B2FF), Color(0xFF6C63FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6C63FF).withAlpha(80),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.record_voice_over_rounded,
                            size: 38,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          'learningEnglish',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            color: const Color(0xFF2D2B55),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          _isRegisterMode
                              ? 'Đăng ký tài khoản học viên mới'
                              : 'Luyện phát âm & Theo dõi tiến độ học tập',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // THÔNG BÁO LỖI NẾU CÓ
                      if (_errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: const Color(0xFFD32F2F).withAlpha(120)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline_rounded,
                                  color: Color(0xFFD32F2F), size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    color: Color(0xFFD32F2F),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // TRƯỜNG NHẬP: TÊN (KHI ĐĂNG KÝ)
                      if (_isRegisterMode) ...[
                        Text(
                          'HỌ VÀ TÊN HỌC VIÊN',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: const Color(0xFF6C63FF),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Ví dụ: Nguyễn Văn A',
                            prefixIcon: const Icon(Icons.badge_outlined,
                                color: Color(0xFF6C63FF)),
                            filled: true,
                            fillColor: const Color(0xFFF7F8FF),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  const BorderSide(color: Color(0xFFD2DAFF)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  const BorderSide(color: Color(0xFFD2DAFF)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                  color: Color(0xFF6C63FF), width: 1.5),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Vui lòng nhập họ và tên';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      // TRƯỜNG NHẬP: TÀI KHOẢN / EMAIL
                      Text(
                        _isRegisterMode ? 'EMAIL / TÊN ĐĂNG NHẬP' : 'TÀI KHOẢN / EMAIL',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: const Color(0xFF6C63FF),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: _isRegisterMode
                              ? 'learner@dailyyou.edu.vn'
                              : 'Nhập tên học viên hoặc email...',
                          prefixIcon: const Icon(Icons.person_outline_rounded,
                              color: Color(0xFF6C63FF)),
                          filled: true,
                          fillColor: const Color(0xFFF7F8FF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide:
                                const BorderSide(color: Color(0xFFD2DAFF)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide:
                                const BorderSide(color: Color(0xFFD2DAFF)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                color: Color(0xFF6C63FF), width: 1.5),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Vui lòng nhập tài khoản hoặc email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // TRƯỜNG NHẬP: MẬT KHẨU
                      Text(
                        'MẬT KHẨU',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: const Color(0xFF6C63FF),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Nhập mật khẩu (Mặc định: 123456)',
                          prefixIcon: const Icon(Icons.lock_outline_rounded,
                              color: Color(0xFF6C63FF)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF7F8FF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide:
                                const BorderSide(color: Color(0xFFD2DAFF)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide:
                                const BorderSide(color: Color(0xFFD2DAFF)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                color: Color(0xFF6C63FF), width: 1.5),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Vui lòng nhập mật khẩu';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // NÚT HÀNH ĐỘNG CHÍNH
                      FilledButton(
                        onPressed: _isLoading ? null : _handleAuth,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                _isRegisterMode
                                    ? 'Đăng ký học viên & Vào học'
                                    : 'Đăng nhập vào learningEnglish',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ),
                              ),
                      ),
                      const SizedBox(height: 12),

                      // CHUYỂN ĐỔI ĐĂNG KÝ / ĐĂNG NHẬP
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                setState(() {
                                  _isRegisterMode = !_isRegisterMode;
                                  _errorMessage = null;
                                });
                              },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF6C63FF),
                        ),
                        child: Text(
                          _isRegisterMode
                              ? 'Đã có tài khoản? Đăng nhập ngay'
                              : 'Chưa có tài khoản? Đăng ký học viên mới',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      // DANH SÁCH CHỌN NHANH HỌC VIÊN CÓ SẴN (MULTI-USER TESTING)
                      if (users.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Divider(color: Color(0xFFD2DAFF)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.people_alt_outlined,
                                size: 16, color: Color(0xFF6C63FF)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'CHỌN NHANH TÀI KHOẢN KIỂM THỬ (MULTI-USER):',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: const Color(0xFF6C63FF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: users.map((u) {
                            final isCurrent =
                                session.currentUser?.id == u.id &&
                                    !_isRegisterMode;
                            return ActionChip(
                              avatar: CircleAvatar(
                                backgroundColor: isCurrent
                                    ? Colors.white
                                    : const Color(0xFF6C63FF),
                                child: Text(
                                  u.name.isNotEmpty
                                      ? u.name[0].toUpperCase()
                                      : 'U',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isCurrent
                                        ? const Color(0xFF6C63FF)
                                        : Colors.white,
                                  ),
                                ),
                              ),
                              label: Text(u.name),
                              backgroundColor: isCurrent
                                  ? const Color(0xFF6C63FF)
                                  : const Color(0xFFEEF1FF),
                              labelStyle: TextStyle(
                                color: isCurrent
                                    ? Colors.white
                                    : const Color(0xFF2D2B55),
                                fontWeight: isCurrent
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 13,
                              ),
                              side: BorderSide(
                                color: isCurrent
                                    ? const Color(0xFF6C63FF)
                                    : const Color(0xFFB1B2FF),
                              ),
                              onPressed: () => _selectUser(u),
                            );
                          }).toList(),
                        ),
                      ],
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
