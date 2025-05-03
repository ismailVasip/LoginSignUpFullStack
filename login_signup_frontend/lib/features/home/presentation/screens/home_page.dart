import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_signup_frontend/common/bloc/button/cubit/button_cubit.dart';
import 'package:login_signup_frontend/common/widgets/button/basic_button.dart';
import 'package:login_signup_frontend/features/auth/presentation/screens/welcome.dart';
import 'package:login_signup_frontend/features/home/domain/usecases/logout.dart';
import 'package:login_signup_frontend/features/home/presentation/bloc/users_display_cubit.dart';
import 'package:login_signup_frontend/features/home/presentation/bloc/users_display_state.dart';
import 'package:login_signup_frontend/service_locator.dart';

class HomePage extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => HomePage());
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ButtonCubit, ButtonState>(
        listener: (context, state) {
          if (state is ButtonSuccessState) {
            alertDialogForLogout(context);
          } else if (state is ButtonFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Try again.'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/authentication.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: BasicButton(
                      onPressed: () {
                        context.read<UsersDisplayCubit>().fetchUsers();
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => buildSheet(),
                        );
                      },
                      title: 'Users',
                    ),
                  ),
                  Expanded(
                    child: BasicButton(
                      onPressed: () {
                        context.read<ButtonCubit>().execute(
                          usecase: serviceLocator<LogoutUseCase>(),
                        );
                      },
                      title: 'Logout',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> alertDialogForLogout(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Are you sure ?',
            style: TextStyle(
              fontSize: 19,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            SizedBox(
              height: 40,
              width: 65,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
              width: 65,
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(context, WelcomePage.route());
                },
                child: Center(
                  child: Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildSheet() => DraggableScrollableSheet(
    initialChildSize: 0.7,
    minChildSize: 0.3,
    maxChildSize: 0.9,
    builder:
        (_, controller) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: Colors.white,
          ),
          child: ListView(
            controller: controller,
            children: [
              BlocBuilder<UsersDisplayCubit, UsersDisplayState>(
                builder: (context, state) {
                  if (state is UsersLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is UsersLoadedState) {
                    final listOfUsers = state.listUsers;

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Full Name')),
                          DataColumn(label: Text('Email')),
                          DataColumn(
                            label: Text('Phone Number'),
                            numeric: true,
                          ),
                          DataColumn(label: Text('Is email verified?')),
                        ],
                        rows: [
                          for (var user in listOfUsers)
                            DataRow(
                              cells: [
                                DataCell(Text(user.fullName)),
                                DataCell(Text(user.email)),
                                DataCell(Text(user.phoneNumber)),
                                DataCell(Text(user.isEmailVerified.toString())),
                              ],
                            ),
                        ],
                      ),
                    );
                  }
                  if (state is LoadUsersFailureState) {
                    return SizedBox(
                      height: 100,
                      width: 300,
                      child: Center(
                        child: Text(
                          state.errorMessage,
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
  );
}
