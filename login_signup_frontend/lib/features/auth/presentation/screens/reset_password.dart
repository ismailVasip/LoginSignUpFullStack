import 'package:flutter/material.dart';
import 'package:login_signup_frontend/common/widgets/button/basic_auth_button.dart';
import 'package:login_signup_frontend/features/auth/presentation/widgets/my_textformfield.dart';

class ResetPasswordPage extends StatefulWidget {
  static route()=>MaterialPageRoute(builder: (context) => ResetPasswordPage());
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  // text editing controllers
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Image.asset(
                'assets/images/authentication.png',
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),

              const SizedBox(height: 25),

              // Reset Password!
              Text(
                'Reset Password',
                style: TextStyle(color: Colors.grey[700], fontSize: 21),
              ),

              const SizedBox(height: 25),

              // new password input
              MyTextformfield(
                controller: newPasswordController,
                hintText: 'New Password',
                validator: null,
                obscureText: true,
              ),

              const SizedBox(height: 25),

              // confirm password input
              MyTextformfield(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                validator: null,
                obscureText: true,
              ),

              const SizedBox(height: 25),

              //send email button
              BasicAppButton(onPressed: () {}, title: 'Send'),
            ],
          ),
        ),
      ),
    );
  }
}
