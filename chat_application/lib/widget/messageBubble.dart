import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../main.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final Alignment alignment = message.senderUserId == userId1
        ? Alignment.centerRight
        : Alignment.centerLeft;

    final Color color = message.senderUserId == userId1
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;

    final Color textColor = message.senderUserId == userId1
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSecondary;

    return Align(
      alignment: alignment,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: BoxConstraints(
          maxWidth: size.width * 0.66,
        ),
        margin: const EdgeInsets.all(
          4.0
        ),
        padding: const EdgeInsets.all(8),
        child: Text(
          message.content ?? '',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
