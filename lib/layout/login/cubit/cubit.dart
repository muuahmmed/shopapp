import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop1/end_points.dart';
import 'package:shop1/layout/login/cubit/states.dart';
import 'package:shop1/network/remote/dio_helper.dart';

import '../../../models/loginmodel.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates>
{
  ShopLoginCubit() : super(ShopLoginInitialState());
  static ShopLoginCubit get(context) =>BlocProvider.of(context);
  LoginModel ?loginModel;
  void userLogin(
  {
    required String email,
    required String password,
}
      ){
    DioHelper.postData(
        url: LOGIN,
        data:
        {
          'email':email,
          'password':password,
        }
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      emit(ShopLoginSuccessState(loginModel!));
    }).catchError((error) {
      emit(ShopLoginErrorState(error.toString()));
      print(error.toString());
    }
    );
  }
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  void changePasswordVisibility(){
    isPassword = !isPassword;
    suffix =isPassword? Icons.visibility_outlined : Icons.visibility_off_outlined ;
    emit(ShopChangePasswordVisibilityState());
  }
}