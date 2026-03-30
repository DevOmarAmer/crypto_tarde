import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final bool isPassword;
  final String? trailingActionText;
  final VoidCallback? onTrailingActionTap;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.isPassword = false,
    this.trailingActionText,
    this.onTrailingActionTap,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 14,
              ),
            ),
            if (widget.trailingActionText != null)
              GestureDetector(
                onTap: widget.onTrailingActionTap,
                child: Text(
                  widget.trailingActionText!,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _obscureText : false,
          style: const TextStyle(color: AppColors.white),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
            filled: true,
            fillColor: AppColors.darkSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
