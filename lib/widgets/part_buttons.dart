import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../models/part_mark.dart';
import '../providers/part_marks_provider.dart';
import '../theme/app_theme.dart';

class PartButtons extends ConsumerWidget {
  final Movie series;
  final String part;
  final List<String> watchParts;

  const PartButtons({
    super.key,
    required this.series,
    required this.part,
    required this.watchParts,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mark = PartMark(series: series, part: part);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _button(
          ref,
          favoritePartsProvider,
          mark,
          Icons.favorite,
          Icons.favorite_border,
        ),
        _button(
          ref,
          watchlistPartsProvider,
          mark,
          Icons.bookmark,
          Icons.bookmark_border,
        ),
        _watchButton(ref),
      ],
    );
  }

  Widget _button(
    WidgetRef ref,
    NotifierProvider<PartMarksNotifier, List<PartMark>> provider,
    PartMark mark,
    IconData iconOn,
    IconData iconOff,
  ) {
    final isMarked = ref.watch(provider).any((m) => m.isSame(mark));
    return _icon(
      isMarked ? iconOn : iconOff,
      isMarked,
      () => ref.read(provider.notifier).toggle(mark),
    );
  }

  Widget _watchButton(WidgetRef ref) {
    final marks = [
      for (final p in watchParts) PartMark(series: series, part: p),
    ];
    final watched = ref.watch(watchedPartsProvider);
    final count = marks.where((m) => watched.any((w) => w.isSame(m))).length;
    final isAll = marks.isNotEmpty && count == marks.length;
    return _icon(
      isAll ? Icons.check_circle : Icons.check_circle_outline,
      isAll,
      () => ref.read(watchedPartsProvider.notifier).setAll(marks, !isAll),
    );
  }

  Widget _icon(IconData icon, bool isOn, VoidCallback onPressed) {
    return IconButton(
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(),
      iconSize: 18,
      icon: Icon(
        icon,
        color: isOn ? AppColors.accent : AppColors.textSecondary,
      ),
      onPressed: onPressed,
    );
  }
}
