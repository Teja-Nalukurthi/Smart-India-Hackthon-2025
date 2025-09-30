import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class SearchBar extends StatefulWidget {
  final String hintText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;

  const SearchBar({
    super.key,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withAlpha((255 * 0.3).round()),
          width: 2,
        ), // Enhanced border with primary color
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha((255 * 0.1).round()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.05).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        enabled: widget.enabled,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textLight,
          fontSize: 16,
          fontWeight: FontWeight.w500, // Slightly bolder text
        ),
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSubtle.withAlpha((255 * 0.6).round()),
            fontSize: 16,
          ),
          prefixIcon:
              widget.prefixIcon ??
              Icon(
                Icons.search,
                color: AppColors.primary.withAlpha((255 * 0.8).round()), // Enhanced icon color
                size: 24,
              ),
          suffixIcon: widget.suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          fillColor: Colors.white, // Ensure background is white
          filled: true,
        ),
      ),
    );
  }
}
