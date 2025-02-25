import 'package:chatview/src/extensions/extensions.dart';
import 'package:flutter/material.dart';

class VideoUrlPickerDialog extends StatefulWidget {
  final Function(String videoUrl, String? thumbnailUrl) onPicked;
  const VideoUrlPickerDialog({Key? key, required this.onPicked})
      : super(key: key);

  @override
  State<VideoUrlPickerDialog> createState() => _VideoUrlPickerDialogState();
}

class _VideoUrlPickerDialogState extends State<VideoUrlPickerDialog> {
  String videoUrl = "";
  String thumbnailUrl = "";

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter video URL',
              errorText:
                  videoUrl.isUrl || videoUrl.isEmpty ? null : 'Invalid URL',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.black, width: 2.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.black, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.black, width: 1.5),
              ),
            ),
            onChanged: (value) {
              setState(() {
                videoUrl = value;
              });
            },
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter thumbnail URL (optional)',
              errorText: thumbnailUrl.isEmpty || thumbnailUrl.isUrl
                  ? null
                  : 'Invalid URL',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.black, width: 2.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.black, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.black, width: 1.5),
              ),
            ),
            onChanged: (value) {
              setState(() {
                thumbnailUrl = value;
              });
            },
          ),
          if (thumbnailUrl.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'If not provided, the preview will be empty.',
                style: textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel', style: textTheme.bodyMedium),
              ),
              ElevatedButton(
                onPressed: videoUrl.isUrl &&
                        (thumbnailUrl.isEmpty || thumbnailUrl.isUrl)
                    ? () async {
                        Navigator.of(context).pop();
                        widget.onPicked(videoUrl, thumbnailUrl);
                      }
                    : null,
                child: Text('Submit', style: textTheme.bodyMedium),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
