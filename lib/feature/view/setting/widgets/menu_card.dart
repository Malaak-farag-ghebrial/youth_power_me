
import 'package:flutter/material.dart';
import 'package:youth_power/core/component/my_text.dart';
import 'package:youth_power/core/component/shadow_box.dart';
import 'package:youth_power/core/constants/app_colors.dart';
import 'package:youth_power/core/constants/app_icons.dart';

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String cardName;
  final Function()? onTap;
  final Widget restCard;

   const MenuCard({super.key, required this.icon, required this.cardName,this.onTap,this.restCard = const Icon(AppIcons.arrow)});



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child:   Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: boxShadow(),
            color: AppColors.primaryColorLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            child: Row(
              children: [
                Icon(icon),
                const SizedBox(width: 10,),
                Expanded(child: MyText(cardName,style: Theme.of(context).textTheme.titleMedium),),
                restCard,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
