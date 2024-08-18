import 'package:carousel_slider/carousel_slider.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop1/layout/home/cubit/cubit.dart';
import 'package:shop1/layout/home/cubit/states.dart';
import 'package:shop1/models/categories_model.dart';
import 'package:shop1/models/home_model.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesState) {
          if (!state.model.status!) {
            CherryToast.error(
              title: Text(state.model.message ?? 'Error'),
            ).show(context);
          }
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ShopCubit.get(context).homeModel != null &&
              ShopCubit.get(context).categoriesModel != null,
          builder: (context) => productsBuilder(
              ShopCubit.get(context).homeModel,
              ShopCubit.get(context).categoriesModel,
              context),
          fallback: (context) =>
          const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildCategoryItem(DataModel? model) {
    final String imageUrl = model?.image ?? 'https://via.placeholder.com/100';
    final String name = model?.name ?? 'Unknown';

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image(
          image: NetworkImage(imageUrl),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 10.0),
        Container(
          width: 100.0,
          color: Colors.black.withOpacity(0.8),
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      ],
    );
  }


  Widget productsBuilder(HomeModel? model, CategoriesModel? categoriesModel, context) {
    if (model == null ||
        model.data == null ||
        categoriesModel == null ||
        categoriesModel.data == null) {
      return const Center(child: Text('No data available'));
    }

    var banners = model.data?.banners ?? [];
    var products = model.data?.products ?? [];
    const String fallbackImageUrl = 'https://via.placeholder.com/250';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (banners.isNotEmpty)
            CarouselSlider(
              items: banners.map((e) {
                String imageUrl = (e.image == null || e.image!.isEmpty)
                    ? fallbackImageUrl
                    : e.image!;
                return Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      fallbackImageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                viewportFraction: 1.0,
                height: 250.0,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(seconds: 1),
                autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                scrollDirection: Axis.horizontal,
              ),
            )
          else
            const Center(child: Text('No banners available')),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) =>
                        buildCategoryItem(categoriesModel.data!.data![index]),
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 10.0,
                    ),
                    itemCount: categoriesModel.data?.data?.length ?? 0,
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'New Products',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
                ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.7,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];
              return buildProductItem(product, context);
            },
          ),
        ],
      ),
    );
  }

  Widget buildProductItem(ProductModel product, BuildContext context) { // Change here
    const String fallbackImageUrl = 'https://via.placeholder.com/250';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image.network(
              product.image ?? fallbackImageUrl,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  fallbackImageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                );
              },
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                product.name ?? 'Unknown',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15),
              ),
              Row(
                children: [
                  Text(
                    '${product.price?.round() ?? 0},',
                    style: const TextStyle(fontSize: 13, color: Colors.deepOrange),
                  ),
                  const SizedBox(width: 5.0),
                  if (product.discount != 0)
                    Text(
                      '${product.oldPrice?.round() ?? 0}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      ShopCubit.get(context).changeFavorites(product.id!);
                      print(product.id);
                    },
                    icon: CircleAvatar(
                      radius: 15,
                      backgroundColor: ShopCubit.get(context).favorites[product.id] == true
                          ? Colors.red
                          : Colors.grey,
                      child: Icon(
                        ShopCubit.get(context).favorites[product.id] == true
                            ? Icons.favorite
                            : Icons.favorite_border,
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
    );
  }
}
