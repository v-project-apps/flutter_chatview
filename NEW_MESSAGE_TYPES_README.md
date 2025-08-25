# New Message Types in Flutter ChatView

This document describes the two new message types that have been added to the Flutter ChatView package:

## 1. Image with Text Message

A message that displays an image with text below it. The image appears on top and the text below, styled consistently with other message types.

### Features:
- Image displayed above text
- Customizable text styling and background
- Same image handling as regular image messages (tap to view full screen)
- Configurable appearance through `ImageWithTextMessageConfiguration`

### Usage:

```dart
// Create the message
final message = Message(
  message: "Your text message here",
  messageType: MessageType.imageWithText,
  attachment: Attachment(
    file: File("path/to/your/image.jpg"),
    // or url: "https://example.com/image.jpg"
  ),
  // ... other required fields
);

// Configure the appearance
final messageConfig = MessageConfiguration(
  imageWithTextMessageConfig: ImageWithTextMessageConfiguration(
    height: 400,
    width: 540,
    textStyle: TextStyle(fontSize: 16, color: Colors.black87),
    textBackgroundColor: Colors.grey[100],
    textPadding: EdgeInsets.all(12),
    borderRadius: BorderRadius.circular(14),
  ),
);
```

## 2. Image Carousel Message

A message that displays multiple images (up to 10) in a carousel format with page indicators.

### Features:
- Up to 10 images in a swipeable carousel
- Page indicators showing current position
- Same image handling as regular image messages
- Configurable appearance through `ImageCarouselMessageConfiguration`

### Usage:

```dart
// Create the message with multiple images
final message = Message(
  message: "path/to/image1.jpg;path/to/image2.jpg;path/to/image3.jpg",
  messageType: MessageType.imageCarousel,
  // ... other required fields
);

// Configure the appearance
final messageConfig = MessageConfiguration(
  imageCarouselMessageConfig: ImageCarouselMessageConfiguration(
    height: 360,
    width: 540,
    imageHeight: 360,
    imageWidth: 540,
    imageSpacing: 8,
    indicatorColor: Colors.white,
    indicatorBackgroundColor: Colors.white.withOpacity(0.5),
    indicatorSize: 8,
    borderRadius: BorderRadius.circular(14),
  ),
);
```

## Configuration Options

### ImageWithTextMessageConfiguration
- `hideShareIcon`: Hide the share icon
- `onTap`: Custom tap handler for the image
- `height/width`: Overall message dimensions
- `padding/margin`: Spacing around the message
- `borderRadius`: Corner rounding
- `textStyle`: Text appearance
- `textPadding/margin`: Text container spacing
- `textBackgroundColor`: Text container background
- `textBorderRadius`: Text container corner rounding

### ImageCarouselMessageConfiguration
- `hideShareIcon`: Hide the share icon
- `onTap`: Custom tap handler for the images
- `height/width`: Overall message dimensions
- `padding/margin`: Spacing around the message
- `borderRadius`: Corner rounding
- `imageHeight/imageWidth`: Individual image dimensions
- `imageSpacing`: Space between images
- `imageBorderRadius`: Individual image corner rounding
- `imagePadding/margin`: Individual image spacing
- `indicatorColor`: Active page indicator color
- `indicatorBackgroundColor`: Inactive page indicator color
- `indicatorSize`: Page indicator size
- `indicatorSpacing`: Space between indicators

## Attachment Picker Integration

Both message types are automatically available in the attachment picker bottom sheet:

- **Image with Text**: Shows as "Image with Text" option
- **Image Carousel**: Shows as "Image Carousel" option

You can control their visibility through the `AttachmentPickerBottomSheetConfiguration`:

```dart
final attachmentConfig = AttachmentPickerBottomSheetConfiguration(
  enableImageWithTextPicker: true,  // Default: true
  enableImageCarouselPicker: true,  // Default: true
);
```

## Creating Messages

### Image with Text
1. Select "Image with Text" from attachment picker
2. Choose an image from gallery
3. Enter your text message
4. Send the message

### Image Carousel
1. Select "Image Carousel" from attachment picker
2. Choose multiple images (up to 10)
3. Send the message

**Note**: Both message types use `XFile` objects internally, making them compatible with both web and mobile platforms. Images are stored in the message's attachments list.

## Styling Consistency

Both new message types follow the same styling patterns as existing message types:
- Consistent border radius and padding
- Same reaction and seen-by indicators
- Compatible with chat bubble configurations
- Responsive to theme changes
- Support for reply messages and reactions

## Example Implementation

### ChatView Configuration
```dart
ChatView(
  chatController: chatController,
  messageConfiguration: MessageConfiguration(
    imageWithTextMessageConfig: ImageWithTextMessageConfiguration(
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      textBackgroundColor: Colors.blue[50],
    ),
    imageCarouselMessageConfig: ImageCarouselMessageConfiguration(
      indicatorColor: Colors.blue,
      imageBorderRadius: BorderRadius.circular(8),
    ),
  ),
  attachmentPickerBottomSheetConfiguration: AttachmentPickerBottomSheetConfiguration(
    enableImageWithTextPicker: true,
    enableImageCarouselPicker: true,
  ),
)
```

### Manual Message Creation
```dart
// Image with Text Message
final imageWithTextMessage = Message(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
  message: "Your text message here",
  messageType: MessageType.imageWithText,
  sentBy: currentUserId,
  createdAt: DateTime.now(),
  attachments: [
    Attachment(
      name: "image.jpg",
      url: "path/to/image.jpg",
      size: 0,
    ),
  ],
);

// Image Carousel Message
final imageCarouselMessage = Message(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
  message: "Image Carousel",
  messageType: MessageType.imageCarousel,
  sentBy: currentUserId,
  createdAt: DateTime.now(),
  attachments: [
    Attachment(
      name: "image1.jpg",
      url: "path/to/image1.jpg",
      size: 0,
    ),
    Attachment(
      name: "image2.jpg",
      url: "path/to/image2.jpg",
      size: 0,
    ),
    // Add more attachments as needed
  ],
);
```

## Notes

- Both message types support the same image sources as regular image messages (file, URL, memory)
- **New Structure**: Both message types now use the message's attachments list to store image data, providing better structure and flexibility
- Both types integrate seamlessly with existing chat functionality
- All configuration options are optional with sensible defaults
- **Web Compatibility**: Both message types are fully compatible with Flutter web using `XFile` objects instead of `File` objects
