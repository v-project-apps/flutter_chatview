import 'package:chatview/src/extensions/extensions.dart';
import 'package:flutter/material.dart';

class AudioUrlPickerDialog extends StatefulWidget {
  final Function(String audioUrl) onPicked;
  const AudioUrlPickerDialog({Key? key, required this.onPicked})
      : super(key: key);

  @override
  State<AudioUrlPickerDialog> createState() => _AudioUrlPickerDialogState();
}

class _AudioUrlPickerDialogState extends State<AudioUrlPickerDialog> {
  String audioUrl = "";

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
              hintText: 'Enter audio URL',
              errorText:
                  audioUrl.isUrl || audioUrl.isEmpty ? null : 'Invalid URL',
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
                audioUrl = value;
              });
            },
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
                onPressed: audioUrl.isUrl
                    ? () async {
                        Navigator.of(context).pop();
                        widget.onPicked(audioUrl);
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
