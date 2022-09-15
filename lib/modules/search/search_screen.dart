import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/component/ruse_component.dart';
import 'package:shop_app/layout/home_cubit/cubit.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/modules/description.dart';
import 'package:shop_app/modules/search/search_cubit/cubit.dart';
import 'package:shop_app/modules/search/search_cubit/states.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  defaultFormField(
                    controller: searchController,
                    onChange: (value) {
                      SearchCubit.get(context).getSearch(text: value);
                    },
                    keyboardType: TextInputType.name,
                    obscureText: false,
                    prefixIcon: const Icon(Icons.search),
                    labelText: 'Search',
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  if (state is SearchLoadingState)
                    const LinearProgressIndicator(),
                  const SizedBox(
                    height: 30.0,
                  ),
                  if (state is SearchSuccessState)
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) => buildSearchItem(
                            SearchCubit.get(context).searchModel!.data!.data[index],
                            context),
                        separatorBuilder: (context, index) => const SizedBox(height: 20.0,),
                        itemCount:SearchCubit.get(context).searchModel!.data!.data.length,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSearchItem(GetSearchProduct model, context) => InkWell(
    onTap: () {
      navigateTo(
        context,
        DescriptionScreen(
          description: '${model.description}',
          image: '${model.image}',
          price: '${model.price}',
          name: '${model.name}',
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
                  placeholder:
                      const AssetImage('assets/images/download.jfif'),
                  image: NetworkImage('${model.image}'),
                  width: 130.0,
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
                  '${model.name}',
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
                      '${model.price}',
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        ShopCubit.get(context)
                            .changeFavorites(model.id);
                      },
                      icon: CircleAvatar(
                        radius: 15.0,
                        backgroundColor: ShopCubit.get(context)
                            .favorite[model.id] !=
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
  );
}
