import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class CitySearchField extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final bool isLoading;

  const CitySearchField({
    super.key,
    required this.onSearch,
    this.isLoading = false,
  });

  @override
  State<CitySearchField> createState() => _CitySearchFieldState();
}

class _CitySearchFieldState extends State<CitySearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    widget.onSearch(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _submit(),
            decoration:  InputDecoration(
              hintText: 'Enter city name (e.g. Cairo)',
              hintStyle: TextStyle(color: AppColors.textMuted.withAlpha(120),fontSize: 14),
              prefixIcon: Icon(Icons.location_city),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: widget.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.search),
          ),
        ),
      ],
    );
  }
}
