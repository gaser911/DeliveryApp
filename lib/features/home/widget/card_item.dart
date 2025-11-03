import 'package:flutter/material.dart';
import 'package:food_app/core/constants/app.colors.dart';
import 'package:food_app/shared/custom_text.dart';
import 'package:gap/gap.dart';

class CardItem extends StatelessWidget {
  const CardItem({super.key, 
  required this.image, 
  required this.name, 
  required this.desc,
   required this.rating});
  final String image;
  final String name;
  final String desc;
  final String rating;

  @override
  Widget build(BuildContext context) {
    return   Card(
              
              color: Colors.white ,
              elevation: 4,

              child:  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(image, width: 180 ,),
                  const Gap(10),
                   CustomText(text: name ,fontWeight: FontWeight.bold,color: Colors.black,size: 17,),
                   CustomText(text: desc,size: 15,color: Colors.black54),
                  const Gap(10),
                   CustomText(text: "⭐ $rating",color: Appcolors.primary,),
                
                
                ],
                ),
              ),

            );
  }
}