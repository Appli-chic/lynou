import 'package:flutter/material.dart';

class RoundedTextForm extends StatefulWidget {
  RoundedTextForm({
    @required this.hint,
    this.prefixIconData,
    this.suffixIconData,
    this.textInputType,
    this.textController,
    this.obscureText,
    this.onSuffixIconClicked,
  });

  @override
  _RoundedTextFormState createState() => _RoundedTextFormState();

  final bool obscureText;
  final String hint;
  final IconData prefixIconData;
  final IconData suffixIconData;
  final TextInputType textInputType;
  final TextEditingController textController;
  final Function onSuffixIconClicked;
}

class _RoundedTextFormState extends State<RoundedTextForm> {
  InputBorder _inputBorder = OutlineInputBorder();

  @override
  void initState() {
    _inputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        const Radius.circular(28.0),
      ),
      borderSide: BorderSide(color: Colors.transparent),
    );

    super.initState();
  }

  /// Displays a prefix icon in this text form unless there is no one
  Widget _displayPrefixIcon() {
    if (widget.prefixIconData != null) {
      return Icon(widget.prefixIconData);
    } else {
      return null;
    }
  }

  /// Displays a suffix icon in this text form unless there is no one
  Widget _displaySuffixIcon() {
    if (widget.suffixIconData != null) {
      return IconButton(
        icon: Icon(widget.suffixIconData, color: Colors.black45),
        onPressed: () {
          widget.onSuffixIconClicked();
        },
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _isObscureText = false;

    if (widget.obscureText != null && widget.obscureText) {
      _isObscureText = true;
    }

    return TextField(
      controller: widget.textController,
      decoration: InputDecoration(
        prefixIcon: _displayPrefixIcon(),
        suffixIcon: _displaySuffixIcon(),
        fillColor: Colors.white,
        border: _inputBorder,
        errorBorder: _inputBorder,
        focusedBorder: _inputBorder,
        filled: true,
        hintText: widget.hint,
        contentPadding: new EdgeInsets.symmetric(vertical: 18.0, horizontal: 0),
      ),
      autocorrect: false,
      obscureText: _isObscureText,
      keyboardType: widget.textInputType == null
          ? TextInputType.text
          : widget.textInputType,
    );
  }
}
