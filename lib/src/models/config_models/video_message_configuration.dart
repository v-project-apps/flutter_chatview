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
import 'package:chatview/src/models/config_models/image_message_configuration.dart';
import 'package:flutter/material.dart';

import '../../values/typedefs.dart';

class VideoMessageConfiguration {
  /// Provides configuration of share button while video message is appeared.
  final ShareIconConfiguration? shareIconConfig;

  /// Hide share icon in video view.
  final bool hideShareIcon;

  /// Provides callback when user taps on image message.
  final MessageCallBack? onTap;

  /// Used for giving height of video preview.
  final double? previewHeight;

  /// Used for giving width of video preview.
  final double? previewWidth;

  /// Used for giving padding of video message.
  final EdgeInsetsGeometry? padding;

  /// Used for giving margin of video message.
  final EdgeInsetsGeometry? margin;

  /// Used for giving border radius of video message.
  final BorderRadius? borderRadius;

  const VideoMessageConfiguration({
    this.hideShareIcon = false,
    this.shareIconConfig,
    this.onTap,
    this.previewHeight,
    this.previewWidth,
    this.padding,
    this.margin,
    this.borderRadius,
  });
}
