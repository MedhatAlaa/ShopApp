import 'package:flutter/material.dart';

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );

void navigateAndFinish(context, widget) => Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder:(context)=>widget),
    );

Widget defaultFormField({
  required TextEditingController controller,
  FormFieldValidator<String>? validator,
  ValueChanged<String>? onChange,
  required  TextInputType keyboardType,
  required bool obscureText,
  required Widget prefixIcon,
  required String? labelText,
  Widget? suffixIcon,
})=>TextFormField(
  controller: controller,
  validator:validator ,
  onChanged: onChange,
  keyboardType:keyboardType ,
  obscureText:obscureText ,
  decoration: InputDecoration(
    prefixIcon:prefixIcon,
    suffixIcon:suffixIcon ,
    labelText:labelText ,
    border: const OutlineInputBorder()
  ),
);