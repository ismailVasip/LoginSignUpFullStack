import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_signup_frontend/common/bloc/button/cubit/button_cubit.dart';

class BasicAppButton extends StatelessWidget {
  final Function()? onPressed;
  final String title;
  final double? height;
  final double? width;
  const BasicAppButton({
    required this.onPressed,
    this.title = '',
    this.height,
    this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: BlocBuilder<ButtonCubit,ButtonState>(
        builder: (context, state) {
          if (state is ButtonLoadingState){
            return _loading(context);
          }
          return _initial(context);
        },
      ),
    );
  }

  Widget _initial(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        minimumSize: Size(
          width ?? MediaQuery.of(context).size.width,
          height ?? 80,
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 21,
        ),
      ),
    );
  }

  Widget _loading(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        minimumSize: Size(
          width ?? MediaQuery.of(context).size.width,
          height ?? 80,
        ),
      ),
      child: const CircularProgressIndicator(color: Colors.white),
    );
  }
}
