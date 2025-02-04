import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ttm/Comman_pages/Constant.dart';

class DialogUtils {
  static void showSuccessDialog(BuildContext context, String message,
      {VoidCallback? onOk}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 300), // Smooth animation
      pageBuilder: (context, anim1, anim2) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          title: Column(
            children: [
              // Circle with a tick inside
              Container(
                width: 80, // Increased circle size
                height: 80, // Increased circle size
                decoration: BoxDecoration(
                  color: Colors.green, // Circle color
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.check, color: Colors.white, size: 50), // Smaller tick
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
          content: Text(message, textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onOk != null) onOk();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.concolor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('OK', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(scale: anim1, child: child); // Pop-up animation
      },
    );
  }
}
