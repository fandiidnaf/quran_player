import 'package:flutter/material.dart';

/// Design token colours matching the prototype (dark emerald + gold theme).
class AppColors {
  AppColors._();

  // ── Backgrounds ────────────────────────────────────────────────
  static const Color bg1 = Color(0xFF0A1A17);
  static const Color bg2 = Color(0xFF06100E);

  // ── Surfaces ───────────────────────────────────────────────────
  /// rgba(255,255,255,0.045)
  static const Color surface = Color(0x0BFFFFFF);

  /// rgba(255,255,255,0.08)
  static const Color surfaceBorder = Color(0x14FFFFFF);

  // ── Brand ──────────────────────────────────────────────────────
  static const Color gold = Color(0xFFE0BE7B);
  static const Color goldDeep = Color(0xFFC9A24B);
  static const Color emerald = Color(0xFF37C28C);

  // ── Text ───────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF3EFE4);

  /// rgba(243,239,228,0.56)
  static const Color textMuted = Color(0x8FF3EFE4);

  /// rgba(243,239,228,0.34)
  static const Color textFaint = Color(0x57F3EFE4);

  // ── Surah cover gradients (6 pairs, cycled by surahNumber % 6) ─
  static const List<List<Color>> coverGradients = [
    [Color(0xFF1F6F5C), Color(0xFF0C332B)],
    [Color(0xFF3A6EA5), Color(0xFF16263F)],
    [Color(0xFF9A6A3A), Color(0xFF3A2515)],
    [Color(0xFF5B4B8A), Color(0xFF241D3A)],
    [Color(0xFFA04668), Color(0xFF3A1828)],
    [Color(0xFF3F7D6E), Color(0xFF152E29)],
  ];

  static List<Color> coverFor(int surahNumber) =>
      coverGradients[(surahNumber - 1) % coverGradients.length];
}
