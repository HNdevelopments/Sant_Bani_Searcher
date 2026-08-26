import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisclaimerDialog {
  static const String _prefKey = "hide_disclaimer";

  static Future<void> show(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    final hide = prefs.getBool(_prefKey) ?? false;

    if (hide) return;

    bool dontShowAgain = false;

    if (!context.mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFFFAF7F2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              title: const Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFF6B3F2A),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Important Notice",
                    style: TextStyle(
                      color: Color(0xFF6B3F2A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 380,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "All quotes used in Sant Bani Searcher are sourced from the PDF available on Soamiji Maharaj's Bani.\n\n"
                        "While we have taken great care in preparing this application, some typing errors may still exist. We are continuously reviewing and correcting them, and these will be fixed in future updates.\n\n"
                        "Until then, we kindly request you to cross-check the quotes with the original source whenever necessary.\n\n"
                        "Thank you for your understanding and support.",
                        style: TextStyle(
                          fontSize: 15.5,
                          height: 1.6,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 18),
                      CheckboxListTile(
                        value: dontShowAgain,
                        activeColor: const Color(0xFF6B3F2A),
                        contentPadding: EdgeInsets.zero,
                        controlAffinity:
                            ListTileControlAffinity.leading,
                        title: const Text(
                          "Don't show this message again",
                          style: TextStyle(
                            fontSize: 14.5,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            dontShowAgain = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                18,
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF6B3F2A),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () async {
                      if (dontShowAgain) {
                        await prefs.setBool(_prefKey, true);
                      }

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}