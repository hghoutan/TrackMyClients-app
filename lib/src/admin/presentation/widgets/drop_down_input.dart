import 'package:flutter/material.dart';

class CustomDropdownInput extends StatefulWidget {
  const CustomDropdownInput({
    required this.hint,
    required this.value,
    required this.dropdownItems,
    required this.icon,
    required this.onChanged,
    required this.validator,
    super.key,
  });

  final String hint;
  final String? value;
  final List<String> dropdownItems;
  final Icon? icon;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String?>? validator;

  @override
  State<CustomDropdownInput> createState() => _CustomDropdownInputState();
}

class _CustomDropdownInputState extends State<CustomDropdownInput> {

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      icon: const Visibility(
        visible: false,
        child: Icon(Icons.arrow_downward),
      ),
      decoration: InputDecoration(
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
        suffixIcon: widget.icon,
        hintText: widget.hint,
        hintStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: const Color(0xff1a1c1c)),
        contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 18.0),
      ),
      items: widget.dropdownItems
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ))
          .toList(),
      onChanged: widget.onChanged,
      isDense: true,
      validator: widget.validator,
      
    );
  }
}
