import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoreflash/screens/login_screen.dart';
import 'package:scoreflash/screens/matches_screen.dart';
import 'package:scoreflash/utils/auth.dart';
import 'package:scoreflash/utils/validator.dart';
import 'package:scoreflash/widgets/custom_form_field.dart';
import 'package:scoreflash/widgets/custom_text_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  bool _isRegistering = false;

  registerNow() async {
    _nameFocusNode.unfocus();
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();

    setState(() {
      _isRegistering = true;
    });

    if (_formKey.currentState!.validate()) {
      User? user = await Auth.registerWithMailAndPassword(
          name: _nameController.text,
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
      _isRegistering = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                CustomFormField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  inputAction: TextInputAction.next,
                  label: 'Name',
                  hint: 'Enter your name',
                  validator: (value) => Validator.validateName(name: value),
                ),
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
                  validator: (value) =>
                      Validator.validatePassword(password: value),
                ),
                const SizedBox(height: 20),
                _isRegistering
                    ? CircularProgressIndicator()
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: CustomTextButton(
                          label: 'Register',
                          bgColor: Colors.black,
                          textColor: Colors.white,
                          onCallBack: () => registerNow(),
                        ),
                      ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text("Log In"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
