import 'package:flutter/material.dart';

class NewClientTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Icon? icon;
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  final bool obscureText;
  final FormFieldValidator<String?>? validator;
  const NewClientTextInput(
      {super.key,
      required this.controller,
      required this.hintText,
      this.obscureText = false,
      this.icon,
      this.keyboardType = TextInputType.text,
      this.onChanged,
      this.validator,  
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        
        fillColor: const Color(0xfffbfafa),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffd2d2d7)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        hintText: hintText,
        hintStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: const Color(0xff717171)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18.0),
      ),
      validator: validator,
      style: Theme.of(context).textTheme.titleMedium,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
    );
  }
}
