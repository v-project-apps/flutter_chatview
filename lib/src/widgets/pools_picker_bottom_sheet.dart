import 'package:chatview/chatview.dart';
import 'package:chatview/src/models/config_models/pools_picker_bottom_sheet_configuration.dart';
import 'package:chatview/src/values/attachment_source.dart';
import 'package:flutter/material.dart';

class PoolsPickerBottomSheet {
  Future<void> show(
      {required BuildContext context,
      required PoolsPickerBottomSheetConfiguration?
          poolsPickerBottomSheetConfig,
      required AttachmentSourceCallback attachmentSourceCallback}) {
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Container(
          color: poolsPickerBottomSheetConfig?.backgroundColor,
          child: SafeArea(
            child: ListView(
              shrinkWrap: true,
              padding: poolsPickerBottomSheetConfig?.bottomSheetPadding ??
                  const EdgeInsets.only(right: 12, left: 12, top: 18),
              children: [
                if (poolsPickerBottomSheetConfig?.enablePollCreation ?? true)
                  ListTile(
                    leading: const Icon(Icons.poll),
                    title: const Text('Poll (Voting)'),
                    onTap: () {
                      Navigator.pop(context);
                      attachmentSourceCallback(AttachmentSource.poll);
                    },
                  ),
                if (poolsPickerBottomSheetConfig?.enableQuizCreation ?? true)
                  ListTile(
                    leading: const Icon(Icons.quiz),
                    title: const Text('Quiz'),
                    onTap: () {
                      Navigator.pop(context);
                      attachmentSourceCallback(AttachmentSource.quiz);
                    },
                  ),
                if (poolsPickerBottomSheetConfig?.enableQuestionCreation ??
                    true)
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Ask a question'),
                    onTap: () {
                      Navigator.pop(context);
                      attachmentSourceCallback(AttachmentSource.question);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
