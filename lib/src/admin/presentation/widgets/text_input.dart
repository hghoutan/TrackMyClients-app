import 'package:flutter/material.dart';

class CustomTextInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String obscuringCharacter;
  final TextInputType keyboardType;
  final Icon? icon;
  final Function(String)? onChanged;
  final FormFieldValidator<String?>? validator;

  const CustomTextInput({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.keyboardType = TextInputType.text,
    this.icon,
    this.onChanged,
  });

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput>
    with RestorationMixin {
      
    @override
    String? get restorationId => "main";

    final RestorableDateTime _selectedDate =
        RestorableDateTime(DateTime(2021, 7, 25));
    late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
        RestorableRouteFuture<DateTime?>(
      onComplete: _selectDate,
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(
          _datePickerRoute,
          arguments: _selectedDate.value.millisecondsSinceEpoch,
        );
      },
    );

    @pragma('vm:entry-point')
    static Route<DateTime> _datePickerRoute(
      BuildContext context,
      Object? arguments,
    ) {
      return DialogRoute<DateTime>(
        context: context,
        builder: (BuildContext context) {
          return DatePickerTheme(
            data: const DatePickerThemeData(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
            ),
            child: DatePickerDialog(
              restorationId: 'date_picker_dialog',
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
              firstDate: DateTime(1900),
              lastDate: DateTime(2022),
            ),
          );
        },
      );
    }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        widget.controller.text =
            '${_selectedDate.value.day.toString().padLeft(2, '0')}/${_selectedDate.value.month.toString().padLeft(2, '0')}/${_selectedDate.value.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      obscuringCharacter: widget.obscuringCharacter,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      readOnly: widget.keyboardType == TextInputType.datetime,
      onTap: () {
        if (widget.keyboardType == TextInputType.datetime) {
          _restorableDatePickerRouteFuture.present();
        }
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffEFEFEF)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        errorBorder: OutlineInputBorder(
          // Add errorBorder
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          // Add focusedErrorBorder
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        suffixIcon: widget.icon,
        labelText: widget.hintText,
        labelStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: const Color(0xff717171)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
      ),
      validator: widget.validator,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}
