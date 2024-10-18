import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AutoScrollingCarousel extends HookWidget {
  final List<Widget> children;
  final Duration autoScrollDuration;
  final Duration transitionDuration;
  final Curve curve;

  const AutoScrollingCarousel({
    super.key,
    required this.children,
    this.autoScrollDuration = const Duration(seconds: 3),
    this.transitionDuration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(initialPage: 0);
    final currentPage = useState(0);

    useEffect(() {
      final timer = Timer.periodic(autoScrollDuration, (_) {
        if (currentPage.value < children.length - 1) {
          currentPage.value++;
        } else {
          currentPage.value = 0;
        }
        pageController.animateToPage(
          currentPage.value,
          duration: transitionDuration,
          curve: curve,
        );
      });

      return timer.cancel;
    }, []);

    return PageView.builder(
      controller: pageController,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return children[index % children.length];
      },
      onPageChanged: (index) {
        currentPage.value = index % children.length;
      },
    );
  }
}
