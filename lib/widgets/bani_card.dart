import 'package:flutter/material.dart';
import '../models/bani.dart';

class BaniCard extends StatelessWidget {
  final Bani bani;
  final VoidCallback onTap;
  final bool highlighted;

  const BaniCard({
    super.key,
    required this.bani,
    required this.onTap,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      child: Material(
        color: highlighted
            ? const Color(0xFFF7EEE5)
            : Colors.white,
        elevation: highlighted ? 8 : 1,
        shadowColor: highlighted
            ? const Color(0xFF8B5E3C).withOpacity(0.25)
            : Colors.black.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          splashColor:
              const Color(0xFF6B3F2A).withOpacity(0.08),
          highlightColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: highlighted
                    ? const Color(0xFF8B5E3C)
                    : const Color(0xFFE8E0D5),
                width: highlighted ? 2 : 1,
              ),
            ),
            child: Text(
              bani.bani,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 19,
                height: 1.65,
                color: highlighted
                    ? const Color(0xFF5B2E2E)
                    : const Color(0xFF2C2C2C),
                fontWeight: highlighted
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}