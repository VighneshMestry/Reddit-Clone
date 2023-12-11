import 'package:flutter/material.dart';

class ErrorLine extends StatelessWidget {
  final String error;
  const ErrorLine({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error),
    );
  }
}