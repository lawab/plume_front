import 'package:flutter/material.dart';

class MoviesListView extends StatelessWidget {
  final ScrollController scrollController;
  final List images;

  const MoviesListView(
      {Key? key, required this.scrollController, required this.images})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('images.length');
    print(images.length);

    return Container(
      height: 100,
      child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: images.length,
          itemBuilder: (context, index) {
            print(images[index]);
            return Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: images[index] != 'Mcf_Junior.png' &&
                        images[index] != 'logo_plum.png'
                    ? Image.network(
                        width: 150,
                        fit: BoxFit.fill,
                        'http://13.39.81.126:7002${images[index]} ')
                    : Image.asset(
                        'assets/${images[index]}',
                        width: 150,
                        fit: BoxFit.fill,
                      ),
              ),
            );
          }),
    );
  }
}
