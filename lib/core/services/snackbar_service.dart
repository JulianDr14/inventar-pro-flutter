import 'package:flutter/material.dart';

enum SnackbarType { error, success, info }

class SnackbarService {
  SnackbarService._();

  static final List<_SnackbarData> _active = [];

  static void show(
      BuildContext context, {
        required String message,
        SnackbarType type = SnackbarType.success,
        Duration duration = const Duration(seconds: 3),
        SnackBarAction? action,
      }) {
    final _Config config = _Config.fromType(type);
    final OverlayState overlay = Overlay.of(context);

    final AnimationController controller = AnimationController(
      vsync: overlay,
      duration: const Duration(milliseconds: 300),
    );
    final CurvedAnimation curved = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    );

    const double baseMargin = 60;
    const double estimatedHeight = 60;
    const double overlap = 50;
    final int index = _active.length;
    final double bottomOffset = baseMargin + index * (estimatedHeight - overlap);

    late OverlayEntry entry;
    entry = OverlayEntry(builder: (ctx) {
      return Positioned(
        left: baseMargin,
        right: baseMargin,
        bottom: bottomOffset,
        child: Dismissible(
          key: UniqueKey(),
          onDismissed: (_) => _dismiss(entry, controller),

          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curved),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: config.color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
                ),
                child: Row(
                  children: [
                    Icon(config.icon, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(message, style: const TextStyle(color: Colors.white)),
                    ),
                    if (action != null)
                      TextButton(
                        onPressed: () {
                          action.onPressed();
                          _dismiss(entry, controller);
                        },
                        child: Text(action.label, style: const TextStyle(color: Colors.white)),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });

    overlay.insert(entry);
    _active.add(_SnackbarData(entry, controller));
    controller.forward();

    Future.delayed(duration + const Duration(milliseconds: 300))
        .then((_) => _dismiss(entry, controller));
  }

  static void _dismiss(OverlayEntry entry, AnimationController controller) {
    final idx = _active.indexWhere((d) => d.entry == entry);
    if (idx < 0) return;

    controller.reverse().then((_) {
      entry.remove();
      controller.dispose();
      _active.removeAt(idx);
    });
  }
}

class _SnackbarData {
  final OverlayEntry entry;
  final AnimationController controller;
  _SnackbarData(this.entry, this.controller);
}

class _Config {
  final IconData icon;
  final Color color;
  const _Config({required this.icon, required this.color});

  factory _Config.fromType(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return const _Config(icon: Icons.check_circle, color: Colors.green);
      case SnackbarType.info:
        return const _Config(icon: Icons.info_outline, color: Colors.blue);
      case SnackbarType.error:
        return const _Config(icon: Icons.error_outline, color: Colors.redAccent);
    }
  }
}