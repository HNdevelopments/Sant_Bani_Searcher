import 'dart:async';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final FocusNode _focusNode = FocusNode();

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _search(String value) {
    _debounce?.cancel();

    _debounce = Timer(
      const Duration(milliseconds: 120),
      () => widget.onChanged(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF6B3F2A);

    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      onChanged: _search,
      textInputAction: TextInputAction.search,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: "Search",

        // 👇 Only search keywords
        

        prefixIcon: const Icon(
          Icons.search_rounded,
          color: primary,
        ),

        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: widget.controller,
          builder: (_, value, __) {
            if (value.text.isEmpty) {
              return const SizedBox.shrink();
            }

            return IconButton(
              icon: const Icon(Icons.close_rounded),
              splashRadius: 20,
              onPressed: () {
                widget.controller.clear();
                widget.onChanged("");
              },
            );
          },
        ),

        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFFE5DDD2),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}