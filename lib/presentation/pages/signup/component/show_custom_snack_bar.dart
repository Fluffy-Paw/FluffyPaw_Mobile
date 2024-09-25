import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message, Color backgroundColor) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
      backgroundColor: backgroundColor, // Sử dụng màu sắc từ tham số
      duration: const Duration(milliseconds: 1500),
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 20.0,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, MediaQuery.of(context).padding.bottom),
    ),
  );
}
