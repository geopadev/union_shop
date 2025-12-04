import 'package:union_shop/models/carousel_slide.dart';

/// Sample carousel slide data for the hero carousel
/// Contains 3 slides showcasing different collections
class CarouselData {
  static const List<CarouselSlide> slides = [
    CarouselSlide(
      title: 'Explore Portsmouth City Collection',
      subtitle: 'Discover unique items celebrating our city',
      imageUrl: 'assets/images/carousel/slide_1.png',
      buttonText: 'BROWSE COLLECTION',
      buttonRoute: '/collections/portsmouth',
    ),
    CarouselSlide(
      title: 'Halloween Special 🎃',
      subtitle: 'Spooky season essentials',
      imageUrl: 'assets/images/carousel/slide_2.png',
      buttonText: 'SHOP NOW',
      buttonRoute: '/collections/halloween',
    ),
    CarouselSlide(
      title: 'Pride Collection 🏳️‍🌈',
      subtitle: 'Show your pride with our rainbow collection',
      imageUrl: 'assets/images/carousel/slide_3.png',
      buttonText: 'VIEW COLLECTION',
      buttonRoute: '/collections/pride',
    ),
  ];
}
