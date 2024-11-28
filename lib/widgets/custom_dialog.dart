import 'package:ecomerce_app/colors.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color titleColor;
  final String message;
  final String primaryButtonLabel;
  final VoidCallback primaryButtonCallback;
  final String secondaryButtonLabel;
  final Color secondaryButtonColor;
  final VoidCallback secondaryButtonCallback;

  CustomDialog({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.titleColor,
    required this.message,
    required this.primaryButtonLabel,
    required this.primaryButtonCallback,
    required this.secondaryButtonLabel,
    required this.secondaryButtonColor,
    required this.secondaryButtonCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 400, // Set a fixed width here
            padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  message,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                secondaryButtonLabel != '' ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ElevatedButton(
                      onPressed: primaryButtonCallback,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white),
                      child: Text(primaryButtonLabel),
                    ),
                    ElevatedButton(
                      onPressed: secondaryButtonCallback,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryButtonColor,
                          foregroundColor: Colors.white),
                      child: Text(secondaryButtonLabel),
                    ),
                  ],
                ) : ElevatedButton(
                  onPressed: primaryButtonCallback,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white),
                  child: Text(primaryButtonLabel),
                ),
              ],
            ),
          ),
          Positioned(
            top: -30,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30.0,
              child: Icon(
                icon,
                color: iconColor,
                size: 60.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}