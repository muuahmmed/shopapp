import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop1/components.dart';
import 'package:shop1/layout/home/cubit/states.dart';
import 'package:shop1/models/favourites_model.dart';
import 'home/cubit/cubit.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  void initState() {
    super.initState();
    ShopCubit.get(context).getFavorites(); // Load favorites when initialized
  }

  @override
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var favouritesModel = ShopCubit.get(context).favouritesModel;

        if (favouritesModel == null || favouritesModel.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (favouritesModel.data!.isEmpty) {
          return const Center(child: Text('No favorites available'));
        }

        return ListView.separated(
          itemBuilder: (context, index) {
            var product = ShopCubit.get(context).favouritesModel?.data?[index];
            if (product == null) return Container(); // Handle null case

            return buildFavoriteItems(product, context);
          },
          separatorBuilder: (context, index) => myDivider(),
          itemCount: ShopCubit.get(context).favouritesModel?.data?.length ?? 0,
        );
      },
    );
  }


  Widget buildFavoriteItems(FavoritesData model, context) {
    var product = model.product;
    if (product == null) {
      return const SizedBox.shrink(); // Skip rendering if the product is null
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 120.0,
        child: Row(
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image.network(
                    product.image ?? '',
                    width: 120.0,
                    height: 120.0,
                    fit: BoxFit.cover,
                  ),
                  if (product.discount != 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      color: Colors.red,
                      child: const Text(
                        'DISCOUNT',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    product.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15),
                  ),
                  Row(
                    children: [
                      Text(
                        product.price?.toString() ?? '',
                        style: const TextStyle(fontSize: 13, color: Colors.deepOrange),
                      ),
                      const SizedBox(width: 5.0),
                      if (product.oldPrice != 0)
                        Text(
                          product.oldPrice?.toString() ?? '',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          ShopCubit.get(context).changeFavorites(model.product!.id!);
                        },
                        icon: CircleAvatar(
                          radius: 15,
                          backgroundColor: ShopCubit.get(context).favorites[model.product!.id] == true ? Colors.red : Colors.grey,
                          child: const Icon(
                            Icons.favorite_border,
                            size: 20,
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
}
