import 'package:flutter/material.dart';
import 'package:itoju_mobile/core/colors/colors.dart';
import 'package:itoju_mobile/features/widgets/custom_button.dart';
import 'package:itoju_mobile/features/widgets/custom_text.dart';
import 'package:itoju_mobile/features/widgets/margins.dart';
// import 'package:itojume/utils/colors.dart';
// import 'package:itojume/utils/margins.dart';
// import 'package:itojume/widgets/custom_button.dart';
// import 'package:itojume/widgets/custom_text.dart';

class ErrorDialog extends StatelessWidget {
  final String? error;
  const ErrorDialog({Key? key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText(
                  "Error!",
                  color: AppColors.primaryColorPurple,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ],
            ),
            verticalSpaceMedium,
            CustomText(
              error,
              color: Colors.black,
              fontSize: 14,
            ),
            verticalSpaceLarge,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const CustomText(
                    "Ok",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  buttonStyle: buttonStyle(buttonWidth: 70, radius: 10),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
