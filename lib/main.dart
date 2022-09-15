import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/component/constants.dart';
import 'package:shop_app/component/observer.dart';
import 'package:shop_app/component/themes.dart';
import 'package:shop_app/helper/cache_helper.dart';
import 'package:shop_app/helper/dio_helper.dart';
import 'package:shop_app/layout/home_cubit/cubit.dart';
import 'package:shop_app/layout/home_cubit/states.dart';
import 'package:shop_app/layout/home_layout.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/on_boarding/on_boarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelper.init();
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();
  Widget widget;
  bool? isBoarding = CacheHelper.getData(key: 'onBoarding');
  token=CacheHelper.getData(key: 'token');
  print(token);

  if(isBoarding!=null)
  {
    if(token!=null)
    {
      widget=const HomeLayout();
    }else
    {
      widget=LoginScreen();
    }
  }else
  {
    widget=const OnBoardingScreen();
  }

  runApp(MyApp(
    startWidget:widget ,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key,required this.startWidget}) : super(key: key);
  final Widget startWidget;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>ShopCubit()..getHomeData()..getCategoriesData()..getFavoriteData()..getUserData(),
      child: BlocConsumer<ShopCubit,ShopStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            home:startWidget,
          );
        },
      ),
    );
  }
}
