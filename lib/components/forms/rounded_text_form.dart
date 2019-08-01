import 'package:flutter/material.dart';

class RoundedTextForm extends StatefulWidget {
  final Key key;
  final bool obscureText;
  final FocusNode focus;
  final String hint;
  final IconData prefixIconData;
  final IconData suffixIconData;
  final TextInputType textInputType;
  final TextEditingController textController;
  final TextInputAction textInputAction;
  final Function onSuffixIconClicked;
  final Function(String) onSubmitted;

  RoundedTextForm({
    @required this.hint,
    this.key,
    this.prefixIconData,
    this.suffixIconData,
    this.textInputType,
    this.textController,
    this.textInputAction,
    this.obscureText,
    this.focus,
    this.onSuffixIconClicked,
    this.onSubmitted,
  });

  @override
  _RoundedTextFormState createState() => _RoundedTextFormState();
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
    bool isObscureText = false;

    if (widget.obscureText != null && widget.obscureText) {
      isObscureText = true;
    }

    return TextField(
      key: widget.key,
      focusNode: widget.focus,
      controller: widget.textController,
      textInputAction: widget.textInputAction == null
          ? TextInputAction.next
          : widget.textInputAction,
      autocorrect: false,
      obscureText: isObscureText,
      keyboardType: widget.textInputType == null
          ? TextInputType.text
          : widget.textInputType,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        prefixIcon: _displayPrefixIcon(),
        suffixIcon: _displaySuffixIcon(),
        fillColor: Colors.white,
        border: _inputBorder,
        errorBorder: _inputBorder,
        focusedBorder: _inputBorder,
        filled: true,
        hintText: widget.hint,
        contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 0),
      ),
    );
  }
}
