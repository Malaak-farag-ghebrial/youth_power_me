import 'package:flutter/material.dart';
import 'package:youth_power/core/component/my_image.dart';
import 'package:youth_power/core/component/my_text.dart';
import 'package:youth_power/core/constants/app_images.dart';
import 'package:youth_power/core/constants/app_strings.dart';
import 'package:youth_power/core/constants/app_widget_view.dart';
import 'package:youth_power/core/functions/global_variable.dart';


enum NoDataType{noInternet,noAddress,noData,maintenanceMode,}

class MyNoData extends StatelessWidget {
  final NoDataType noDataType;

  const MyNoData({super.key, required this.noDataType});

  @override
  Widget build(BuildContext context) {
    return switch(noDataType){
      NoDataType.noInternet => const NoInternet(),
      NoDataType.noAddress => const NoAddress(),
      NoDataType.noData => const NoData(),
      NoDataType.maintenanceMode => const MaintenanceMode(),
    };
  }
}

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});
  @override
  Widget build(BuildContext context) {
    return  ListView(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: MyAssetImageView(
            image: AppImages.noInternet,
            fit: BoxFit.contain,
            height: size(context).height / 1.6,
            width: size(context).width,
          ),
        ),
        Center(
          child: MyText(AppString.check_internet),
        ),
      ],
    );
  }
}

class NoAddress extends StatelessWidget {
  const NoAddress({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: MyAssetImageView(image: AppImages.emptyAddress),
        ),
        MyText(AppString.empty_address),
      ],
    );
  }
}

class MaintenanceMode extends StatelessWidget {
  const MaintenanceMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Center(
          child: MyAssetImageView(
              image: AppImages.maintenance, fit: BoxFit.fill, height: 300),
        ),
        const SizedBox(
          height: 20,
        ),
        MyText(AppString.maintenance),
      ],
    );
  }
}

class NoData extends StatelessWidget {
  const NoData({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Center(
              child: MyAssetImageView(
                height: size(context).height,
                  width: size(context).width,
                  image: AppWidgetView.isImagesOutOfTheme
                      ? AppImages.emptyDataYellow
                      : AppImages.emptyData,
              fit: BoxFit.contain
              ),
            ),
          ),
          MyText(AppString.no_data,),
        ],
      ),
    );
  }
}
