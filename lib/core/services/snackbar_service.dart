import 'package:flutter/material.dart';

enum SnackbarType { error, success, info }

/// Servicio para mostrar un Snackbar
class SnackbarService {
  SnackbarService._();

  /// Muestra un Snackbar animado según el [type].
  static void show(
      BuildContext context, {
        required String message,
        SnackbarType type = SnackbarType.success,
        Duration duration = const Duration(seconds: 2),
        SnackBarAction? action,
      }) {
    final _Config config = _Config.fromType(type);

    final OverlayState overlay = Overlay.of(context);

    late OverlayEntry entry;
    final AnimationController controller = AnimationController(
      vsync: overlay,
      duration: const Duration(milliseconds: 300),
    );
    final CurvedAnimation curved = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    );

    entry = OverlayEntry(
      builder: (ctx) => Positioned(
        bottom: 20,
        left: 20,
        right: 20,
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
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(config.icon, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  if (action != null)
                    TextButton(
                      onPressed: () {
                        action.onPressed();
                        controller.reverse();
                      },
                      child: Text(
                        action.label,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    controller.forward();

    Future.delayed(duration + const Duration(milliseconds: 300))
        .then((_) => controller.reverse())
        .then((_) => entry.remove());
  }
}

class _Config {
  final IconData icon;
  final Color color;

  const _Config({required this.icon, required this.color});

  factory _Config.fromType(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return const _Config(
          icon: Icons.check_circle,
          color: Colors.green,
        );
      case SnackbarType.info:
        return const _Config(
          icon: Icons.info_outline,
          color: Colors.blue,
        );
      case SnackbarType.error:
      return const _Config(
          icon: Icons.error_outline,
          color: Colors.redAccent,
        );
    }
  }
}