import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/home_cubit/cubit.dart';
import 'package:shop_app/layout/home_cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => buildCategoriesItem(ShopCubit.get(context).categoriesModel!.data!.data[index]),
          separatorBuilder: (context, index) => Container(
            margin: const EdgeInsets.only(left: 25.0),
            height: 1.0,
            width: double.infinity,
            color: Colors.grey[300],
          ),
          itemCount: ShopCubit.get(context).categoriesModel!.data!.data.length,
        );
      },
    );
  }

  Widget buildCategoriesItem(CatDataModel catDataModel) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            FadeInImage(
              placeholder:const AssetImage('assets/images/download.jfif'),
              image:NetworkImage('${catDataModel.image}',),
              height: 140.0,
              width: 140.0,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              '${catDataModel.name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_sharp,
            ),
          ],
        ),
      );
}
