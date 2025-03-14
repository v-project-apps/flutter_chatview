import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';

class HorizontalUserAvatars extends StatelessWidget {
  final List<ChatUser> users;
  final int maxVisibleUsers;
  final double circleRadius;

  const HorizontalUserAvatars(
      {super.key,
      required this.users,
      this.maxVisibleUsers = 4,
      this.circleRadius = 16.0});

  @override
  Widget build(BuildContext context) {
    int extraUsers =
        users.length > maxVisibleUsers ? users.length - maxVisibleUsers : 0;
    List<ChatUser> displayUsers =
        users.isNotEmpty ? users.take(maxVisibleUsers).toList() : [];

    double widgetWidth =
        (circleRadius * 2) + (displayUsers.length) * (circleRadius * 1.3);

    return SizedBox(
      height: circleRadius * 2 + 4,
      width: widgetWidth,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          if (displayUsers.isNotEmpty)
            for (int i = 0; i < displayUsers.length; i++)
              Positioned(
                left: i * (circleRadius * 1.3),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: CircleAvatar(
                        maxRadius: circleRadius,
                        backgroundImage: displayUsers[i].profilePhoto != null
                            ? NetworkImage(displayUsers[i].profilePhoto!)
                            : null,
                        backgroundColor: displayUsers[i].profilePhoto == null
                            ? Colors.primaries[i % Colors.primaries.length]
                            : null,
                        child: displayUsers[i].profilePhoto == null
                            ? Center(
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    displayUsers[i].name[0],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                    Visibility(
                      visible: extraUsers > 0 && i == maxVisibleUsers - 1,
                      child: Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                '+$extraUsers',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
