import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/component/end_points.dart';
import 'package:shop_app/helper/dio_helper.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/login/login_cubit/states.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = false;
  IconData iconData = Icons.visibility;

  void changePassword() {
    isPassword = !isPassword;
    iconData = isPassword ? Icons.visibility_off : Icons.visibility;
    emit(ShopLoginChangePasswordState());
  }
  ShopLoginModel? loginModel;
  void userLogin({
    required String email,
    required String password,
  }) {
    emit(ShopLoginLoadingState());
    DioHelper.postData(
      url: login,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      loginModel=ShopLoginModel.fromJson(value.data);
      // print(loginModel!.status);
      // print(loginModel!.message);
      // print(loginModel!.data!.token);
      emit(ShopLoginSuccessState(loginModel!));
    }).catchError(
      (error) {
        print('error is => ${error.toString()}');
        emit(ShopLoginErrorState(error.toString()));
      },
    );
  }
}
