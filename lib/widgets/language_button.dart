import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/language_provider.dart';

class LanguageButton extends ConsumerWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);

    return PopupMenuButton<String>(
      
      tooltip: 'Language',
      initialValue: language,
      onSelected: (value) => ref.read(languageProvider.notifier).setLanguage(value),
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'he-IL', child: Text('Hebrew')),
        PopupMenuItem(value: 'en-US', child: Text('English')),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language),
            const SizedBox(width: 6),
            Text(language == 'he-IL' ? 'HE' : 'EN'),
          ],
        ),
      ),
    );
  }
}