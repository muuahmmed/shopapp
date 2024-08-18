import 'package:flutter/material.dart';
import 'package:shop1/components.dart';
import 'package:shop1/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'login/login_screen.dart';

class BoardingModel
{
  final String image;
  final String title;
  final String body;
  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
});
}

class OnBoarding extends StatefulWidget{
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}
class _OnBoardingState extends State<OnBoarding> {
  bool isLast = false;
  var boardController = PageController();
  List<BoardingModel> boarding =[
    BoardingModel(
      image:'assets/shopping.jpg',
      title: 'shopping 1 Title',
      body: 'shopping 1 Body',
    ),
    BoardingModel(
      image:'assets/shopping.jpg',
      title: 'shopping 2 Title',
      body: 'shopping 2 Body',
    ),
    BoardingModel(
      image:'assets/shopping.jpg',
      title: 'shopping 3 Title',
      body: 'shopping 3 Body',
    ),
  ];

  void submit() {
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if (value) {
        navigateAndFinish(context, const Login());
        print('Data is saved');
      } else {
        print('Failed to save data');
      }
    }).catchError((error) {
      print('Error saving data: $error');
    });
  }


  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       actions: [
         TextButton(
           onPressed: submit,
           child: const Text(
             'SKIP',
             style: TextStyle(
               fontWeight: FontWeight.bold,
               color: Colors.deepOrange,

               fontSize: 15,
             ),
           ),
         )
       ]
     ),
     body: Padding(
       padding: const EdgeInsets.all(10.0),
       child: Column(
         children:
         [
           Expanded(
             child: PageView.builder(itemBuilder: (context,index)=> buildBoardingItem(boarding[index]),
               physics: const BouncingScrollPhysics(),
               onPageChanged: (int index){
                if (index == boarding.length -1){
                  print('last');
                  setState(() {
                    isLast = true;
                  });
                }
                else if(index == boarding.length -2){
                  print('not last');
                  setState(() {
                    isLast = false;
                  });
                }
               },
               controller: boardController,
               itemCount: boarding.length,
             ),
           ),
           const SizedBox(height: 40),
            Row(
             children: [
               SmoothPageIndicator(
                 controller: boardController,
                 count: boarding.length,
                 effect: const ExpandingDotsEffect(
                   expansionFactor: 4,
                   spacing: 5,
                   dotColor: Colors.grey,
                   activeDotColor: Colors.deepOrange,
                   dotHeight: 10,
                   dotWidth: 10,

                 ),
               ),
               const Spacer(),
               FloatingActionButton(onPressed: ()
               {
                 if(isLast){
                   submit();
                 }
                 else{
                   boardController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.bounceInOut);
                   // setState(() {
                   //   isLast = false;
                   // });
                 }

               }
               ,child: const Icon(Icons.arrow_forward_ios),)

             ],
           )

         ],
       ),
     )
   );
  }

  Widget buildBoardingItem(BoardingModel model)=>  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: Image(image: AssetImage(model.image))),
      // const SizedBox(height:20),
      Text(
        model.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,),
      ),
      const SizedBox(height:20),
       Text(
        model.body,
        style: const TextStyle(

          fontSize: 14,),
      ),

    ],
  );
}