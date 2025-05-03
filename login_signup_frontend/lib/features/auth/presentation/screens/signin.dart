import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_signup_frontend/common/bloc/button/cubit/button_cubit.dart';
import 'package:login_signup_frontend/common/widgets/button/basic_auth_button.dart';
import 'package:login_signup_frontend/features/auth/data/models/signin_request_params.dart';
import 'package:login_signup_frontend/features/auth/domain/usecases/signin.dart';
import 'package:login_signup_frontend/features/auth/presentation/widgets/my_textformfield.dart';
import 'package:login_signup_frontend/features/home/presentation/screens/home_page.dart';
import 'package:login_signup_frontend/service_locator.dart';

class SignInPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => SignInPage());
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignInPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ButtonCubit(),
        child: BlocListener<ButtonCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonSuccessState) {
              Navigator.pushReplacement(context, HomePage.route());
            }
            if (state is ButtonFailureState) {
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

                  // sign in!
                  Text(
                    'Sign In',
                    style: TextStyle(color: Colors.grey[700], fontSize: 19),
                  ),

                  const SizedBox(height: 25),

                  // email input
                  MyTextformfield(
                    controller: emailController,
                    hintText: 'Email',
                    validator: null,
                    obscureText: false,
                  ),

                  const SizedBox(height: 15),

                  // password input
                  MyTextformfield(
                    controller: passwordController,
                    hintText: 'Password',
                    validator: null,
                    obscureText: true,
                  ),

                  const SizedBox(height: 25),

                  // forgot password link
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(right: 25),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Forgot Password',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                                fontSize: 17
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  //sign in button
                  Builder(
                    builder: (builderContext) {
                      return BasicAppButton(onPressed: () {
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();

                        builderContext.read<ButtonCubit>().execute(
                          usecase: serviceLocator<SignInUseCase>(),
                          params: SignInRequestParams(email: email, password: password)
                        );
                      }, title: 'Sign In');
                    }
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
