import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  CustomButton({super.key, required this.onPressed, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(buttonText),
        ),
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.all(Colors.white),
          foregroundColor: WidgetStateProperty.all(Colors.grey[800]),
        ));
  }
}

class CustomText extends StatelessWidget {
  final String text;
  CustomText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
