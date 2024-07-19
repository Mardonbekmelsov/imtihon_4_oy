import 'package:flutter/material.dart';
import 'package:imtihon_4_oy/services/firebase_auth_services.dart';
import 'package:imtihon_4_oy/views/screens/create_account_screen.dart';
import 'package:imtihon_4_oy/views/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();
  final _passwordConfirmController = TextEditingController();

  String? email, password, passwordConfirm;
  bool isLoading = false;

  void submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });

      try {
        await firebaseAuthServices.signUp(email!, password!);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (ctx) {
              return CreateAccountScreen();
            },
          ),
        );
      } catch (e) {
        String message = e.toString();
        if (e.toString().contains("EMAIL_EXISTS")) {
          message = "Email already exists";
        }

        if (!mounted) return;

        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(message),
            );
          },
        );
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your email";
                  }

                  return null;
                },
                onSaved: (newValue) {
                  //? save email
                  email = newValue;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your password";
                  }

                  return null;
                },
                onSaved: (newValue) {
                  //? save password
                  password = newValue;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _passwordConfirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Verify Password",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please verify password";
                  }

                  if (_passwordController.text !=
                      _passwordConfirmController.text) {
                    return "Password not verifyed";
                  }

                  return null;
                },
                onSaved: (newValue) {
                  //? save password confirm
                  passwordConfirm = newValue;
                },
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : FilledButton(
                      onPressed: submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Sign Up"),
                    ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) {
                            return const LoginScreen();
                          },
                        ),
                      );
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.deepPurple,
                      ),
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
}
