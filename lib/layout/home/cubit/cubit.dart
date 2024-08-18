import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop1/components.dart';
import 'package:shop1/end_points.dart';
import 'package:shop1/layout/categories.dart';
import 'package:shop1/layout/home/cubit/states.dart';
import 'package:shop1/layout/products.dart';
import 'package:shop1/layout/settings.dart';
import 'package:shop1/models/categories_model.dart';
import 'package:shop1/models/favourites_model.dart';
import 'package:shop1/models/home_model.dart';
import 'package:shop1/models/loginmodel.dart';
import 'package:shop1/network/remote/dio_helper.dart';
import 'package:shop1/layout/favorites.dart';
import '../../../models/favorites_model.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(BuildContext context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    const Products(),
    const Categories(),
    const Favorites(),
    const Settings(),
  ];

  void changeBottomScreens(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;
  Map<int, bool> favorites = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(url: HOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      printFullText(homeModel.toString());

      homeModel?.data?.products.forEach((element) {
        favorites.addAll({
          element.id ?? 0: element.inFavourites ?? false,
        });
      });
      print(favorites.toString());
      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategories() {
    DioHelper.getData(url: Get_Categories, token: token).then((value) {
      print("Categories Response: ${value.data}"); // Log the value
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavouritesModel? changeFavouritesModel;

  void changeFavorites(int productId) {
    bool previousState = favorites[productId] ?? false;
    favorites[productId] = !previousState;
    emit(ShopChangeFavoritesState());
    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      try {
        // Ensure that the value data is not null
        if (value.data != null) {
          changeFavouritesModel = ChangeFavouritesModel.fromJson(value.data);

          if (changeFavouritesModel?.status == true) {
            emit(ShopSuccessChangeFavoritesState(changeFavouritesModel!));
          } else {
            favorites[productId] = previousState;
            emit(ShopErrorChangeFavoritesState(
                changeFavouritesModel?.message ?? 'Unknown error occurred.'));
          }
        } else {
          throw Exception('Response data is null');
        }
      } catch (e) {
        favorites[productId] = previousState;
        emit(ShopErrorChangeFavoritesState('Error parsing value: $e'));
      }
    }).catchError((error) {
      favorites[productId] = previousState;
      emit(ShopErrorChangeFavoritesState('Network error: ${error.toString()}'));
    });
  }

  FavouritesModel? favouritesModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());

    DioHelper.getData(url: FAVORITES, token: token).then((value) {
      print("Favorites Response: ${value.data}"); // Log the value
      favouritesModel = FavouritesModel.fromJson(value.data);
      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  LoginModel? userModel;
  void getUserData(){
    emit(ShopLoadingUserDataState());

    DioHelper.getData(
        url: PROFILE,
        token: token,
    ).then((value) {
      print("API Response: ${value.data}");
      userModel = LoginModel.fromJson(value.data);
      printFullText("Username: ${userModel?.data?.name}");
      emit(ShopSuccessUserDataState(userModel!));
    }).catchError((error) {
      print("Error: ${error.toString()}");
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
}
      ){
    emit(ShopLoadingUpdateUserDataState());

    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,

      },
    ).then((value) {
      print("API Response: ${value.data}");
      userModel = LoginModel.fromJson(value.data);
      printFullText("Username: ${userModel?.data?.name}");
      emit(ShopSuccessUpdateUserDataState(userModel!));
    }).catchError((error) {
      print("Error: ${error.toString()}");
      emit(ShopErrorUpdateUserDataState());
    });
  }

}
