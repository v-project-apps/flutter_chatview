import 'package:chatview/src/extensions/extensions.dart';
import 'package:flutter/material.dart';

class ImageUrlPickerDialog extends StatefulWidget {
  final Function(String imageUrl) onPicked;
  const ImageUrlPickerDialog({Key? key, required this.onPicked})
      : super(key: key);

  @override
  State<ImageUrlPickerDialog> createState() => _ImageUrlPickerDialogState();
}

class _ImageUrlPickerDialogState extends State<ImageUrlPickerDialog> {
  String imageUrl = "";

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter image URL',
              errorText:
                  imageUrl.isUrl || imageUrl.isEmpty ? null : 'Invalid URL',
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
                imageUrl = value;
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
                onPressed: imageUrl.isUrl
                    ? () async {
                        Navigator.of(context).pop();
                        widget.onPicked(imageUrl);
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
