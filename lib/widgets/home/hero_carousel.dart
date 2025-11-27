import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/models/carousel_slide.dart';

/// Hero carousel widget for the homepage
/// Displays slides with auto-advance and manual navigation
class HeroCarousel extends StatefulWidget {
  final List<CarouselSlide> slides;

  const HeroCarousel({
    super.key,
    required this.slides,
  });

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _startAutoAdvance();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoAdvance() {
    _timer?.cancel();
    if (!_isPaused) {
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (_pageController.hasClients) {
          final nextPage = (_currentPage + 1) % widget.slides.length;
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _timer?.cancel();
      } else {
        _startAutoAdvance();
      }
    });
  }

  void _goToPrevious() {
    if (_pageController.hasClients) {
      final prevPage =
          (_currentPage - 1 + widget.slides.length) % widget.slides.length;
      _pageController.animateToPage(
        prevPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNext() {
    if (_pageController.hasClients) {
      final nextPage = (_currentPage + 1) % widget.slides.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('hero_carousel'),
      height: 400,
      width: double.infinity,
      child: Stack(
        children: [
          // PageView for slides
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.slides.length,
            itemBuilder: (context, index) {
              return _buildSlide(widget.slides[index], index);
            },
          ),

          // Previous button
          Positioned(
            left: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: Colors.white, size: 32),
                onPressed: _goToPrevious,
                tooltip: 'Previous slide',
              ),
            ),
          ),

          // Next button
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 32),
                onPressed: _goToNext,
                tooltip: 'Next slide',
              ),
            ),
          ),

          // Pause/Play button
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: Icon(
                _isPaused ? Icons.play_arrow : Icons.pause,
                color: Colors.white,
                size: 32,
              ),
              onPressed: _togglePause,
              tooltip: _isPaused ? 'Resume auto-advance' : 'Pause auto-advance',
            ),
          ),

          // Navigation dots indicator
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.slides.length,
                (index) => _buildDot(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(CarouselSlide slide, int index) {
    return Stack(
      key: Key('carousel_slide_$index'),
      children: [
        // Background image
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(slide.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),

        // Content overlay
        Positioned(
          left: 24,
          right: 24,
          top: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                slide.title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                slide.subtitle,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                key: index == 0 ? const Key('browse_collection_button') : null,
                onPressed: () => context.go(slide.buttonRoute),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4d2963),
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: Text(
                  slide.buttonText,
                  style: const TextStyle(fontSize: 14, letterSpacing: 1),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? Colors.white
            : Colors.white.withValues(alpha: 0.5),
      ),
    );
  }
}
