import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iti_project/modules/messenger/login_and_register/login_shop_screen/cubit/states.dart';
import '../../../../../models/shop_login.dart';

class LoginCubit extends Cubit<LoginStates>{
  LoginCubit() : super(InitialState());
  bool fromEmail=false;
  bool fromPass=false;
  Color colorOfEmailLabel=Colors.grey;
  Color colorOfPassLabel=Colors.grey;
  bool isPassShown=true;
  bool isSuffixIconHidden=true;
  IconData suffixIcon=Icons.visibility_off_outlined;
  ShopLoginModel? modelLogin;

 static LoginCubit get(context)
  {
    return BlocProvider.of(context);
  }

  void changeColorOfEmailLabel(Color color)
  {
    colorOfEmailLabel=color;
    emit(ChangeColorOfEmailLabel());
  }

  void changeColorOfPassLabel(Color color)
  {
    colorOfPassLabel=color;
    emit(ChangeColorOfPassLabel());
  }

  void changeHiddenOfSuffix(bool  k)
  {
    isSuffixIconHidden=k;
    emit(ChangeHiddenOfSuffix());
  }

  void changeIsPassShown()
  {
    isPassShown=!isPassShown;
    emit(IsPassShown());
  }

  void changeSuffixIcon(IconData icon)
  {
   suffixIcon=icon;
    emit(ChangeSuffixIcon());
  }

  void changeFromEmail(bool b)
  {
    fromEmail=b;
    emit(ChangeFromEmail());
  }

  void changeFromPass(bool b)
  {
    fromPass=b;
    emit(ChangeFromPass());
  }


}