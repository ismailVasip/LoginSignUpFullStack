import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_signup_frontend/common/bloc/button/cubit/button_cubit.dart';
import 'package:login_signup_frontend/common/widgets/button/basic_auth_button.dart';
import 'package:login_signup_frontend/features/auth/data/models/verify_code_params.dart';
import 'package:login_signup_frontend/features/auth/domain/usecases/verify_code.dart';
import 'package:login_signup_frontend/features/auth/presentation/bloc/reset_password_cubit.dart';
import 'package:login_signup_frontend/features/auth/presentation/screens/reset_password.dart';
import 'package:login_signup_frontend/features/auth/presentation/widgets/verif_code_part.dart';

class VerificationCodePage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => VerificationCodePage());
  const VerificationCodePage({super.key});

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  String verificationCode = '';
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: BlocListener<ButtonCubit, ButtonState>(
        listener: (context, state) {
          if (state is ButtonSuccessState) {
            Navigator.pushReplacement(context, ResetPasswordPage.route());
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
    
                // verification code!
                Text(
                  'Enter Verification Code',
                  style: TextStyle(color: Colors.grey[700], fontSize: 21),
                ),
    
                const SizedBox(height: 25),
    
                // input field for verification code
                OtpInput(
                  onCodeChanged: (code) {
                    setState(() {
                      verificationCode = code;
                    });

                  },
                ),
    
                const SizedBox(height: 25),
    
                //resend code
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'If you didn\'t receive a code, '),
                      TextSpan(
                        text: ' Resend',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
    
                const SizedBox(height: 25),
    
                //send button
                Builder(
                  builder: (builderContext) {
                    return BasicAppButton(
                      onPressed: () {
                        final email =
                            builderContext.read<ResetPasswordCubit>().state.email;

                        builderContext.read<ButtonCubit>().execute(
                          usecase: VerifyCodeUseCase(),
                          params: VerifyCodeParams(
                            email: email,
                            verificationCode: verificationCode,
                          ),
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
