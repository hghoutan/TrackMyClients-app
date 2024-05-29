import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackmyclients_app/src/admin/domain/controllers/auth_controller.dart';
import 'package:trackmyclients_app/src/admin/presentation/views/auth/forgot_password.dart';
import 'package:trackmyclients_app/src/admin/presentation/views/auth/register/admin_register.dart';
import 'package:trackmyclients_app/src/admin/presentation/views/main_screen.dart';
import 'package:trackmyclients_app/src/client/presentation/views/client_login.dart';

import '../../../../utils/functions/next_screen.dart';
import '../../../../utils/images.dart';
import '../../widgets/main_button.dart';
import '../../widgets/text_input.dart';
import '../home.dart';

class AdminLoginScreen extends ConsumerWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    var auth = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xff161966),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .3,
            width: double.infinity,
            child: const Stack(alignment: Alignment.center, children: [
              Positioned(
                  top: 0,
                  left: 0,
                  child: Image(
                    image: AssetImage(Images.loginEllipse01),
                  )),
              Positioned(
                  top: 0,
                  left: 0,
                  child: Image(
                    image: AssetImage(Images.loginEllipse03),
                    width: 350,
                  )),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image(
                        image: AssetImage(Images.appWhiteLogo),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0))),
              child: Form(
                key: loginFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 6),
                        child: Text("Se connecter",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.black)),
                      ),
                      const SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: CustomTextInput(
                          controller: emailController,
                          hintText: "Email/ Telephone",
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir votre email ou numéro de téléphone.';
                            }
                            return null;
                          },
                          onChanged: (value) {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: CustomTextInput(
                          controller: passwordController,
                          hintText: "Mot de passe",
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir votre mot de passe.';
                            }

                            return null;
                          },
                          onChanged: (value) {},
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            nextScreenAnimation(
                                context, const ForgotPasswordPage());
                          },
                          child: Text(
                            "Mot de passe oublié ?",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      MainButtonWidget(
                        onPressed: () async {
                          if (loginFormKey.currentState!.validate()) {
                            String msg = await auth.signIn(context,
                                emailController.text, passwordController.text);

                            if (msg != 'Login successful') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(msg)));
                              return;
                            }
                            if (!auth.isEmailVerified()) {
                              msg = 'Please verify your email';
                            } else {
                              nextScreenAnimation(context, const MainScreen());
                              return;
                            }

                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(msg)));
                          }
                          // AuthService().verifyPhoneNumber('+212707347562');
                          // nextScreenAnimation(context, const SizedBox());
                        },
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        text: 'Se connecter',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Vous n'avez pas de compte ?",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: const Color(0xff98A2B3),
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      nextScreenAnimation(
                                          context, const AdminRegisterScreen());
                                    },
                                    child: Text(
                                      "S’inscrire",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              children: [
                                const Expanded(
                                    child: Divider(
                                        height: 1, color: Color(0xffCBD5E1))),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0),
                                  child: Text("Ou se connecter avec",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: const Color(0xff64748B),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          )),
                                ),
                                const Expanded(
                                    child: Divider(
                                        height: 1, color: Color(0xffCBD5E1))),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TextButton.icon(
                                    label: Text(
                                      'Google',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              color: const Color(0xff64748B),
                                              fontWeight: FontWeight.w500),
                                    ),
                                    icon: Image.asset(
                                      Images.googleIcon,
                                      width: 20,
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0, horizontal: 32.0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(32.0),
                                          side: const BorderSide(
                                              color: Color(0xffCBD5E1))),
                                    ),
                                    onPressed: () async {
                                      await auth.signInWithGoogle(context);
                                    },
                                  ),
                                ),
                                Platform.isIOS
                                    ? const SizedBox(width: 12.0)
                                    : const SizedBox.shrink(),
                                Platform.isIOS
                                    ? Expanded(
                                        child: TextButton.icon(
                                          label: Text(
                                            'Apple',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                    color:
                                                        const Color(0xff64748B),
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          icon: Image.asset(
                                            Images.appleIcon,
                                            width: 20,
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16.0,
                                                horizontal: 32.0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(32.0),
                                                side: const BorderSide(
                                                    color: Color(0xffCBD5E1))),
                                          ),
                                          onPressed: () async {},
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Vous êtes un client ?",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: const Color(0xff98A2B3),
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      
                                      nextScreenAnimation(
                                          context, const ClientLoginScreen());
                                    },
                                    child: Text(
                                      "Se connecter d'ici",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
