import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/component/ruse_component.dart';
import 'package:shop_app/layout/home_cubit/cubit.dart';
import 'package:shop_app/layout/home_cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/modules/description.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.homeModel != null && cubit.categoriesModel != null,
          builder: (context) =>
              buildHome(cubit.homeModel, cubit.categoriesModel, context),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildHome(HomeModel? homeModel, CategoriesModel? model, context) =>SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            CarouselSlider(
              items: homeModel!.data!.banners.map((e) {
                return FadeInImage(
                  placeholder:const AssetImage('assets/images/download.jfif'),
                  image: NetworkImage('${e.image}',),
                );
              }).toList(),
              options: CarouselOptions(
                reverse: false,
                initialPage: 0,
                height: 250.0,
                scrollDirection: Axis.horizontal,
                enableInfiniteScroll: true,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(seconds: 2),
                autoPlay: true,
                autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                viewportFraction: 1.0,
                pauseAutoPlayOnTouch: true,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 27.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  SizedBox(
                    height: 120.0,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) =>
                          buildCatItem(model!.data!.data[index]),
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 10.0,
                      ),
                      itemCount: model!.data!.data.length,
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  const Text(
                    'New Products',
                    style: TextStyle(
                      fontSize: 27.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.6,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                children: List.generate(
                  homeModel.data!.products.length,
                  (index) =>
                      buildGridView(homeModel.data!.products[index], context),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildGridView(ProductModel productModel, context) => InkWell(
        onTap: () {
          navigateTo(
            context,
            DescriptionScreen(
              description: '${productModel.description}',
              image: '${productModel.image}',
              price: '${productModel.price.round()}',
              name: '${productModel.name}',
            ),
          );
        },
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  FadeInImage(
                    placeholder:const AssetImage('assets/images/download.jfif'),
                    image:NetworkImage('${productModel.image}'),
                    height: 200.0,
                    width: double.infinity,
                    // child: Image(
                    //   image: NetworkImage(
                    //     '${productModel.image}',
                    //   ),
                    //   height: 200.0,
                    //   width: double.infinity,
                    // ),
                  ),
                  if (productModel.discount != 0)
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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${productModel.name}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          '${productModel.price.round()}',
                          style: const TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        if (productModel.discount != 0)
                          Text(
                            '${productModel.oldPrice.round()}',
                            style: const TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        const Spacer(),
                        CircleAvatar(
                          radius: 15.0,
                          backgroundColor:ShopCubit.get(context).favorite[productModel.id]!?Colors.blue:Colors.grey,
                          child: IconButton(
                            onPressed: ()
                            {
                              ShopCubit.get(context).changeFavorites(productModel.id);
                            },
                            icon: const Icon(
                              Icons.favorite_border,
                              size: 14.0,
                              color:Colors.white,
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
      );

  Widget buildCatItem(CatDataModel model) => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: 120.0,
            width: 120.0,
            child: FadeInImage(
              placeholder:const AssetImage('assets/images/download.jfif'),
              image: NetworkImage('${model.image}'),
              // child: Image(
              //   image: NetworkImage(
              //     '${model.image}',
              //   ),
              // ),
            ),
          ),
          Container(
            width: 120.0,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
            ),
            child: Text(
              '${model.name}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      );
}
