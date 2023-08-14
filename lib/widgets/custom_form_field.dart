import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    Key? key,
    required TextEditingController controller,
    required FocusNode focusNode,
    required TextInputType keyboardType,
    required TextInputAction inputAction,
    required String label,
    required String hint,
    required Function(String value) validator,
    this.isObscure = false,
    this.isCapitalized = false,
  })  : _controller = controller,
        _focusNode = focusNode,
        _keyboardType = keyboardType,
        _inputAction = inputAction,
        _label = label,
        _hint = hint,
        _validator = validator,
        super(key: key);

  final TextEditingController _controller;
  final FocusNode _focusNode;
  final TextInputType _keyboardType;
  final TextInputAction _inputAction;
  final String _label;
  final String _hint;
  final bool isObscure;
  final bool isCapitalized;
  final Function(String) _validator;

  

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) => _validator(value!),
      controller: _controller,
      focusNode: _focusNode,
      obscureText: isObscure,
      keyboardType: _keyboardType,
      textInputAction: _inputAction,
      decoration: InputDecoration(
        labelText: _label,
        hintText: _hint,
      ),
    );
  }
}
