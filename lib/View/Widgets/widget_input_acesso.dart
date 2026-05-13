import 'package:flutter/material.dart';

class CampoTexto extends StatelessWidget {
  final String label;
  final String hintText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;

  const CampoTexto({
    super.key,
    required this.label,
    required this.hintText,
    this.validator,
    this.controller,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 355),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface, // ✅ cor escura
            ),
          ),
          const SizedBox(height: 6),
          DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black54.withOpacity(0.15),
              blurRadius: 8)],
            ),
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hintText,
                suffixIcon: suffixIcon,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    // ✅ borda azul ao focar
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                ),
              ),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }
}
