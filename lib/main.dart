import 'package:flutter/material.dart';
import 'package:flutter_application_1/check-out/provider/check_out.dart';
import 'package:flutter_application_1/settlin/settlin.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CheckOutProvider()),
      ],
      child: const Settlin(),
    ),
  );
}
