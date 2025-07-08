import 'package:chatview/chatview.dart';
import 'package:chatview/src/widgets/chat_view_inherited_widget.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HorizontalUserAvatars extends StatelessWidget {
  final List<ChatUser> users;
  final int maxVisibleUsers;
  final double circleRadius;
  final bool includeCurrentUser;

  const HorizontalUserAvatars(
      {super.key,
      required this.users,
      this.maxVisibleUsers = 4,
      this.includeCurrentUser = false,
      this.circleRadius = 16.0});

  @override
  Widget build(BuildContext context) {
    List<ChatUser> usersList = includeCurrentUser
        ? users
        : users
            .where((user) =>
                user.id !=
                ChatViewInheritedWidget.of(context)
                    ?.chatController
                    .currentUser
                    .id)
            .toList();
    int extraUsers = usersList.length > maxVisibleUsers
        ? usersList.length - maxVisibleUsers
        : 0;
    List<ChatUser> displayUsers =
        usersList.isNotEmpty ? usersList.take(maxVisibleUsers).toList() : [];

    double widgetWidth = ((circleRadius + 1) * 2) +
        (displayUsers.length - 1) * (circleRadius * 1.3);

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
                        backgroundColor: Colors.primaries[
                            displayUsers[i].id.hashCode %
                                Colors.primaries.length],
                        child: displayUsers[i].profilePhoto != null
                            ? ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: displayUsers[i].profilePhoto!,
                                  fit: BoxFit.cover,
                                  width: circleRadius * 2,
                                  height: circleRadius * 2,
                                  errorWidget: (context, url, error) => Center(
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Text(
                                        displayUsers[i].name.isNotEmpty
                                            ? displayUsers[i].name[0]
                                            : '?',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    displayUsers[i].name.isNotEmpty
                                        ? displayUsers[i].name[0]
                                        : '?',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Visibility(
                      visible: extraUsers > 0 && i == maxVisibleUsers - 1,
                      child: Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
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
