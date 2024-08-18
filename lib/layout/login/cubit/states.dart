import '../../../models/loginmodel.dart';

abstract class ShopLoginStates {}

class ShopLoginInitialState extends ShopLoginStates{}

class ShopLoginLoadingState extends ShopLoginStates {}

class ShopLoginErrorState extends ShopLoginStates{
  final String error;
  ShopLoginErrorState(this.error);
}



class ShopChangePasswordVisibilityState extends ShopLoginStates{}

class ShopLoginSuccessState extends ShopLoginStates{
  final LoginModel loginModel;

  ShopLoginSuccessState(this.loginModel);
}