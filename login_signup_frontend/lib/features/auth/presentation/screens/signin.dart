import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => SignInPage());
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignInPage> {

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}