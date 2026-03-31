import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/social_login_button.dart';
import '../../../../core/routes/app_router.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _isEmailMethod = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: const Icon(Icons.close, color: AppColors.grey, size: 28),
                onPressed: () => context.pop(),
              ),
              const SizedBox(height: 24),
              _buildAuthToggle(),
              const SizedBox(height: 32),
              Text(
                _isLogin ? 'Sign in' : 'Sign up',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              if (_isEmailMethod)
                CustomTextField(
                  label: 'Email',
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  trailingActionText: _isLogin ? 'Sign in with mobile' : 'Register with mobile',
                  onTrailingActionTap: () => setState(() => _isEmailMethod = false),
                )
              else
                CustomTextField(
                  label: 'Mobile Number',
                  hintText: 'Enter your mobile',
                  keyboardType: TextInputType.phone,
                  trailingActionText: _isLogin ? 'Sign in with email' : 'Register with email',
                  onTrailingActionTap: () => setState(() => _isEmailMethod = true),
                ),
              const SizedBox(height: 24),
              const CustomTextField(
                label: 'Password',
                hintText: 'Enter your password',
                isPassword: true,
              ),
              const SizedBox(height: 16),
              if (_isLogin)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(color: AppColors.primary, fontSize: 14),
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: _isLogin ? 'Sign in' : 'Sign up',
                  onPressed: () {
                    context.go(AppRouter.home);
                  },
                ),

              ),
              const SizedBox(height: 32),
              const Center(
                child: Text(
                  'Or login with',
                  style: TextStyle(color: AppColors.grey, fontSize: 14),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  SocialLoginButton(
                    text: 'Facebook',
                    icon: Icons.facebook,
                    iconColor: Colors.blue,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 16),
                  SocialLoginButton(
                    text: 'Google',
                    icon: Icons.g_mobiledata,
                    iconColor: Colors.red,
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 48),
              if (_isLogin)
                Center(
                  child: Column(
                    children: [
                      IconButton(
                        iconSize: 48,
                        icon: const Icon(Icons.fingerprint, color: AppColors.primary),
                        onPressed: () {},
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Use fingerprint instead?',
                        style: TextStyle(color: AppColors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthToggle() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.toggleBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isLogin = true),
              child: Container(
                decoration: BoxDecoration(
                  color: _isLogin ? AppColors.toggleActive : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Sign in',
                  style: TextStyle(
                    color: _isLogin ? AppColors.white : AppColors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isLogin = false),
              child: Container(
                decoration: BoxDecoration(
                  color: !_isLogin ? AppColors.toggleActive : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    color: !_isLogin ? AppColors.white : AppColors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
