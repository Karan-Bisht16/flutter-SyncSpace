import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.radius,
    this.avatar,
    required this.isLoggedIn,
  });

  final double? radius;
  final bool isLoggedIn;
  final String? avatar;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 24.0,
      backgroundImage: NetworkImage(
        (isLoggedIn && avatar != "")
            ? avatar ??
                "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg"
            : "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg",
      ),
    );
  }
}
