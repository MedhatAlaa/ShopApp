import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/component/ruse_component.dart';
import 'package:shop_app/layout/home_cubit/cubit.dart';
import 'package:shop_app/layout/home_cubit/states.dart';
import 'package:shop_app/models/get_favorites.dart';
import 'package:shop_app/modules/description.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
            condition: state is !ShopLoadingGetFavoriteState,
            builder: (context)=>ListView.separated(
              itemBuilder: (context, index) => buildFavItem(
                  ShopCubit.get(context).getFavoritesModel!.data!.data![index],
                  context),
              separatorBuilder: (context, index) => Container(
                margin: const EdgeInsets.only(left: 25.0),
                height: 1.0,
                width: double.infinity,
                color: Colors.grey[300],
              ),
              itemCount: ShopCubit.get(context).getFavoritesModel!.data!.data!.length,
            ),
            fallback: (context)=>const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildFavItem(Data model, context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: InkWell(
          onTap: () {
            navigateTo(
              context,
              DescriptionScreen(
                description: '${model.product!.description}',
                image: '${model.product!.image}',
                price: '${model.product!.price.round()}',
                name: '${model.product!.name}',
              ),
            );
          },
          child: SizedBox(
            height: 140.0,
            child: Row(
              children: [
                SizedBox(
                  width: 130.0,
                  height: 130.0,
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      FadeInImage(
                        placeholder: const AssetImage('assets/images/download.jfif'),
                        image: NetworkImage('${model.product!.image}'),
                        width: 130.0,
                      ),
                      if (model.product!.discount != 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          color: Colors.red,
                          child: const Text(
                            'DISCOUNT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${model.product!.name}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            '${model.product!.price}',
                            style: const TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(
                            width: 15.0,
                          ),
                          if (model.product!.discount != 0)
                            Text(
                              '${model.product!.oldPrice}',
                              style: const TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              ShopCubit.get(context)
                                  .changeFavorites(model.product!.id);
                            },
                            icon: CircleAvatar(
                              radius: 15.0,
                              backgroundColor: ShopCubit.get(context)
                                          .favorite[model.product!.id] !=
                                      null
                                  ? Colors.blue
                                  : Colors.grey,
                              child: const Icon(
                                Icons.favorite_border,
                                size: 14.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
