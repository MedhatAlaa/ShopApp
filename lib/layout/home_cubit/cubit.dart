import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/component/constants.dart';
import 'package:shop_app/component/end_points.dart';
import 'package:shop_app/helper/dio_helper.dart';
import 'package:shop_app/layout/home_cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_favorites.dart';
import 'package:shop_app/models/get_favorites.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favorite/favorite_screen.dart';
import 'package:shop_app/modules/productes/products_screen.dart';
import 'package:shop_app/modules/settings/settings_screen.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoriteScreen(),
    SettingsScreen(),
  ];

  List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.apps),
      label: 'Categories',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: 'Favorite',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  void changeBottomNav(index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;
  Map<int?, bool?> favorite = {};

  void getHomeData() {
    DioHelper.getData(
      url: home,
      token: token,
    ).then(
      (value) {
        homeModel = HomeModel.formJson(value.data);
        for (var element in homeModel!.data!.products) {
          favorite.addAll({
            element.id: element.inFavorites,
          });
        }
        emit(ShopSuccessHomeDataState());
      },
    ).catchError((error) {
      print('error when getting homeData ${error.toString()}');
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategoriesData() {
    DioHelper.getData(
      url: getCategories,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessGetCategoriesDataState());
    }).catchError((error) {
      emit(ShopErrorGetCategoriesDataState());
    });
  }

  ChangeFavoriteModel? changeFavoriteModel;

  void changeFavorites(int? productId) {
    favorite[productId] = !favorite[productId]!;
    emit(ShopChangeFavoriteState());
    DioHelper.postData(
      url: favorites,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoriteModel = ChangeFavoriteModel.fromJson(value.data);
      if (!changeFavoriteModel!.status!) {
        favorite[productId] = !favorite[productId]!;
      } else {
        getFavoriteData();
      }
      emit(ShopSuccessChangeFavoriteState());
    }).catchError((error) {
      favorite[productId] = !favorite[productId]!;
      emit(ShopErrorChangeFavoriteState());
    });
  }

  GetFavoritesModel? getFavoritesModel;

  void getFavoriteData() {
    emit(ShopLoadingGetFavoriteState());
    DioHelper.getData(
      url: favorites,
      token: token,
    ).then((value) {
      getFavoritesModel = GetFavoritesModel.fromJson(value.data);
      print(getFavoritesModel!.status);
      print(getFavoritesModel!.data!.data![0].product!.image);
      emit(ShopSuccessGetFavoriteState());
    }).catchError((error) {
      print('error when getting favorite is ${error.toString()}');
      emit(ShopErrorGetFavoriteState());
    });
  }

  ShopLoginModel? userData;

  void getUserData() {
    DioHelper.getData(
      url: profile,
      token: token,
    ).then((value) {
      userData = ShopLoginModel.fromJson(value.data);
      emit(ShopSuccessGetUserDataState());
    }).catchError((error) {
      emit(ShopErrorGetUserDataState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateUserDataState());
    DioHelper.putData(
      url: updateProfile,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
      token: token,
    ).then((value) {
      userData = ShopLoginModel.fromJson(value.data);
      emit(ShopSuccessUpdateUserDataState());
    }).catchError((error) {
      print('error when update ${error.toString()}');
      emit(ShopErrorUpdateUserDataState());
    });
  }
}
