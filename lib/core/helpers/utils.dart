import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension EmptyPadding on num {
  SizedBox get sbh => SizedBox(height: toDouble().h);
  SizedBox get sbw => SizedBox(width: toDouble().w);
}

bool isEmailValid(String email) {
  // Define a regex pattern for a valid email address
  const String emailPattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
  final RegExp regex = RegExp(emailPattern);
  return regex.hasMatch(email);
}
