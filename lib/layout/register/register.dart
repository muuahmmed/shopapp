import 'package:cherry_toast/cherry_toast.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop1/components.dart';
import 'package:shop1/layout/home/home_screen.dart';
import 'package:shop1/layout/register/cubit/cubit.dart';
import 'package:shop1/layout/register/cubit/states.dart';
import 'package:shop1/network/local/cache_helper.dart';
import '../login/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state)   {
          if(state is ShopRegisterSuccessState){
            if(state.loginModel.status!){
              print(state.loginModel.message);
              print(state.loginModel.data?.token);
              CacheHelper.saveData(key: 'token',
                value: state.loginModel.data?.token, ).then((value){
                navigateAndFinish(context, const HomeScreen());
              });
            }
            else{
              print(state.loginModel.message);
              CherryToast.error(
                title: Text(state.loginModel.message ?? 'Error'),
              ).show(context);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Register',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    //physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            const Text(
                              'Taswaq',
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            TextFormField(
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return ('Enter your Email Address');
                                }
                                return null;
                              },
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'Email Address',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.email, color: Color(0xff0d2331)),
                              ),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            TextFormField(
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return ('Enter your FullName');
                                }
                                return null;
                              },
                              controller: nameController,
                              decoration: const InputDecoration(
                                 fillColor: Colors.white,
                                  filled: true,
                                  labelText: 'FullName',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.person,
                                      color: Color(0xff0d2331)),
                                  labelStyle: TextStyle(
                                    color: Color(0xff0d2331),
                                  )),
                              keyboardType: TextInputType.name,
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            TextFormField(
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return ('Enter your Phone Number');
                                }
                                return null;
                              },
                              controller: phoneController,
                              decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelText: 'Number',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.phone,
                                      color: Color(0xff0d2331)),
                                  labelStyle: TextStyle(
                                    color: Color(0xff0d2331),
                                  )),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            TextFormField(
                              obscureText: ShopRegisterCubit.get(context).isPassword,
                              onFieldSubmitted: (value) {
                                // if (formKey.currentState!.validate()) {
                                //   ShopRegisterCubit.get(context).userLogin(
                                //     email: emailController.text,
                                //     password: passwordController.text,
                                //  );
                                //}
                              },
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return ('Enter your password');
                                }
                                return null;
                              },
                              onChanged: (String value) {},
                              controller: passwordController,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'Password',
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    ShopRegisterCubit.get(context).changePasswordVisibility();
                                  },
                                  child: Icon(
                                    ShopRegisterCubit.get(context).suffix,
                                    color: const Color(0xff0d2331),
                                  ),
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Color(0xff0d2331),
                                ),
                                labelStyle: const TextStyle(
                                  color: Color(0xff0d2331),
                                ),
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            SizedBox(
                              width: 250.0,
                              height: 50,
                              child: ConditionalBuilder(
                                condition: state is! ShopRegisterLoadingState,
                                builder: (context) => MaterialButton(
                                  onPressed: ()
                                   {
                                     if (formKey.currentState!.validate()) {
                                       ShopRegisterCubit.get(context).userRegister(
                                         email: emailController.text,
                                         password: passwordController.text,
                                         name: nameController.text,
                                         phone: phoneController.text,
                                       );
                                     }

                                   },

                                  color: Colors.red,
                                  child: const Text(
                                    'REGISTER',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                                fallback: (context) => const Center(
                                    child: CircularProgressIndicator()),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'you have an account?',
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Login(),
                                    ));
                              },
                              child: const Text(
                                'LOGIN NOW!',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
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
