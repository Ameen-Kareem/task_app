import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/blocs/login/login_bloc.dart';
import 'package:task_app/global_widgets/popup_msg.dart';
import 'package:task_app/utils/color_utils.dart';
import 'package:task_app/views/home/home_screen.dart';
import 'package:task_app/views/register/registration_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoggingIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
        LoginAttemptEvent(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.BgYELLOW,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccessState) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            } else if (state is LoginFailedState) {
              PopupMsg.popUpMsg(
                msg: "Login failed due to ${state.error} Exception",
                context: context,
              );
            } else if (state is EmailNotFoundState) {
              PopupMsg.popUpMsg(msg: "Email not in use!", context: context);
            } else if (state is WrongPasswordState) {
              PopupMsg.popUpMsg(msg: "Wrong Password", context: context);
            }
          },
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              children: [
                SizedBox(height: 40),
                Text("Login to\nYour Account", style: TextStyle(fontSize: 30)),
                SizedBox(height: 100),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    fillColor: ColorConstants.TXTFLDFILL,
                    filled: true,
                    labelStyle: TextStyle(color: ColorConstants.TXTCOLOR),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorConstants.FOCUSEDTEXTFIELDBORDERS,

                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorConstants.FOCUSEDTEXTFIELDBORDERS,

                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorConstants.TEXTFIELDBORDERS,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: "Email",
                    prefixIcon: Icon(
                      Icons.email,
                      size: 20,
                      color: ColorConstants.ICONCOLOR,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Email is required';
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value))
                      return 'Enter a valid email';
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    fillColor: ColorConstants.TXTFLDFILL,

                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorConstants.FOCUSEDTEXTFIELDBORDERS,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorConstants.FOCUSEDTEXTFIELDBORDERS,

                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorConstants.TEXTFIELDBORDERS,

                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: "Password",
                    prefixIcon: Icon(
                      Icons.lock,
                      size: 20,
                      color: ColorConstants.ICONCOLOR,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6)
                      return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: _isLoggingIn ? null : _login,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: ColorConstants.PRIMARYCOLOR,
                    ),
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    child:
                        _isLoggingIn
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                              "Login",
                              style: TextStyle(
                                color: Color(0xff212121),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap:
                        () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistrationPage(),
                          ),
                        ),
                    child: Text(
                      "Don't have an Account ?",
                      style: TextStyle(color: ColorConstants.HYPERLINK),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
