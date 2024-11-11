import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:syncspace/constants.dart';
import 'package:syncspace/controllers/user.controller.dart';
import 'package:syncspace/models/api.response.model.dart';
import 'package:syncspace/provider/theme.provider.dart';
import 'package:syncspace/provider/user.provider.dart';
import 'package:syncspace/widgets/customAppBar.widget.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final formKey = GlobalKey<FormState>();

  var isLogin = false;

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(label: 'Authentication'),
      body: Center(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.75,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.sizeOf(context).height * 0.10,
                ),
                child: Text(
                  isLogin ? 'Login' : 'Register',
                  style: const TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if (!isLogin)
                        Column(
                          children: [
                            userNameTextField(context),
                            const SizedBox(height: 16.0),
                          ],
                        ),
                      emailTextField(context),
                      const SizedBox(height: 16.0),
                      passwordTextField(context),
                    ],
                  ),
                ),
              ),
              formSubmitButton(context),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLogin
                        ? "Don't have an account? "
                        : 'Already have an account? ',
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLogin = isLogin ? false : true;
                      });
                    },
                    child: Text(
                      isLogin ? 'Register' : 'Login',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
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

  InputDecoration decorationForTextFormField(
    BuildContext context,
    String label,
  ) {
    return InputDecoration(
      label: Text(label),
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  TextFormField userNameTextField(BuildContext context) {
    return TextFormField(
      controller: userNameController,
      cursorColor: Theme.of(context).colorScheme.primary,
      keyboardType: TextInputType.name,
      decoration: decorationForTextFormField(context, 'Username'),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Enter username';
        }
        return null;
      },
    );
  }

  TextFormField emailTextField(BuildContext context) {
    return TextFormField(
      controller: emailController,
      cursorColor: Theme.of(context).colorScheme.primary,
      keyboardType: TextInputType.emailAddress,
      decoration: decorationForTextFormField(context, 'E-mail'),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Enter e-mail';
        }
        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
          return 'Enter a valid e-mail';
        }
        return null;
      },
    );
  }

  TextFormField passwordTextField(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      cursorColor: Theme.of(context).colorScheme.primary,
      keyboardType: TextInputType.visiblePassword,
      decoration: decorationForTextFormField(context, 'Password'),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Enter password';
        }
        return null;
      },
    );
  }

  MaterialButton formSubmitButton(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          FocusManager.instance.primaryFocus?.unfocus();
          // formKey.currentState!.save();
          final User user = User();
          APIResponse response;
          if (isLogin) {
            response = await user.login(
              emailController.text,
              passwordController.text,
            );
          } else {
            response = await user.register(
              userNameController.text,
              emailController.text,
              passwordController.text,
            );
          }
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  response.message!,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor:
                    response.statusCode == 200 ? Colors.green : Colors.red[400],
              ),
            );

            if (response.statusCode == 200) {
              String userDataInString = response.responseData.toString();
              Provider.of<UserProvider>(context, listen: false).setUser(
                AuthAPIResponse.fromJson(jsonDecode(userDataInString)),
              );

              GoRouter.of(context).goNamed(AppRouteConstants.home);
            }
          }
        }
      },
      color: Theme.of(context).colorScheme.primary,
      child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Consumer<ThemeProvider>(builder: (
            context,
            themeProvider,
            child,
          ) {
            return Text(
              isLogin ? 'LOGIN' : 'REGISTER',
              style: TextStyle(
                color: themeProvider.theme == 3 ? Colors.black : Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            );
          })),
    );
  }
}
