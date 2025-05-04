import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_signup_frontend/common/bloc/button/cubit/button_cubit.dart';
import 'package:login_signup_frontend/common/widgets/button/basic_auth_button.dart';
import 'package:login_signup_frontend/features/auth/data/models/forgot_password_params.dart';
import 'package:login_signup_frontend/features/auth/domain/usecases/forgot_password.dart';
import 'package:login_signup_frontend/features/auth/presentation/bloc/reset_password_cubit.dart';
import 'package:login_signup_frontend/features/auth/presentation/screens/verification_code.dart';
import 'package:login_signup_frontend/features/auth/presentation/widgets/my_textformfield.dart';
import 'package:login_signup_frontend/service_locator.dart';

class ForgotPasswordPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => ForgotPasswordPage());
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // text editing controllers
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ButtonCubit, ButtonState>(
        listener: (context, state) {
          if (state is ButtonSuccessState) {
            context.read<ResetPasswordCubit>().setEmail(state.email!);
            context.read<ResetPasswordCubit>().markEmailAsSent();
    
            Navigator.pushReplacement(context, VerificationCodePage.route());
          } else if (state is ButtonFailureState) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            var snackbar = SnackBar(
              backgroundColor: Colors.orange,
              content: Text(
                state.errorMessage,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          }
        },
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //logo
                Image.asset(
                  'assets/images/authentication.png',
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
    
                const SizedBox(height: 25),
    
                // Enter Email Address!
                Text(
                  'Enter Email Address',
                  style: TextStyle(color: Colors.grey[700], fontSize: 21),
                ),
    
                const SizedBox(height: 25),
    
                // email input
                MyTextformfield(
                  controller: emailController,
                  hintText: 'Email',
                  validator: null,
                  obscureText: false,
                ),
    
                const SizedBox(height: 25),
    
                // back to sign in link
                Align(
                  alignment: Alignment.center,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Back to sign in',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pop(context);
                                },
                        ),
                      ],
                    ),
                  ),
                ),
    
                const SizedBox(height: 25),
    
                //send email button
                Builder(
                  builder: (builderContext) {
                    return BasicAppButton(
                      onPressed: () {
                        final email = emailController.text.trim();
                        builderContext.read<ButtonCubit>().execute(
                          usecase: serviceLocator<ForgotPasswordUseCase>(),
                          params: ForgotPasswordParams(email: email),
                        );
                      },
                      title: 'Send',
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
