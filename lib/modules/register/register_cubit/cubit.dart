import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/component/constants.dart';
import 'package:shop_app/component/end_points.dart';
import 'package:shop_app/helper/dio_helper.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/register/register_cubit/states.dart';


class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  bool isPassword = false;
  IconData iconData = Icons.visibility;

  void changePassword() {
    isPassword = !isPassword;
    iconData = isPassword ? Icons.visibility_off : Icons.visibility;
    emit(ShopRegisterChangePasswordState());
  }
  ShopLoginModel? registerModel;
  void userRegister({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    emit(ShopRegisterLoadingState());
    DioHelper.postData(
      url: register,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      },
      token: token,
    ).then((value) {
      registerModel=ShopLoginModel.fromJson(value.data);
      emit(ShopRegisterSuccessState(registerModel!));
    }).catchError(
          (error) {
        print('error is => ${error.toString()}');
        emit(ShopRegisterErrorState(error.toString()));
      },
    );
  }
}
