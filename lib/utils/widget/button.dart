import 'package:flutter/material.dart';
import 'package:hospitize/utils/constant/color.dart';

class ReusableButton extends StatefulWidget {
  final String btnText;
  final Function() onBtnSubmit;
  final bool isNotTransparentButton;
  final Color fontColor;
  final bool isEnabled;

  const ReusableButton({
    required this.btnText,
    required this.onBtnSubmit,
    required this.isNotTransparentButton,
    required this.fontColor,
    this.isEnabled = true,
    super.key
  });

  @override
  State<ReusableButton> createState() => _ReusableButtonState();
}

class _ReusableButtonState extends State<ReusableButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: InkWell(
        onTap: widget.isEnabled ? widget.onBtnSubmit : null,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          decoration: BoxDecoration(
            color: widget.isEnabled
              ? (widget.isNotTransparentButton ? ColorManager.red : null)
              : ColorManager.pink,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            widget.btnText, 
            textAlign: TextAlign.center,
            style: TextStyle(
              color: widget.fontColor,
            )
          ),
        ),
      ),
    );
  }
}