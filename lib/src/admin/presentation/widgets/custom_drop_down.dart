import 'package:flutter/material.dart';

class CustomDropdownInput extends StatefulWidget {
  const CustomDropdownInput({
    required this.hint,
    required this.value,
    required this.dropdownItems,
    required this.icon,
    required this.onChanged,
    required this.validator,
    this.fillColor,
    this.fromAuth = true,
    super.key, 
  });

  final String hint;
  final Object? value;
  final List<String> dropdownItems;
  final Icon? icon;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String?>? validator;
  final Color? fillColor;
  final bool fromAuth;

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
        filled: widget.fillColor != null,
        fillColor: widget.fillColor,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffEFEFEF)),
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
        labelText: widget.fromAuth ? widget.hint : null,
        hintText: widget.fromAuth ? null : widget.hint,
        labelStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: const Color(0xff717171)),
        hintStyle:  Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: const Color(0xff717171)),
        contentPadding:
             EdgeInsets.symmetric(vertical: widget.fromAuth ? 20.0 : 0, horizontal: 18.0),
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
