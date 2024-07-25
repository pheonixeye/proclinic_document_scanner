import 'package:flutter/material.dart';

class CentralLoading extends StatelessWidget {
  const CentralLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}
