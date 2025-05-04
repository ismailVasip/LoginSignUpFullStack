import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_signup_frontend/common/bloc/auth/auth_cubit.dart';
import 'package:login_signup_frontend/common/bloc/button/cubit/button_cubit.dart';
import 'package:login_signup_frontend/core/configs/theme/app_theme.dart';
import 'package:login_signup_frontend/features/auth/presentation/bloc/reset_password_cubit.dart';
import 'package:login_signup_frontend/features/auth/presentation/screens/welcome.dart';
import 'package:login_signup_frontend/features/home/presentation/bloc/users_display_cubit.dart';
import 'package:login_signup_frontend/features/home/presentation/screens/home_page.dart';
import 'package:login_signup_frontend/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
    ),
  );
  setUpServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthStateCubit()..appStarted()),
        BlocProvider(create: (context) => UsersDisplayCubit()),
        BlocProvider(create: (context) => ButtonCubit()),
        BlocProvider(create: (context) => ResetPasswordCubit())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        home: BlocBuilder<AuthStateCubit, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return HomePage();
            } else if (state is Unauthenticated) {
              return WelcomePage();
            }
            return Container();
          },
        ),
      ),
    );
  }
}
