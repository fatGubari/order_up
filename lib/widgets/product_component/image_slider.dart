// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  final List<String> image_slides;
  const ImageSlider(this.image_slides, {super.key});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _activeImage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height / 3.4,
              width: double.infinity,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.image_slides.length,
                onPageChanged: (value) {
                  setState(() {
                    _activeImage = value;
                  });
                },
                itemBuilder: (context, index) => Image.network(
                  widget.image_slides[index],
                  fit: BoxFit.cover,
                ),
              )),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(
                    widget.image_slides.length,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                            onTap: () => _pageController.animateToPage(index,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeIn),
                            child: CircleAvatar(
                              radius: 4,
                              backgroundColor: _activeImage == index
                                  ? Theme.of(context).colorScheme.inversePrimary
                                  : Colors.grey,
                            ),
                          ),
                        )),
              ),
            ),
          )
        ],
      );
  }
}