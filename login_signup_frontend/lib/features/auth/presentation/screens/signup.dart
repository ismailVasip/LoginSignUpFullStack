import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_signup_frontend/common/bloc/button/cubit/button_cubit.dart';
import 'package:login_signup_frontend/common/enums/gender.dart';
import 'package:login_signup_frontend/common/widgets/button/basic_auth_button.dart';
import 'package:login_signup_frontend/core/utils/validator.dart';
import 'package:login_signup_frontend/features/auth/data/models/signup_request_params.dart';
import 'package:login_signup_frontend/features/auth/domain/usecases/signup.dart';
import 'package:login_signup_frontend/features/auth/presentation/screens/signin.dart';
import 'package:login_signup_frontend/features/auth/presentation/widgets/birth_day_picker.dart';
import 'package:login_signup_frontend/features/auth/presentation/widgets/gender_field.dart';
import 'package:login_signup_frontend/features/auth/presentation/widgets/my_textformfield.dart';
import 'package:login_signup_frontend/features/auth/presentation/widgets/tel_no_field.dart';
import 'package:login_signup_frontend/features/home/presentation/screens/home_page.dart';
import 'package:login_signup_frontend/service_locator.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => SignUpPage());
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // text editing controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final birthDateController = TextEditingController();

  //form key
  final formKey = GlobalKey<FormState>();

  //Gender options
  // ignore: unused_field
  Gender _gender = Gender.unspecified;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneNumberController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  void createAccount(BuildContext builderContext, BuildContext buildContext) {}

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
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Form(
                  key: formKey,
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

                      // Let's create an account for you!
                      Text(
                        'Let\'s create an account for you!',
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),

                      const SizedBox(height: 25),

                      //form fields
                      Column(
                        spacing: 10,
                        children: [
                          MyTextformfield(
                            controller: fullNameController,
                            validator: Validators.validateFullName,
                            hintText: 'Full Name',
                            obscureText: false,
                          ),
                          MyTextformfield(
                            controller: emailController,
                            hintText: 'Email',
                            validator: Validators.validateEmail,
                            obscureText: false,
                          ),
                          MyTextformfield(
                            controller: passwordController,
                            hintText: 'Password',
                            validator: Validators.validatePassword,
                            obscureText: true,
                          ),
                          MyTextformfield(
                            controller: confirmPasswordController,
                            hintText: 'Confirm Password',
                            validator: null,
                            obscureText: true,
                          ),
                          //tel-no,
                          TelephoneNumberField(
                            phoneNumberController: phoneNumberController,
                            validator: Validators.validatePhoneNumber,
                          ),

                          //gender
                          GenderField(
                            onSelected: (value) {
                              setState(() {
                                if (value != null) {
                                  _gender = value;
                                }
                              });
                            },
                          ),

                          //birth date
                          BirthDayPicker(
                            birthDateController: birthDateController,
                            validator: Validators.validateDateBirth,
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      //sign up button
                      Builder(
                        builder: (builderContext) {
                          return BasicAppButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                final password = passwordController.text.trim();
                                final confirmPassword =
                                    confirmPasswordController.text.trim();

                                if (password != confirmPassword) {
                                  ScaffoldMessenger.of(
                                    builderContext,
                                  ).showSnackBar(
                                    const SnackBar(
                                      content: Text('Passwords do not match.'),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                  return;
                                }

                                final fullName = fullNameController.text.trim();
                                final email = emailController.text.trim();
                                final phoneNumber =
                                    phoneNumberController.text.trim();
                                final birthDate =
                                    birthDateController.text.trim();
                                final gender = _gender.value;

                                builderContext.read<ButtonCubit>().execute(
                                  usecase: serviceLocator<SignUpUseCase>(),
                                  params: SignUpRequestParams(
                                    fullName: fullName,
                                    email: email,
                                    password: password,
                                    confirmPassword: confirmPassword,
                                    gender: gender,
                                    phoneNumber: phoneNumber,
                                    birthDate: birthDate,
                                    roles: ['User'],
                                  ),
                                );
                              }
                            },
                            title: 'Sign Up',
                          );
                        },
                      ),

                      const SizedBox(height: 25),

                      //already have an account?
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: 'Already have an account? '),
                            TextSpan(
                              text: 'Login now',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacement(
                                        context,
                                        SignInPage.route(),
                                      );
                                    },
                            ),
                          ],
                        ),
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
