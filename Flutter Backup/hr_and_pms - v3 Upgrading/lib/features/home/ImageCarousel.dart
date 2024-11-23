import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart' as cs;

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final List<String> imagePaths = [
    'assets/images/carousel/salary.jpg',
    'assets/images/carousel/media_2.webp',
    'assets/images/carousel/media_3.webp',
    'assets/images/carousel/attendance.jpg',
    'assets/images/carousel/media_1.webp',
    'assets/images/carousel/bonus.jpg',
    'assets/images/carousel/feedback.jpg',
  ];

  final cs.CarouselSliderController _carouselController =
      cs.CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 150.0,
            autoPlay: true,
            viewportFraction: 0.8,
            aspectRatio: 16 / 9,
          ),
          items: imagePaths.map((path) {
            return Builder(
              builder: (BuildContext context) {
                return Image.asset(
                  path,
                  fit: BoxFit.cover,
                  // width: MediaQuery.of(context).size.width,
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
