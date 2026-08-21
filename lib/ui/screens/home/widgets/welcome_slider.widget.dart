import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/domain/entities/slides/slide_entity.dart';
import 'package:tvapp/ui/providers/welcome/welcome_provider.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class WelcomeSlider extends ConsumerStatefulWidget {
  const WelcomeSlider({super.key});

  @override
  ConsumerState createState() => _WelcomeSliderState();
}

class _WelcomeSliderState extends ConsumerState<WelcomeSlider> {
  int _current = 0;

  final CarouselSliderController _controller = CarouselSliderController();

  List<Widget> getSliders(List<Slide> categories) {
    return categories
        .map((item) => Padding(
          padding: const EdgeInsets.only(right: 18),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: Image.network(item.imagen,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 1,
                  errorBuilder: (context, error, stackTrace) =>
                      const ColoredBox(color: Colors.black12, child: Center(child: Icon(Icons.broken_image, size: 40))))),
        ))
        .toList();
  }

  List<Widget> getDots(List<Slide> categories) {
    return categories.mapWithIndex((entry, index) {
      return GestureDetector(
        onTap: () => _controller.animateToPage(index),
        child: Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  Colors.white.withOpacity(_current == index ? 0.9 : 0.4)),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(welcomeProvider);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GoogleTextWidget('Bienvenido!',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: Environment.h2FSize,
              fontWeight: FontWeight.bold,
            )),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.2,
        child: categories.maybeWhen(
          orElse: SizedBox.new,
          initial: () {
            Future.microtask(
                    () => ref.read(welcomeProvider.notifier).get());
            return const SizedBox();
          },
          success: (categories) {
            return CarouselSlider(
              items: getSliders(categories),
              carouselController: _controller,
              options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.2,
                  viewportFraction: 0.9,
                  autoPlay: true,
                  padEnds: false,
                  autoPlayAnimationDuration: const Duration(milliseconds: 1200),
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            );
          }
        ),
      ),
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: categories.maybeWhen(
            orElse: () => [],
            success: (categories) => getDots(categories)
        ),
      ),
    ]);
  }
}
