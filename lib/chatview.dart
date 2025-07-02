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

library chatview;

export 'src/widgets/chat_view.dart';
export 'src/models/models.dart';
export 'src/widgets/chat_view_appbar.dart';
export 'src/values/enumeration.dart';
export 'src/controller/chat_controller.dart';
export 'src/values/typedefs.dart';
export 'package:audio_waveforms/audio_waveforms.dart'
    show
        WaveStyle,
        PlayerWaveStyle,
        AndroidEncoder,
        IosEncoder,
        AndroidOutputFormat;
export 'src/models/config_models/receipts_widget_config.dart';
export 'src/extensions/extensions.dart' show MessageTypes;
export 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
export 'src/widgets/attchament_picker_bottom_sheet.dart';
export 'src/widgets/message_view.dart';
export 'src/widgets/file_message_view.dart';
export 'src/widgets/video_message_view.dart';
export 'src/widgets/video_player.dart';
export 'src/models/config_models/attachment_picker_bottom_sheet_configuration.dart';
export 'src/models/config_models/file_message_configuration.dart';
export 'src/models/config_models/video_message_configuration.dart';
export 'src/models/data_models/attachment.dart';
export 'src/widgets/chatui_textfield.dart';
export 'package:mention_tag_text_field/mention_tag_text_field.dart';
export 'src/widgets/quiz_message_view.dart';
export 'src/widgets/voting_message_view.dart';
export 'src/widgets/question_message_view.dart';
export 'src/widgets/image_message_view.dart';
export 'src/models/config_models/voting_message_configuration.dart';
export 'src/models/config_models/quiz_message_configuration.dart';
export 'src/models/config_models/question_message_configuration.dart';
