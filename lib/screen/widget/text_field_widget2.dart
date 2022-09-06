import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sse/themes/colors.dart';
import 'package:sse/utils/utils.dart';

class TextFieldWidget2 extends StatefulWidget {
  const TextFieldWidget2(
      {required this.controller,
      this.textInputAction: TextInputAction.next,
      this.isEnable = true,
      this.onChanged,
      this.isPassword: false,
      this.inputFormatter,
      this.errorText,
      this.labelText,
      this.hintText,
      this.keyboardType: TextInputType.text,
      this.focusNode,
      this.onSubmitted,
      this.prefixIcon,
      this.suffix,
      this.readOnly,
      this.color,
      this.isNull});

  final TextEditingController controller;
  final bool isEnable;
  final List<TextInputFormatter>? inputFormatter;
  final TextInputAction textInputAction;
  final FormFieldSetter<String>? onChanged;
  final bool isPassword;
  final String? errorText;
  final String? labelText;
  final String? hintText;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final FormFieldSetter<String>? onSubmitted;
  final dynamic prefixIcon;
  final dynamic suffix;
  final bool? readOnly;
  final Color? color;
  final bool? isNull;

  @override
  _TextFieldWidget2State createState() => _TextFieldWidget2State();
}

class _TextFieldWidget2State extends State<TextFieldWidget2> {
  late bool _obscureText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(

      readOnly: widget.readOnly == null ? false : widget.readOnly!,
      enabled: widget.isEnable,
      focusNode: widget.focusNode,
      controller: widget.controller,
      obscureText: _obscureText,
      textInputAction: widget.textInputAction,
      textAlignVertical: TextAlignVertical.center,
      inputFormatters: widget.inputFormatter,
      decoration: InputDecoration(

          border: UnderlineInputBorder(borderSide: BorderSide(color: grey, width: 1),),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: grey, width: 1),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: grey, width: 1),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 4),
          isDense: true,
          focusColor: primaryColor,
          hintText: widget.hintText,

          labelText: widget.labelText,
          // suffix: widget.suffix == null
          //     ? null
          //     : Icon(widget.suffix,color: grey,size: 20,)
          // ,
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon == null
              ? null
              : (widget.prefixIcon is String
                  ? Padding(
                      child: Image.asset(
                        widget.prefixIcon,
                        width: 35,
                        height: 35,
                        fit: BoxFit.fitHeight,
                      ),
                      padding: EdgeInsets.all(12),
                    )
                  : Icon(
                      widget.prefixIcon,
                      color: accent,
                      size: 20,
                    )),
          suffixIcon: !widget.isPassword
              ? widget.suffix == null ? null : Icon(widget.suffix,color: grey,size: 20,)
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? MdiIcons.eye : MdiIcons.eyeOff,
                    semanticLabel:
                        _obscureText ? 'show password' : 'hide password',
                    color: blue,
                  ),
                ),
          labelStyle:
              TextStyle(color: widget.isNull == true ? widget.color : red, fontSize: 11),
          hintStyle: TextStyle(
            fontSize: 13,
            color: widget.isNull == true ? widget.color : red,
          ),
          errorStyle: TextStyle(
            fontSize: 10,
            color: red,
          )),
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      style: TextStyle(
        fontSize: 13,
        color: widget.isEnable ? black : grey,
      ),
    );
  }
}
