import "package:flutter/material.dart";
import "package:login_signup_frontend/common/widgets/button/basic_button.dart";
import "package:login_signup_frontend/features/auth/presentation/screens/signin.dart";
import "package:login_signup_frontend/features/auth/presentation/screens/signup.dart";

class WelcomePage extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => WelcomePage());
  const WelcomePage({super.key});

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

              const SizedBox(height: 50),

              // welcome back, you've been missed!
              Text(
                'Welcome back you\'ve been missed!',
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),

              const SizedBox(height: 25),

              //sign up
              BasicButton(
                onPressed: () {
                  Navigator.push(context, SignUpPage.route());
                },
                title: 'Sign Up',
              ),

              const SizedBox(height: 25),

              //sign in
              BasicButton(
                onPressed: () {
                  Navigator.push(context, SignInPage.route());
                },
                title: 'Sign In',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
