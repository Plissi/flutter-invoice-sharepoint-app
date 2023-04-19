import 'package:flutter/material.dart';

class InvoiceDataCell extends StatelessWidget {
  final String data;
  final TextStyle? style;
  const InvoiceDataCell({Key? key, required this.data, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style,
    );
  }
}
