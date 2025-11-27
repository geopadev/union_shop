import 'package:union_shop/models/carousel_slide.dart';

/// Sample carousel slide data for the hero carousel
/// Contains 3 slides showcasing different collections
class CarouselData {
  static const List<CarouselSlide> slides = [
    CarouselSlide(
      title: 'Explore Portsmouth City Collection',
      subtitle: 'Discover unique items celebrating our city',
      imageUrl:
          'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
      buttonText: 'BROWSE COLLECTION',
      buttonRoute: '/collections/portsmouth',
    ),
    CarouselSlide(
      title: 'Halloween Special 🎃',
      subtitle: 'Spooky season essentials',
      imageUrl:
          'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
      buttonText: 'SHOP NOW',
      buttonRoute: '/collections/halloween',
    ),
    CarouselSlide(
      title: 'Pride Collection 🏳️‍🌈',
      subtitle: 'Show your pride with our inclusive range',
      imageUrl:
          'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
      buttonText: 'DISCOVER MORE',
      buttonRoute: '/collections/pride',
    ),
  ];
}
