import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key? key, required this.imageUrl, required this.radius}) : super(key: key);

  final String imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: radius.toDouble() + 2,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: CircleAvatar(
          radius: radius.toDouble(),
          backgroundImage: NetworkImage(imageUrl),
        )
    );
  }
}