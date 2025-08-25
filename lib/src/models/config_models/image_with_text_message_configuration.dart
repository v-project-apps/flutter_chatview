/*
 * Copyright (c) 2022 Simform Solutions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import 'package:flutter/material.dart';

import '../../values/typedefs.dart';
import 'image_message_configuration.dart';

class ImageWithTextMessageConfiguration {
  /// Provides configuration of share button while image message is appeared.
  final ShareIconConfiguration? shareIconConfig;

  /// Hide share icon in image view.
  final bool hideShareIcon;

  /// Provides callback when user taps on image message.
  final MessageCallBack? onTap;

  /// Used for giving height of image message.
  final double? height;

  /// Used for giving width of image message.
  final double? width;

  /// Used for giving padding of image message.
  final EdgeInsetsGeometry? padding;

  /// Used for giving margin of image message.
  final EdgeInsetsGeometry? margin;

  /// Used for giving border radius of image message.
  final BorderRadius? borderRadius;

  /// Used for giving text style of the text below image.
  final TextStyle? textStyle;

  /// Used for giving padding around the text.
  final EdgeInsetsGeometry? textPadding;

  /// Used for giving margin around the text.
  final EdgeInsetsGeometry? textMargin;

  /// Used for giving background color of the text container.
  final Color? textBackgroundColor;

  /// Used for giving border radius of the text container.
  final BorderRadius? textBorderRadius;

  const ImageWithTextMessageConfiguration({
    this.hideShareIcon = false,
    this.shareIconConfig,
    this.onTap,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.borderRadius,
    this.textStyle,
    this.textPadding,
    this.textMargin,
    this.textBackgroundColor,
    this.textBorderRadius,
  });
}
