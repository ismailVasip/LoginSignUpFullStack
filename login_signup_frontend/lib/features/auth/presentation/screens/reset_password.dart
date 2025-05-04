import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_signup_frontend/common/bloc/button/cubit/button_cubit.dart';
import 'package:login_signup_frontend/common/widgets/button/basic_auth_button.dart';
import 'package:login_signup_frontend/core/utils/validator.dart';
import 'package:login_signup_frontend/features/auth/data/models/reset_password_params.dart';
import 'package:login_signup_frontend/features/auth/domain/usecases/reset_password.dart';
import 'package:login_signup_frontend/features/auth/presentation/bloc/reset_password_cubit.dart';
import 'package:login_signup_frontend/features/auth/presentation/screens/signin.dart';
import 'package:login_signup_frontend/features/auth/presentation/widgets/my_textformfield.dart';

class ResetPasswordPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => ResetPasswordPage());
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  // text editing controllers
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //form key
  final _formKey = GlobalKey<FormState>();

  final storage = const FlutterSecureStorage();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ButtonCubit, ButtonState>(
        listener: (context, state) {
          if (state is ButtonSuccessState) {
            storage.delete(key: 'reset_token');
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            var snackbar = SnackBar(
              backgroundColor: Colors.orange,
              content: Text(
                'Password updated. You can login now.',
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            Navigator.pushReplacement(context, SignInPage.route());
            
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
            child: Form(
              key: _formKey,
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
                    validator: Validators.validatePassword,
                    hintText: 'New Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 25),

                  // confirm password input
                  MyTextformfield(
                    controller: confirmPasswordController,
                    validator: Validators.validatePassword,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 25),

                  //send email button
                  Builder(
                    builder: (builderContext) {
                      return BasicAppButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final newPassword =
                                newPasswordController.text.trim();
                            final confirmPassword =
                                confirmPasswordController.text.trim();

                            if (newPassword != confirmPassword) {
                              ScaffoldMessenger.of(builderContext).showSnackBar(
                                const SnackBar(
                                  content: Text('Passwords do not match.'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }

                            final email =
                                builderContext
                                    .read<ResetPasswordCubit>()
                                    .state
                                    .email;

                            
                            var resetToken = await storage.read(
                              key: 'reset_token',
                            );

                            builderContext.read<ButtonCubit>().execute(
                              usecase: ResetPasswordUseCase(),
                              params: ResetPasswordParams(
                                email: email,
                                token: resetToken!,
                                password: newPassword,
                                confirmPassword: confirmPassword,
                              ),
                            );
                          }
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
      ),
    );
  }
}
