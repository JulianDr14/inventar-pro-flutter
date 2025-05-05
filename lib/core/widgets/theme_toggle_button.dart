import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intentary_pro/core/di/theme_providers.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode mode = ref.watch(themeModeProvider);

    return IconButton(
      onPressed: () {
        ref.read(themeModeProvider.notifier).state =
            mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      },
      tooltip:
          mode == ThemeMode.dark
              ? 'Cambiar a tema claro'
              : 'Cambiar a tema oscuro',
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, anim) {
          return RotationTransition(
            turns: Tween<double>(begin: 0.75, end: 1).animate(anim),
            child: FadeTransition(opacity: anim, child: child),
          );
        },
        child: Icon(
          mode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
          key: ValueKey<ThemeMode>(mode),
          size: 24,
        ),
      ),
    );
  }
}
