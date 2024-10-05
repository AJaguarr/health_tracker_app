import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:itoju_mobile/core/colors/colors.dart';
import 'package:itoju_mobile/features/widgets/utills.dart';
import 'package:itoju_mobile/main.dart';

class AlertFlushbar {
  static void showNotification({
    bool isWarning = false,
    String message = '',
  }) {
    final context = navigatorKey.currentContext;
    context != null
        ? Flushbar(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
            margin: EdgeInsets.all(8.r),
            borderRadius: BorderRadius.circular(8.r),
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.FLOATING,
            reverseAnimationCurve: Curves.decelerate,
            forwardAnimationCurve: Curves.elasticOut,
            backgroundColor:
                isWarning ? Colors.red : AppColors.primaryColorPurple,
            isDismissible: true,
            duration: const Duration(seconds: 4),
            showProgressIndicator: false,
            boxShadows: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.5),
                offset: const Offset(0.0, 2.0),
                blurRadius: 3.0,
              ),
            ],
            icon: isWarning
                ? Container(
                    margin: const EdgeInsets.only(left: 10),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        color: Colors.transparent,
                        shape: BoxShape.circle),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  )
                : const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                  ),
            message: message,
            messageColor: Colors.white,
            messageSize: 18,
          ).show(context)
        : 0.ph;
  }
}

getAlert(String msg, {bool isWarning = true}) {
  AlertFlushbar.showNotification(
    isWarning: isWarning,
    message: msg,
  );
}
