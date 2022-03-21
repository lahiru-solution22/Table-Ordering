import 'package:dropin_pos/widgets/rounded_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config.dart';
import '../../constants/style.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/rounded_text_form_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool passwordVisibility = false;
  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Image.asset("assets/icons/logo.png"),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text("Login",
                        style: GoogleFonts.roboto(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    CustomText(
                      text: "Welcome back to the admin panel.",
                      color: lightGrey,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                RoundedTextFormField(
                  controller: _emailController,
                  labelText: "Email",
                  hintText: "abc@domain.com",
                  validator: (value) {
                    bool _isEmailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value!);
                    if (!_isEmailValid) {
                      return 'Invalid email.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                RoundedTextFormField(
                  controller: _passwordController,
                  labelText: "Password",
                  hintText: "Password",
                  obscureText: !passwordVisibility,
                  validator: (value) {
                    if (value.toString().length < 6) {
                      return 'Password should be atleast 6 characters long';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisibility
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () => {
                      setState(
                        () {
                          passwordVisibility = !passwordVisibility;
                        },
                      ),
                    },
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  height: Config.screenHeight! * 0.06,
                  width: Config.screenWidth! * 0.3,
                  child: RoundedElevatedButton(
                    title: 'Sign In',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        String email = _emailController.text.trim();
                        String password = _passwordController.text;

                        _authController.signIn(email, password);
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
