import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iti_project/models/register_model.dart';
import 'package:iti_project/modules/messenger/login_and_register/register_shop_screen/register_cubit/states.dart';



class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(RegisterInitialState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  ShopRegisterModel ?registerModel;

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  })
  {
    emit(LoadingRegisterScreen());

    // DioHelper.postData(
    //   path: 'register',
    //   data: {
    //     'name': name,
    //     'phone': phone,
    //     'email': email,
    //     'password': password,
    //   },
    //
    //
    // ).then((value)
    // {
    //   print("sdfdsfsdf");
    //   registerModel = ShopRegisterModel(value.data);
    //   print("hello${registerModel?.message}");
    //   emit(SuccessRegisterScreen());
    // }).catchError((error)
    // {
    //   print(error.toString());
    //   emit(ErrorRegisterScreen(error.toString()));
    // });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined ;

    emit(IsPassShownRegister());
  }
}