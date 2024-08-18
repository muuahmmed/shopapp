import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop1/components.dart';
import 'package:shop1/layout/home/home_screen.dart';
import 'package:shop1/layout/login/cubit/cubit.dart';
import 'package:shop1/layout/login/cubit/states.dart';
import 'package:shop1/layout/register/register.dart';
import 'package:shop1/network/local/cache_helper.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  var emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state)
        {
          if(state is ShopLoginSuccessState){
            if(state.loginModel.status!){
              CacheHelper.saveData(key: 'token', value: state.loginModel.data?.token, ).then((value){
                navigateAndFinish(context, const HomeScreen());
              });
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Login',
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
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Taswaq',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
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
                          obscureText: ShopLoginCubit.get(context).isPassword,
                          onFieldSubmitted: (value) {
                            if (formKey.currentState!.validate()) {
                              ShopLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
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
                                ShopLoginCubit.get(context).changePasswordVisibility();
                              },
                              child: Icon(
                                ShopLoginCubit.get(context).suffix,
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
                        Row(
                          children: [
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forget your password?',
                                style: TextStyle(
                                  color: Colors.grey[900],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 250.0,
                          height: 50,
                          color: Colors.deepOrange,
                          child: ConditionalBuilder(
                            condition: state is! ShopLoginLoadingState,
                            builder: (context) => MaterialButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  ShopLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              child: const Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            fallback: (context) => const Center(child: CircularProgressIndicator()),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\' have an account?'),
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Register Now!',
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
