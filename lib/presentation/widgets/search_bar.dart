import 'package:flutter/material.dart';
import 'package:venturepoint/core/theme/app_colors.dart';

class SearchBarWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final Color backgroundColor;
  final Color textColor;
  final Color hintColor;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Search destinations, hotels, flights...',
    this.controller,
    this.onChanged,
    this.onFilterTap,
    this.backgroundColor = AppColors.secondary,
    this.textColor = AppColors.textPrimary,
    this.hintColor = AppColors.textSecondary,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
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
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: widget.textColor,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: widget.hintColor,
          ),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: widget.hintColor, size: 20),
          suffixIcon: GestureDetector(
            onTap: widget.onFilterTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.tune, color: widget.hintColor, size: 20),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 8,
          ),
        ),
      ),
    );
  }
}
