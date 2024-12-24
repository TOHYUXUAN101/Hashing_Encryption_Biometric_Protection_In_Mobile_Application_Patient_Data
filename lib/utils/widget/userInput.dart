import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hospitize/utils/constant/color.dart';

class ReusableInputField extends StatefulWidget {
  final String labelText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool obscureText;
  final Function()? onIconTap;
  final Icon? suffixIcon;
  final FocusNode focusNode;
  final bool isReadOnly;
  final bool isCalendar;
  final Function(DateTime)? onDateSelected;
  final bool isInputFormatter;


  const ReusableInputField({
    required this.labelText,
    required this.controller,
    required this.focusNode,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onIconTap,
    this.suffixIcon,
    this.isReadOnly=false,
    this.isCalendar = false,
    this.onDateSelected,
    this.isInputFormatter=false,
    super.key
  });

  @override
  _ReusableInputFieldState createState() => _ReusableInputFieldState();
}

class _ReusableInputFieldState extends State<ReusableInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: TextField(
        inputFormatters: widget.isInputFormatter ? [FilteringTextInputFormatter.digitsOnly] : null,
        onTap: !widget.isReadOnly
        ? (widget.isCalendar
          ? () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
              if(selectedDate != null && widget.onDateSelected != null) {
                widget.onDateSelected!(selectedDate); // Trigger the callback
                widget.controller.text = "${selectedDate.toLocal()}".split(' ')[0]; // Format and set the date, [0] is the array to take
              }
            }
          : null)
        : null,
        controller: widget.controller,
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType,
        readOnly: widget.isReadOnly || widget.isCalendar,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          labelText: widget.labelText,
          contentPadding: EdgeInsets.symmetric(vertical:20, horizontal: 30),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: ColorManager.grey),
          ),
          floatingLabelStyle: TextStyle(
            color: ColorManager.red, // Floating label color
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: ColorManager.red,
            ),
          ),
          suffixIconColor:ColorManager.red,
          suffixIcon: widget.suffixIcon != null
          ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: GestureDetector(
              onTap: widget.onIconTap,
              child: widget.suffixIcon,
            ),
          ): null,
        ),
      ),
    );
  }
}
