import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final String value;
  final List<String> items;
  final Function(String?) onChanged;

  const CustomDropdown({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white54,
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Color(0xfffffff),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
              value: item,
              child: CustomText(
                text: item,
                color: Colors.white54,
                fontSize: 15,
              ),
            ),
          )
              .toList(),
        ),
      ],
    );
  }
}



class CustomText extends StatelessWidget {
  CustomText({
    super.key,
    this.maxLines,
    this.textAlign = TextAlign.center,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.color = Colors.green,
    this.text = "",
    this.overflow = TextOverflow.fade,
    this.letterSpace,
    this.underline = false,
  });

  final double left;
  final double right;
  final double top;
  final double bottom;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final String text;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final dynamic letterSpace;
  final bool underline; // Boolean flag to decide whether to underline

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      child: Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: GoogleFonts.abhayaLibre(
          letterSpacing: letterSpace,
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          decorationColor: Colors.yellow,
          decoration: underline ? TextDecoration.underline : TextDecoration.none, // Conditionally apply underline
        ),
      ),
    );
  }
}