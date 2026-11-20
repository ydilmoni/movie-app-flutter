import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/part_mark.dart';
import 'storage_provider.dart';

class PartMarksNotifier extends Notifier<List<PartMark>> {
  PartMarksNotifier(this.storageKey);
  final String storageKey;

  @override
  List<PartMark> build() {
    final prefs = ref.read(prefsProvider);
    final texts = prefs.getStringList(storageKey) ?? [];
    return texts.map((text) => PartMark.fromJson(jsonDecode(text))).toList();
  }

  bool contains(PartMark mark) => state.any((m) => m.isSame(mark));

  void toggle(PartMark mark) {
    if (contains(mark)) {
      state = state.where((m) => !m.isSame(mark)).toList();
    } else {
      state = [...state, mark];
    }
    _save();
  }

  void setAll(List<PartMark> marks, bool isOn) {
    final others = state.where((m) => !marks.any((x) => x.isSame(m))).toList();
    state = isOn ? [...others, ...marks] : others;
    _save();
  }

  void _save() {
    final prefs = ref.read(prefsProvider);
    final texts = state.map((m) => jsonEncode(m.toJson())).toList();
    prefs.setStringList(storageKey, texts);
  }
}

final favoritePartsProvider =
    NotifierProvider<PartMarksNotifier, List<PartMark>>(
  () => PartMarksNotifier('favorite_parts'),
);

final watchedPartsProvider =
    NotifierProvider<PartMarksNotifier, List<PartMark>>(
  () => PartMarksNotifier('watched_parts'),
);

final watchlistPartsProvider =
    NotifierProvider<PartMarksNotifier, List<PartMark>>(
  () => PartMarksNotifier('watchlist_parts'),
);
