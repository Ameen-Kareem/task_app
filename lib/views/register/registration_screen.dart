import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/blocs/register/register_bloc.dart';
import 'package:task_app/utils/color_utils.dart';
import 'package:task_app/views/home/home_screen.dart';
import 'package:task_app/views/login/login_screen.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterBloc>().add(
        RegistrationEvent(
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
        child: SingleChildScrollView(
          child: BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state is EmailAlreadyInUseState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Email already in use!")),
                );
              } else if (state is PasswordWeakSTate) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Password is weak!\nTry a stronger password"),
                  ),
                );
              } else if (state is RegistrationFailedState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Registration faild due to  ${state.error} Exception",
                    ),
                  ),
                );
              } else if (state is RegistrationSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              }
            },
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Text(
                    "Create your new Account ",
                    style: TextStyle(
                      fontSize: 30,
                      color: ColorConstants.TXTCOLOR,
                    ),
                  ),
                  SizedBox(height: 100),
                  TextFormField(
                    controller: _nameController,
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
                      labelText: "Name",
                      prefixIcon: Icon(Icons.person, size: 20),
                    ),
                    validator:
                        (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Name is required'
                                : null,
                  ),
                  SizedBox(height: 16),
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
                      prefixIcon: Icon(Icons.email, size: 20),
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
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock, size: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6)
                        return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    obscureText: true,
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
                      labelText: "Confirm Password",
                      prefixIcon: Icon(Icons.lock, size: 20),
                    ),
                    validator: (value) {
                      if (value == null || value != _passwordController.text)
                        return 'Passwords dont\'t match';
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: _isSubmitting ? null : _submitForm,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: ColorConstants.PRIMARYCOLOR,
                      ),
                      width: double.infinity,
                      height: 50,
                      alignment: Alignment.center,
                      child:
                          _isSubmitting
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                "Register",
                                style: TextStyle(
                                  color: ColorConstants.TXTCOLOR,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                  SizedBox(height: 16),
                  InkWell(
                    onTap:
                        () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        ),
                    child: Text(
                      "Already have an Account?",
                      style: TextStyle(color: ColorConstants.HYPERLINK),
                    ),
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
