import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInput extends StatefulWidget {
  final ValueChanged<String> onCodeChanged;
  const OtpInput({super.key, required this.onCodeChanged});

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, color: Colors.black),
            decoration: const InputDecoration(
              counterText: '', // Remove the counter text
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              if (value.length == 1) {
                if (index < 3) {
                  _focusNodes[index + 1].requestFocus();
                } else {
                  _focusNodes[index].unfocus();
                }
              }
              Future.delayed(Duration(milliseconds: 50), () {
                final code = _controllers.map((c) => c.text).join();
                if (code.length == 4) {
                  widget.onCodeChanged(code);
                }
              });
              
            },
          ),
        );
      }),
    );
  }
}
