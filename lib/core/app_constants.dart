import 'package:flutter/material.dart';

abstract class AppConstants {
  // Colors
  static const primaryColor = Color(0xFF032541);

  // Spacing
  static const double spacing2 = 2.0;
  static const double spacing4 = 4.0;
  static const double spacing6 = 6.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 58.0;

  // Padding
  static const horizontalPadding4 = EdgeInsets.symmetric(horizontal: spacing4);
  static const horizontalPadding8 = EdgeInsets.symmetric(horizontal: spacing8);
  static const horizontalPadding12 = EdgeInsets.symmetric(
    horizontal: spacing12,
  );
  static const horizontalPadding16 = EdgeInsets.symmetric(
    horizontal: spacing16,
  );
  static const horizontalPadding24 = EdgeInsets.symmetric(
    horizontal: spacing24,
  );
  static const horizontalPadding32 = EdgeInsets.symmetric(
    horizontal: spacing32,
  );

  static const verticalPadding4 = EdgeInsets.symmetric(vertical: spacing4);
  static const verticalPadding8 = EdgeInsets.symmetric(vertical: spacing8);
  static const verticalPadding12 = EdgeInsets.symmetric(vertical: spacing12);
  static const verticalPadding16 = EdgeInsets.symmetric(vertical: spacing16);
  static const verticalPadding24 = EdgeInsets.symmetric(vertical: spacing24);
  static const verticalPadding32 = EdgeInsets.symmetric(vertical: spacing32);

  static const topPadding4 = EdgeInsets.only(top: spacing4);
  static const topPadding8 = EdgeInsets.only(top: spacing8);
  static const topPadding12 = EdgeInsets.only(top: spacing12);
  static const topPadding16 = EdgeInsets.only(top: spacing16);
  static const topPadding24 = EdgeInsets.only(top: spacing24);
  static const topPadding32 = EdgeInsets.only(top: spacing32);

  static const bottomPadding4 = EdgeInsets.only(bottom: spacing4);
  static const bottomPadding8 = EdgeInsets.only(bottom: spacing8);
  static const bottomPadding12 = EdgeInsets.only(bottom: spacing12);
  static const bottomPadding16 = EdgeInsets.only(bottom: spacing16);
  static const bottomPadding24 = EdgeInsets.only(bottom: spacing24);
  static const bottomPadding32 = EdgeInsets.only(bottom: spacing32);

  static const leftPadding4 = EdgeInsets.only(left: spacing4);
  static const leftPadding8 = EdgeInsets.only(left: spacing8);
  static const leftPadding12 = EdgeInsets.only(left: spacing12);
  static const leftPadding16 = EdgeInsets.only(left: spacing16);
  static const leftPadding24 = EdgeInsets.only(left: spacing24);
  static const leftPadding32 = EdgeInsets.only(left: spacing32);

  static const rightPadding4 = EdgeInsets.only(right: spacing4);
  static const rightPadding8 = EdgeInsets.only(right: spacing8);
  static const rightPadding12 = EdgeInsets.only(right: spacing12);
  static const rightPadding16 = EdgeInsets.only(right: spacing16);
  static const rightPadding24 = EdgeInsets.only(right: spacing24);
  static const rightPadding32 = EdgeInsets.only(right: spacing32);

  static const padding4 = EdgeInsets.all(spacing4);
  static const padding8 = EdgeInsets.all(spacing8);
  static const padding12 = EdgeInsets.all(spacing12);
  static const padding16 = EdgeInsets.all(spacing16);
  static const padding24 = EdgeInsets.all(spacing24);
  static const padding32 = EdgeInsets.all(spacing32);

  // Border Radius
  static const borderRadius4 = BorderRadius.all(Radius.circular(spacing4));
  static const borderRadius8 = BorderRadius.all(Radius.circular(spacing8));
  static const borderRadius12 = BorderRadius.all(Radius.circular(spacing12));
  static const borderRadius16 = BorderRadius.all(Radius.circular(spacing16));
  static const borderRadius24 = BorderRadius.all(Radius.circular(spacing24));
  static const borderRadius32 = BorderRadius.all(Radius.circular(spacing32));
}
