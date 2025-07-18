import 'dart:math' as math;

import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/models/models.dart';
import 'package:chatview/src/utils/constants/constants.dart';
import 'package:chatview/src/widgets/suggestions/suggestion_item.dart';
import 'package:flutter/material.dart';

class SuggestionList extends StatefulWidget {
  const SuggestionList({super.key});

  @override
  State<SuggestionList> createState() => _SuggestionListState();
}

class _SuggestionListState extends State<SuggestionList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  List<SuggestionItemData> suggestions = [];
  bool isSuggestionListEmpty = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: suggestionListAnimationDuration,
      vsync: this,
    )..addListener(updateSuggestionsOnAnimation);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newSuggestions = chatViewIW?.chatController.newSuggestions;
      newSuggestions?.addListener(animateSuggestionList);
    });
  }

  void updateSuggestionsOnAnimation() {
    if (isSuggestionListEmpty && _controller.value == 0) {
      suggestions = [];
    } else if (chatViewIW?.chatController.newSuggestions.value.isNotEmpty ??
        false) {
      suggestions = chatViewIW?.chatController.newSuggestions.value ?? [];
    }
  }

  @override
  void activate() {
    super.activate();
    final newSuggestions = chatViewIW?.chatController.newSuggestions;
    newSuggestions?.addListener(animateSuggestionList);
  }

  void animateSuggestionList() {
    final newSuggestions = chatViewIW?.chatController.newSuggestions;
    if (newSuggestions != null) {
      isSuggestionListEmpty = newSuggestions.value.isEmpty;
      isSuggestionListEmpty ? _controller.reverse() : _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final suggestionsItemConfig = suggestionsConfig?.itemConfig;
    final suggestionsListConfig =
        suggestionsConfig?.listConfig ?? const SuggestionListConfig();
    return Container(
      decoration: suggestionsListConfig.decoration,
      padding:
          suggestionsListConfig.padding ?? const EdgeInsets.only(left: 8.0),
      margin: suggestionsListConfig.margin,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Align(
              alignment: const AlignmentDirectional(-1.0, -1.0),
              heightFactor: math.max(_controller.value, 0.0),
              widthFactor: 1,
              child: suggestionsConfig?.suggestionItemType.isScrollType ?? false
                  ? SingleChildScrollView(
                      scrollDirection: suggestionsListConfig.listDirection ??
                          Axis.horizontal,
                      child: suggestionsListConfig.listDirection ==
                              Axis.vertical
                          ? LayoutBuilder(
                              builder: (context, constraints) {
                                final maxItemWidth = _calculateMaxItemWidth();
                                final constrainedWidth = math.min(
                                  maxItemWidth,
                                  constraints.maxWidth * 0.6,
                                );

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _suggestionListWidget(
                                    suggestionsItemConfig,
                                    fixedWidth: constrainedWidth,
                                  ),
                                );
                              },
                            )
                          : Row(
                              children: _suggestionListWidget(
                                suggestionsItemConfig,
                              ),
                            ))
                  : Wrap(
                      runSpacing:
                          suggestionsConfig?.spaceBetweenSuggestionItemRow ??
                              10,
                      alignment: WrapAlignment.end,
                      children: _suggestionListWidget(suggestionsItemConfig),
                    ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _suggestionListWidget(
      SuggestionItemConfig? suggestionsItemConfig,
      {double? fixedWidth}) {
    final suggestionsListConfig =
        suggestionsConfig?.listConfig ?? const SuggestionListConfig();
    return List.generate(
      suggestions.length,
      (index) {
        final suggestion = suggestions[index];
        final suggestionWidget = suggestion.config?.customItemBuilder
                ?.call(index, suggestion) ??
            suggestionsItemConfig?.customItemBuilder?.call(index, suggestion) ??
            SuggestionItem(
              suggestionItemData: suggestion,
            );

        return Padding(
          padding: EdgeInsets.only(
            right: index == suggestions.length
                ? 0
                : suggestionsListConfig.itemSeparatorWidth,
            bottom: index == suggestions.length
                ? 0
                : suggestionsListConfig.itemSeparatorWidth,
          ),
          child: fixedWidth != null
              ? SizedBox(
                  width: fixedWidth,
                  child: suggestionWidget,
                )
              : suggestionWidget,
        );
      },
    );
  }

  double _calculateMaxItemWidth() {
    if (suggestions.isEmpty) return 0;

    double maxWidth = 0;
    for (final suggestion in suggestions) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: suggestion.text,
          style: suggestion.config?.textStyle ??
              suggestionsConfig?.itemConfig?.textStyle,
        ),
        textDirection: TextDirection.ltr,
        maxLines: null, // Allow unlimited lines for width calculation
      );
      textPainter.layout();

      // Add padding and border width
      final padding = suggestion.config?.padding ??
          suggestionsConfig?.itemConfig?.padding ??
          const EdgeInsets.all(6);
      final totalWidth =
          textPainter.width + padding.horizontal + 2; // +2 for border

      if (totalWidth > maxWidth) {
        maxWidth = totalWidth;
      }
    }

    return maxWidth;
  }

  @override
  void deactivate() {
    final newSuggestions = chatViewIW?.chatController.newSuggestions;
    newSuggestions?.removeListener(animateSuggestionList);
    super.deactivate();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(updateSuggestionsOnAnimation)
      ..dispose();
    super.dispose();
  }
}
