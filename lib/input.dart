import 'package:flutter/material.dart';

Widget makeInput({required TextEditingController txtInpctrl, label, obsureText = false})
{
  return Column(crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text( label, style:
            const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      const SizedBox(height: 5,),
      TextField(
        controller: txtInpctrl, // tambahan utk menerima inputan
        obscureText: obsureText,
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[400]!,
            ),
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!)),
        ),
      ),
      const SizedBox(
        height: 30,
      ),
    ],
  );
}
