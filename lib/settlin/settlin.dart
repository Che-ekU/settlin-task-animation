import 'package:flutter/material.dart';
import 'package:flutter_application_1/check-out/ui/check_out.dart';

class Settlin extends StatelessWidget {
  const Settlin({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CheckOutPage(),
    );
  }
}
