import 'package:flutter/material.dart';

class RoundedTextForm extends StatefulWidget {
  RoundedTextForm({
    @required this.hint,
    this.prefixIconData,
    this.suffixIconData,
    this.obscureText,
  });

  @override
  _RoundedTextFormState createState() => _RoundedTextFormState();

  final bool obscureText;
  final String hint;
  final IconData prefixIconData;
  final IconData suffixIconData;
}

class _RoundedTextFormState extends State<RoundedTextForm> {
  TextEditingController _textController = TextEditingController();
  InputBorder _inputBorder = OutlineInputBorder();
  bool _obscureText = false;

  @override
  void initState() {
    _inputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        const Radius.circular(28.0),
      ),
      borderSide: BorderSide(color: Colors.transparent),
    );

    // Obscure text is false as default value
    if (widget.obscureText != null && widget.obscureText) {
      _obscureText = true;
    }

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
      return Icon(widget.suffixIconData, color: Colors.black45);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: TextFormField(
        controller: _textController,
        // validator: _validateUsername,
        decoration: InputDecoration(
          prefixIcon: _displayPrefixIcon(),
          suffixIcon: _displaySuffixIcon(),
          fillColor: Colors.white,
          border: _inputBorder,
          errorBorder: _inputBorder,
          focusedBorder: _inputBorder,
          filled: true,
          hintText: widget.hint,
        ),
        autocorrect: false,
        obscureText: _obscureText,
      ),
    );
  }
}
