import 'package:flutter_riverpod/flutter_riverpod.dart';

class MediaTypeNotifier extends Notifier<String> {
  @override
  String build() => 'movie';

  void toggleMediaType() {
    state = state == 'movie' ? 'tv' : 'movie';
  }
}

final mediaTypeProvider = NotifierProvider<MediaTypeNotifier, String>(
  MediaTypeNotifier.new,
);
