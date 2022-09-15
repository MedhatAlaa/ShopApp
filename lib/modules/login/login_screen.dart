import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/component/constants.dart';
import 'package:shop_app/component/ruse_component.dart';
import 'package:shop_app/helper/cache_helper.dart';
import 'package:shop_app/layout/home_layout.dart';
import 'package:shop_app/modules/login/login_cubit/cubit.dart';
import 'package:shop_app/modules/login/login_cubit/states.dart';
import '../register/register_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  var emailController = TextEditingController();
  var passWordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state)
        {
          if(state is ShopLoginSuccessState)
          {
            if(state.loginModel.status!)
            {
              print(state.loginModel.message!);
              print(state.loginModel.data!.token);
              CacheHelper.saveData(
                key: 'token',
                value: state.loginModel.data!.token,
              ).then((value)
              {
                token=state.loginModel.data!.token;
                navigateAndFinish(context, const HomeLayout());
              });
            }
            else
            {
              print(state.loginModel.message!);
            }
          }
        },
        builder: (context, state) {
          var cubit = ShopLoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style:
                              Theme.of(context).textTheme.headline3!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Login now to browse our hot offers',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        defaultFormField(
                          controller: emailController,
                          validator: (email) {
                            if (email!.isEmpty) {
                              return 'email must not be empty';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          obscureText: false,
                          prefixIcon: const Icon(Icons.email_outlined),
                          labelText: 'Email',
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                          controller: passWordController,
                          validator: (password) {
                            if (password!.isEmpty) {
                              return 'password must not be empty';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: cubit.isPassword,
                          prefixIcon: const Icon(Icons.lock_open_rounded),
                          suffixIcon: IconButton(
                            onPressed: () {
                              cubit.changePassword();
                            },
                            icon: Icon(
                              cubit.iconData,
                              color: cubit.isPassword?Colors.blue:Colors.grey,
                            ),
                          ),
                          labelText: 'Password',
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        ConditionalBuilder(
                          condition:state is! ShopLoginLoadingState ,
                          builder: (BuildContext context)=>SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate())
                                {
                                  cubit.userLogin(
                                    email: emailController.text,
                                    password: passWordController.text,
                                  );
                                }
                              },
                              child: const Text('LOGIN'),
                            ),
                          ),
                          fallback: (BuildContext context)=>const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account ?'),
                            TextButton(
                              onPressed: ()
                              {
                                navigateTo(context, RegisterScreen());
                              },
                              child: const Text('REGISTER'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
