import 'package:flutter/cupertino.dart';
import 'package:youth_power/core/constants/app_images.dart';

// class MyNetworkImageView extends StatelessWidget {
//   final String imageUrl;
//   final BoxFit fit;
//   final double? height;
//   final double? width;
//
//   const MyNetworkImageView({super.key,
//     required this.imageUrl,
//     this.fit = BoxFit.fill,
//     this.height,
//     this.width});
//
//   @override
//   Widget build(BuildContext context) {
//     return CachedNetworkImage(
//       imageUrl: imageUrl,
//       fit: fit,
//       height: height,
//       width: width,
//       errorWidget: (context, url, error) {
//         return FadeInImage.assetNetwork(
//           placeholder: AppImages.dummy,
//           image: url,
//           fit: BoxFit.fill,
//         );
//       },
//       placeholder: (context, url) {
//         return FadeInImage.assetNetwork(
//           placeholder: AppImages.dummy,
//           image: url,
//           fit: BoxFit.fill,
//         );
//       },
//     );
//   }
// }


class MyAssetImageView extends StatelessWidget {
  final String image;
  final double height;
  final double width;
  final BoxFit fit;

  const MyAssetImageView({
    super.key,
    required this.image,
    this.height = 200,
    this.width = 400,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      height: height,
      width: width,
      fit: fit,
    );
  }
}


