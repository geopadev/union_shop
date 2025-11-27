/// Carousel slide model representing a single slide in the hero carousel
class CarouselSlide {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String buttonText;
  final String buttonRoute;

  const CarouselSlide({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.buttonText,
    required this.buttonRoute,
  });
}
