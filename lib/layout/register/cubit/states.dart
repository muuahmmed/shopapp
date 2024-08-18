import '../../../models/loginmodel.dart';

abstract class ShopRegisterStates {}

class ShopRegisterInitialState extends ShopRegisterStates {}

class ShopRegisterLoadingState extends ShopRegisterStates {}

class ShopRegisterErrorState extends ShopRegisterStates {
  final String error;
  ShopRegisterErrorState(this.error);
}

class ShopRegChangePasswordVisibilityState extends ShopRegisterStates {}

class ShopRegisterSuccessState extends ShopRegisterStates {
  final LoginModel loginModel;

  ShopRegisterSuccessState(this.loginModel);
}
