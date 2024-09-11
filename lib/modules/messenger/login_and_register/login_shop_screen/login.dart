import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iti_project/modules/messenger/login_and_register/login_shop_screen/cubit/login_screen_cubit.dart';
import 'package:iti_project/modules/messenger/login_and_register/login_shop_screen/cubit/states.dart';
import '../../../../services/authentication/auth_service.dart';
import '../../../../shared/componants.dart';
import '../register_shop_screen/register.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  var emailController = TextEditingController();
  var userKey = GlobalKey<FormState>();
  var passKey = GlobalKey<FormState>();
  var passController = TextEditingController();

  login(context) async {
    final fireBaseInstance = AuthService();
    try {
      await fireBaseInstance.signInWithEmailAndPassword(
          email: emailController.text, password: passController.text);
      defaultToast("login in successful", Colors.green);
    } catch (e) {
      defaultToast("user name or password is incorrect", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        builder: (context, state) {
          LoginCubit cubit = LoginCubit.get(context);
          // CashHelper.setData('onboarding', true);
          return GestureDetector(
            onTap: () {
              LoginCubit cubit = LoginCubit.get(context);
              if (cubit.fromEmail) {
                if (userKey.currentState!.validate()) {
                  cubit.changeColorOfEmailLabel(Colors.grey);
                } else {
                  cubit.changeColorOfEmailLabel(Colors.red);
                }
              }
              if (cubit.fromPass) if (passKey.currentState!.validate()) {
                cubit.changeColorOfPassLabel(Colors.grey);
              } else {
                cubit.changeColorOfPassLabel(Colors.red);
              }
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                surfaceTintColor: Colors.white,
                shadowColor: Colors.white,
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              fontFamily: "jannah"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Login now to contact with friends",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontFamily: "jannah"),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Form(
                          key: userKey,
                          child: defaultTextFormField(
                            control: emailController,
                            labelText: "Email Address",
                            prefixIcon: Icons.email_outlined,
                            suffixIcon: cubit.colorOfEmailLabel == Colors.red
                                ? Icons.error
                                : null,
                            colorOfSuffixIcon: Colors.red,
                            colorOfPrefixIcon: Colors.grey,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "please enter your email address";
                              }
                            },
                            keyboard: TextInputType.emailAddress,
                            onTap: () {
                              cubit.changeFromEmail(true);
                              if (cubit.fromPass &&
                                  passKey.currentState!.validate()) {
                                cubit.changeColorOfPassLabel(Colors.grey);
                                cubit.changeFromEmail(false);
                              } else if (cubit.fromPass)
                                cubit.changeColorOfPassLabel(Colors.red);
                              else {
                                cubit.changeFromPass(false);
                                cubit.changeColorOfPassLabel(Colors.grey);
                              }
                            },
                            onChange: (value) {
                              if (userKey.currentState!.validate()) {
                                cubit.changeColorOfEmailLabel(Colors.grey);
                              } else {
                                cubit.changeColorOfEmailLabel(Colors.red);
                              }
                            },
                            colorOfLabel: cubit.colorOfEmailLabel,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Form(
                          key: passKey,
                          child: defaultTextFormField(
                              control: passController,
                              labelText: "Password",
                              suffixIconWithButton: cubit.isSuffixIconHidden
                                  ? null
                                  : cubit.suffixIcon,
                              suffixIconButtonOpecity: 0.3,
                              prefixIcon: Icons.lock,
                              validator: (value) {
                                if (value!.length < 8) {
                                  return "Password should be at least 8 digits";
                                }
                              },
                              onChange: (value) {
                                if (value.length >= 8) {
                                  passKey.currentState!.validate();
                                  cubit.changeColorOfPassLabel(Colors.grey);
                                }
                                if (value.isNotEmpty) {
                                  cubit.changeHiddenOfSuffix(false);
                                } else {
                                  cubit.changeHiddenOfSuffix(true);
                                }
                              },
                              isPassword: cubit.isPassShown,
                              switchEyeIcon: () {
                                cubit.changeIsPassShown();
                                cubit.isPassShown
                                    ? cubit.changeSuffixIcon(
                                        Icons.visibility_off_outlined)
                                    : cubit.changeSuffixIcon(
                                        Icons.visibility_outlined);
                              },
                              onTap: () {
                                cubit.changeFromPass(true);
                                if (cubit.fromEmail &&
                                    userKey.currentState!.validate()) {
                                  cubit.changeColorOfEmailLabel(Colors.grey);
                                  cubit.changeFromEmail(false);
                                } else if (cubit.fromEmail)
                                  cubit.changeColorOfEmailLabel(Colors.red);
                                else {
                                  cubit.changeFromEmail(false);
                                  cubit.changeColorOfEmailLabel(Colors.grey);
                                }
                              },
                              colorOfSuffixWithButton: Colors.grey,
                              colorOfLabel: cubit.colorOfPassLabel,
                              colorOfPrefixIcon: Colors.grey),
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () async {
                                if (emailController.text == "") {
                                  return AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.error,
                                          animType: AnimType.bottomSlide,
                                          title: 'Error',
                                          desc:
                                              'Please Enter an Email first!! ',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {})
                                      .show();
                                } else {
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(
                                          email: emailController.text);
                                  AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.bottomSlide,
                                          title: 'Warning',
                                          desc:
                                              'Go to your email to reset password  ',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {})
                                      .show();
                                }
                              },
                              child: const Text(
                                "i forget my password!",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 10,
                                    fontFamily: "jannah"),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        (emailController.text.isEmpty ||
                                passController.text.length < 8)
                            ? Opacity(
                                opacity: 0.5,
                                child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    color: Colors.blue,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Login",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "jannah"),
                                        ),
                                      ],
                                    )),
                              )
                            : ConditionalBuilder(
                                condition: state is! LoadingLoginScreen,
                                builder: (context) => MaterialButton(
                                  onPressed: () => login(context),
                                  minWidth: double.infinity,
                                  height: 50,
                                  color: Colors.blue,
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "jannah"),
                                  ),
                                ),
                                fallback: (context) =>
                                    Center(child: CircularProgressIndicator()),
                              ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don’t have an account? ",
                              style:
                                  TextStyle(fontSize: 13, fontFamily: "jannah"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShopScreen(),
                                    ));
                              },
                              child: const Text(
                                "REGISTER",
                                style: TextStyle(
                                    color: Colors.blue, fontFamily: "jannah"),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          LoginCubit cubit = LoginCubit.get(context);
          if (state is SuccessLoginScreen) {
            (cubit.modelLogin?.status == true
                ? {
                    defaultToast(cubit.modelLogin?.message, Colors.green),
                    // CashHelper.setData('taken', cubit.modelLogin?.data?.token).then((onValue){
                    //   taken=CashHelper.getData('taken');
                    //   ShopLayoutCubit.get(context).getFavoriteData();
                    //   ShopLayoutCubit.get(context).getUserData();
                    //   ShopLayoutCubit.get(context).getHomeData();
                    //       Navigator.pushReplacement(
                    //         context,MaterialPageRoute(builder: (context) => Shoplayout(),) );
                    // })
                  }
                : defaultToast(cubit.modelLogin?.message, Colors.red));
          }
        },
      ),
    );
  }
}
