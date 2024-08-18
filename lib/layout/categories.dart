import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop1/components.dart';
import 'package:shop1/layout/home/cubit/cubit.dart';
import 'package:shop1/layout/home/cubit/states.dart';
import 'package:shop1/models/categories_model.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var categoriesModel = ShopCubit.get(context).categoriesModel;
        if (categoriesModel == null || categoriesModel.data == null || categoriesModel.data!.data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          itemBuilder: (context, index) => buildCategoriesItem(categoriesModel.data!.data![index]),
          separatorBuilder: (context, index) => myDivider(),
          itemCount: categoriesModel.data!.data!.length,
        );
      },
    );
  }

  Widget buildCategoriesItem(DataModel model) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Image(
            image: NetworkImage(model.image ?? ''),
            width: 100,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error);
            },
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: Text(
              model.name ?? 'No name',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          IconButton(onPressed: (){},
               icon: const Icon(Icons.arrow_forward_ios),),
        ],
      ),
    );
  }
}
