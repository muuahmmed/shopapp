import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop1/end_points.dart';
import 'package:shop1/layout/register/cubit/states.dart';
import 'package:shop1/models/loginmodel.dart';
import 'package:shop1/network/remote/dio_helper.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());
  static ShopRegisterCubit get(context) => BlocProvider.of(context);
  LoginModel? loginModel;
  void userRegister({
    required String email,
    required String name,
    required String phone,
    required String password,
  }) {
    emit(ShopRegisterLoadingState()); // Emit loading state
    DioHelper.postData(
      url: REGISTER,
      data: {
        'email': email,
        'name': name,
        'phone': phone,
        'password': password,
      },
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      emit(ShopRegisterSuccessState(loginModel!));
    }).catchError((error) {
      emit(ShopRegisterErrorState(error.toString()));
      print(error.toString());
    });
  }


  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ShopRegChangePasswordVisibilityState());
  }
}
