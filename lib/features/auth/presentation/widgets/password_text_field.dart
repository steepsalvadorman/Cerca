import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    super.key,
    required this.value,
    required this.obscureText,
    required this.onChanged,
    required this.onToggleVisibility,
  });

  final String value;
  final bool obscureText;
  final ValueChanged<String> onChanged;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextFormField(
        initialValue: value,
        onChanged: onChanged,
        obscureText: obscureText,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: 'Contraseña',
          hintText: 'Tu contraseña',
          prefixIcon: Image.asset('assets/images/password.png', width: 24, height: 24),
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
            tooltip: obscureText ? 'Mostrar contraseña' : 'Ocultar contraseña',
            onPressed: onToggleVisibility,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.borderIdle),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primaryBlue),
          ),
        ),
      ),
    );
  }
}
