// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:banner_carousel/banner_carousel.dart';
import 'package:chasski/models/model_sponsors.dart';
import 'package:chasski/provider/provider_t_sponsors.dart';
import 'package:chasski/utils/assets_delayed_display.dart';
import 'package:chasski/utils/assets_img_urlserver.dart';
import 'package:chasski/widgets/assets_url_lacuncher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SponsorSpage extends StatelessWidget {
  const SponsorSpage({super.key, this.height = 60, this.width = 310});
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    final providerSponsors = Provider.of<TSponsorsProvider>(context);
    List<TSponsosModel> sponsors = providerSponsors.listaSponsors;
    //nueva lista estado true
    final filter = sponsors.where((e) => e.estatus == true).toList();
    return CarruselSponsors(
      sponsors: filter,
      height: height,
      width: width,
    );
  }
}

class CarruselSponsors extends StatefulWidget {
  const CarruselSponsors(
      {super.key,
      required this.sponsors,
      required this.height,
      required this.width});
  final List<TSponsosModel> sponsors;
  final double height;
  final double width;
  @override
  State<CarruselSponsors> createState() => _CarruselSponsorsState();
}

class _CarruselSponsorsState extends State<CarruselSponsors> {
  late PageController _pageController;
  int currentPage = 0;
  late Timer _timer;
  bool goingForward = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: currentPage,
    );
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    const Duration autoScrollDuration = Duration(seconds: 5);
    _timer = Timer.periodic(autoScrollDuration, (_) {
      if (widget.sponsors.isNotEmpty) {
        if (goingForward) {
          if (currentPage < widget.sponsors.length - 1) {
            currentPage++;
          } else {
            goingForward = false;
            currentPage--;
          }
        } else {
          if (currentPage > 0) {
            currentPage--;
          } else {
            goingForward = true;
            currentPage++;
          }
        }
        _pageController.animateToPage(
          currentPage,
          duration: Duration(milliseconds: 1500), // Duration of the animation
          curve: Curves.ease, // Animation curve
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: widget.sponsors.isEmpty
          ? SizedBox()
          : BannerCarousel(
              animation: true,
              customizedIndicators: IndicatorModel.animation(
                  width: 3,
                  height: 3,
                  spaceBetween: 2,
                  widthAnimation: 6,
                  heightAnimation: 6),
              viewportFraction: 0.60,
              showIndicator: true,
              indicatorBottom: true,
              pageController: _pageController,
              customizedBanners: [
                ...List.generate(widget.sponsors.length, (index) {
                  final int pageIndex = index % widget.sponsors.length;
                  final e = widget.sponsors[pageIndex];
                  return CardSponsors(e: e);
                })
              ],
            ),
    );
  }
}

class CardSponsors extends StatelessWidget {
  const CardSponsors({
    super.key,
    required this.e,
  });

  final TSponsosModel e;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()  {
        launchURL(e.link);
      },
      child: AssetsDelayedDisplayX(
        fadingDuration: 1200,
        duration: 800,
        curve: Curves.decelerate,
        child: Container(
          color: Colors.white,
          child: GLobalImageUrlServer(
            image: e.image!,
            collectionId: e.collectionId!,
            id: e.id!,
            borderRadius: BorderRadius.circular(8.0),
            boxFit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

 
}
