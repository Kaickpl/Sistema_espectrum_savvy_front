import 'package:flutter/material.dart';

class FundoTela extends StatelessWidget {
  final Widget child;

  const FundoTela({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.onPrimary,
            Theme.of(context).colorScheme.tertiary,
          ],
        ),
      ),
      child: child,
    );
  }
}