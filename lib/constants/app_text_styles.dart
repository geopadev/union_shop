import 'package:flutter/material.dart';
import 'package:union_shop/constants/app_colors.dart';

/// App-wide text style constants
class AppTextStyles {
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  // Product text
  static const TextStyle productTitle = TextStyle(
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle productPrice = TextStyle(
    fontSize: 18,
    color: AppColors.primary,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle productPriceSale = TextStyle(
    fontSize: 18,
    color: AppColors.sale,
    fontWeight: FontWeight.bold,
  );

  // Navigation text
  static const TextStyle navigationItem = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  // Private constructor to prevent instantiation
  AppTextStyles._();
}
