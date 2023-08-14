import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoreflash/screens/matches_screen.dart';
import 'package:scoreflash/screens/register_screen.dart';
import 'package:scoreflash/utils/auth.dart';
import 'package:scoreflash/utils/validator.dart';
import 'package:scoreflash/widgets/custom_form_field.dart';
import 'package:scoreflash/widgets/custom_text_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  bool _isLoging = false;

  loginNow() async {
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();

    setState(() {
      _isLoging = true;
    });

    if (_formKey.currentState!.validate()) {
      User? user = await Auth.loginInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
          context: context);

      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MatchesScreen(),
          ),
        );
      }
    }

    setState(() {
      _isLoging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomFormField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            inputAction: TextInputAction.next,
            label: 'Email',
            hint: 'Enter your email',
            validator: (value) => Validator.validateEmail(email: value),
          ),
          CustomFormField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            keyboardType: TextInputType.emailAddress,
            inputAction: TextInputAction.next,
            label: 'Password',
            hint: 'Enter your password',
            isObscure: true,
            validator: (value) => Validator.validatePassword(password: value),
          ),
          const SizedBox(height: 20),
          _isLoging
              ? const CircularProgressIndicator()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: CustomTextButton(
                    label: 'Login',
                    bgColor: Colors.black,
                    textColor: Colors.white,
                    onCallBack: () => loginNow(),
                  ),
                ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text("Don't have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text("Register"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}