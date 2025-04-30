import "package:flutter/material.dart";

class BasicWelcomeButton extends StatelessWidget {
  final Function()? onPressed;
  final String title;
  const BasicWelcomeButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          minimumSize: Size(
            MediaQuery.of(context).size.width,
            80,
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 21,
          ),
        ),
      ),
    );
  }
}
