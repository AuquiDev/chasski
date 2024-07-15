

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chasski/utils/assets_delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class GLobalImageUrlServer extends StatelessWidget {
  const GLobalImageUrlServer(
      {super.key,
      required this.image,
      required this.collectionId,
      required this.id,
      required this.borderRadius,
      this.height = double.infinity,
      this.width = double.infinity,
      this.boxFit = BoxFit.cover,
      this.color,  
      this.fadingDuration = 1200,  
      this.duration = 1000,  this.curve =Curves.ease,
      
      });
  final String image;
  final String collectionId;
  final String id;
  final BorderRadiusGeometry borderRadius;
  final double height;
  final double width;
  final BoxFit? boxFit;
  final Color? color;
  final int fadingDuration;
  final int duration;
  final Curve curve;
  @override
  Widget build(BuildContext context) {
    return AssetsDelayedDisplayX(
      fadingDuration: fadingDuration,
      duration: duration,
      curve: curve,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: CachedNetworkImage(
          // ignore: unnecessary_null_comparison, unnecessary_type_check
          imageUrl: image != null && image is String && image.isNotEmpty
              ? 'https://andes-race-challenge.pockethost.io/api/files/${collectionId}/${id}/${image}'
              : 'https://via.placeholder.com/300',
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => imagenLogo(),
          fit: boxFit,
          width: width,
          height: height,
          color: color,
        ),
      ),
    );
  }
}

Container imagenLogo() {
  return Container(
    decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fitHeight,
          image: AssetImage(
            'assets/img/runner.png',
          ),
        ),
        color: Colors.black),
  );
}

Future<Uint8List> loadImageFromUrl({String? collectionId, String? id,String? file} ) async {
  String imageUrl = 
'https://andes-race-challenge.pockethost.io/api/files/${collectionId}/${id}/${file}';
  final response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode != 200) {
    throw Exception('Failed to load image from $imageUrl');
  }
  return response.bodyBytes;
}

Future<Uint8List> loadAssetImage(String assetPath) async {
  ByteData byteData = await rootBundle.load(assetPath);
  return byteData.buffer.asUint8List();
}