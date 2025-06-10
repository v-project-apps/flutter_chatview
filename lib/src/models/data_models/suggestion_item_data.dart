import '../config_models/suggestion_item_config.dart';

class SuggestionItemData {
  final String id;
  final String text;
  final SuggestionItemConfig? config;

  const SuggestionItemData({
    required this.id,
    required this.text,
    this.config,
  });
}
