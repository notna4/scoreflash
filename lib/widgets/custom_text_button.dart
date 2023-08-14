import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {Key? key,
      required String label,
      required Color bgColor,
      required Color textColor,
      required this.onCallBack,
      })
      : _label = label,
        _bgColor = bgColor,
        _textColor = textColor,
        super(key: key);

  final String _label;
  final Color _bgColor;
  final Color _textColor;
  final Function onCallBack;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onCallBack();
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.only(left: 20, right: 20),
        ),
        backgroundColor: MaterialStateProperty.all(_bgColor),
        shape: const MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
      ),
      child: Text(
        _label,
        style: TextStyle(
            color: _textColor, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
