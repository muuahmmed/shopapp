import 'package:cherry_toast/cherry_toast.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop1/components.dart';
import 'package:shop1/layout/home/cubit/cubit.dart';
import 'package:shop1/layout/home/cubit/states.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {
          if (state is ShopSuccessUserDataState) {
            if (state.loginModel.data != null) {
              nameController.text = state.loginModel.data!.name ?? '';
              emailController.text = state.loginModel.data!.email ?? '';
              phoneController.text = state.loginModel.data!.phone ?? '';
            }
            else{
              CherryToast.error(
                title: Text(state.loginModel.message?? ''),
              );
            }
          }
        },
        builder: (context, state)  {
          var model = ShopCubit.get(context).userModel;

          if (model?.data != null) {
            nameController.text = model!.data!.name ?? '';
            emailController.text = model.data!.email ?? '';
            phoneController.text = model.data!.phone ?? '';
          }

          return ConditionalBuilder(
            condition: ShopCubit.get(context).userModel != null,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: nameController,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'name must not be empty';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          prefix: const Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          fillColor: Colors.grey[300],
                          filled: true,
                          labelText: 'Name',
                          hoverColor: Colors.black),
                    ),
                    const SizedBox(height: 30.0),
                    TextFormField(
                      controller: emailController,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'email must not be empty';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefix: const Icon(
                            Icons.email,
                            color: Colors.black,
                          ),
                          fillColor: Colors.grey[300],
                          filled: true,
                          labelText: 'email',
                          hoverColor: Colors.black),
                    ),
                    const SizedBox(height: 30.0),
                    TextFormField(
                      controller: phoneController,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'number must not be empty';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          prefix: const Icon(
                            Icons.phone,
                            color: Colors.black,
                          ),
                          fillColor: Colors.grey[300],
                          filled: true,
                          labelText: 'phone',
                          hoverColor: Colors.black),
                    ),
                    const SizedBox(height: 30.0),
                    Container(
                      color: Colors.red,
                      height: 60,
                      width: double.infinity,
                      child: TextButton(
                          onPressed: (){
                            signOut(context);
                          },
                          child: const Text('Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),)),
                    ),
                    const SizedBox(height: 30.0),
                    Container(
                      color: Colors.red,
                      height: 60,
                      width: double.infinity,
                      child: TextButton(
                          onPressed: (){
                            if(formKey.currentState!.validate()){
                              ShopCubit.get(context).updateUserData(
                                name: nameController.text,
                                email:emailController.text,
                                phone: phoneController.text,
                              );
                            }

                          },
                          child: const Text('Update',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),)),
                    ),
                  ],
                ),
              ),
            ),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
