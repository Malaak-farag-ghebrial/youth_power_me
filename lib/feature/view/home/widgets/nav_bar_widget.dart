

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/shadow_box.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../controller/home_cubit/home_cubit.dart';

class MyNavigationBar extends StatelessWidget {
  const MyNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit,HomeState>(
      builder: (context,state) {
        var homeCubit = HomeCubit.get(context);
        return Container(
          height: 60,
          margin: const EdgeInsets.only(
            right: 12,
            left: 12,
            bottom: 20,
          ),
          decoration: BoxDecoration(
              color: AppColors.primaryColorLight,
              borderRadius: const BorderRadius.all(Radius.circular(40),),
              boxShadow: boxShadow(),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(40),),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: IconButton(
                      onPressed: (){
                        homeCubit.btmNavBar(0);
                      },
                      icon: Icon(AppIcons.home,color: homeCubit.currentIndex != 0? AppColors.black : Theme.of(context).primaryColor,),),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: IconButton(
                      onPressed: (){
                        homeCubit.btmNavBar(1);
                      },
                      icon: Icon(AppIcons.family,color: homeCubit.currentIndex != 1? AppColors.black : Theme.of(context).primaryColor,),),

                  ),),
                Expanded(
                  child: Center(
                    child: IconButton(
                      onPressed: (){
                        homeCubit.btmNavBar(2);
                      },
                      icon: Icon(AppIcons.activity,color: homeCubit.currentIndex != 2? AppColors.black : Theme.of(context).primaryColor,),),
                  ),),
                // Expanded(
                //   child: Center(
                //     child: IconButton(
                //       onPressed: (){
                //         homeCubit.btmNavBar(3);
                //       },
                //       icon: Icon(AppIcons.menu,color: homeCubit.currentIndex != 3? AppColors.black : Theme.of(context).primaryColor,),),
                //   ),
                // ),
                Expanded(
                  child: Center(
                    child: IconButton(
                      onPressed: (){
                        homeCubit.btmNavBar(3);
                      },
                      icon: Icon(AppIcons.setting,color: homeCubit.currentIndex != 3? AppColors.black : Theme.of(context).primaryColor,),),
                  ),
                ),

              ],
            ),
          ),
        );
      }
    );
  }
}
