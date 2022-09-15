import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/component/constants.dart';
import 'package:shop_app/component/ruse_component.dart';
import 'package:shop_app/layout/home_cubit/cubit.dart';
import 'package:shop_app/layout/home_cubit/states.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopCubit.get(context).userData;
        if(model !=null)
        {

          nameController.text = model.data!.name!;
          emailController.text = model.data!.email!;
          phoneController.text = model.data!.phone!;
        }

        return ConditionalBuilder(
          condition:model != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state is ShopLoadingUpdateUserDataState)
                      const LinearProgressIndicator(),
                    const SizedBox(
                      height: 20,
                    ),
                    defaultFormField(
                      controller: nameController,
                      validator: (name) {
                        if (name!.isEmpty) {
                          return 'name must not be empty';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      obscureText: false,
                      prefixIcon: const Icon(Icons.person_pin),
                      labelText: 'Name',
                    ),
                    const SizedBox(
                      height: 20.0,
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
                      labelText: 'Email Address',
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultFormField(
                      controller: phoneController,
                      validator: (phone) {
                        if (phone!.isEmpty) {
                          return 'phone must not be empty';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      prefixIcon: const Icon(Icons.phone),
                      labelText: 'Phone ',
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: double.infinity,
                      height: 40.0,
                      color: Colors.blue,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            ShopCubit.get(context).updateUserData(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                            );
                          }
                        },
                        child: const Text(
                          'UPDATE',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: double.infinity,
                      height: 40.0,
                      color: Colors.blue,
                      child: ElevatedButton(
                        onPressed: () {
                          signOut(context);
                        },
                        child: const Text(
                          'LOGOUT',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
