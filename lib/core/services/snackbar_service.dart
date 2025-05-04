import 'dart:async';
import 'package:flutter/material.dart';

enum SnackbarType { error, success, info }

class SnackbarService {
  SnackbarService._();

  static const int _maxSnackbars = 5;
  static const Duration _killerInterval = Duration(seconds: 30);

  static final List<_SnackbarData> _active = [];
  static Timer? _killerTimer;

  static void show(
      BuildContext context, {
        required String message,
        SnackbarType type = SnackbarType.success,
        Duration duration = const Duration(seconds: 3),
        SnackBarAction? action,
      }) {
    final _Config config = _Config.fromType(type);
    final OverlayState overlay = Overlay.of(context);

    // Limitar a 5
    if (_active.length >= _maxSnackbars) {
      final oldest = _active.first;
      _dismiss(oldest.entry, oldest.controller);
    }

    // Creacion del controller
    final AnimationController controller = AnimationController(
      vsync: overlay,
      duration: const Duration(milliseconds: 300),
    );
    final CurvedAnimation curved = CurvedAnimation(parent: controller, curve: Curves.easeOutCubic);

    // Calcula la posición con overlap
    const double baseMargin = 60;
    const double estimatedHeight = 60;
    const double overlap = 50;
    final int index = _active.length;
    final double bottomOffset = baseMargin + index * (estimatedHeight - overlap);

    late OverlayEntry entry;
    entry = OverlayEntry(builder: (_) {
      return Positioned(
        left: baseMargin,
        right: baseMargin,
        bottom: bottomOffset,
        child: Dismissible(
          key: UniqueKey(),
          confirmDismiss: (_) async => true,
          onDismissed: (_) => _dismiss(entry, controller),
          background: const SizedBox.shrink(),
          secondaryBackground: const SizedBox.shrink(),
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0,1), end: Offset.zero)
                .animate(curved),
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

    // Registrar datos y animar
    final DateTime expiry = DateTime.now().add(duration + const Duration(milliseconds: 300));
    _active.add(_SnackbarData(entry, controller, expiry));
    controller.forward();

    // Auto-dismiss tras el tiempo
    Future.delayed(duration + const Duration(milliseconds: 300))
        .then((_) => _dismiss(entry, controller));

    // Arrancar killer si es necesario
    _startKiller();
  }

  static void _dismiss(OverlayEntry entry, AnimationController controller) {
    final int idx = _active.indexWhere((d) => d.entry == entry);
    if (idx < 0) return;

    // Extraer ANTES de animar
    final _SnackbarData data = _active.removeAt(idx);
    data.controller.reverse().then((_) {
      data.entry.remove();
      data.controller.dispose();
    });
  }

  static void _startKiller() {
    if (_killerTimer != null) return;
    _killerTimer = Timer.periodic(_killerInterval, (_) {
      final DateTime now = DateTime.now();
      for (final _SnackbarData data in List.of(_active)) {
        if (now.isAfter(data.expiryTime)) {
          _dismiss(data.entry, data.controller);
        }
      }
      if (_active.isEmpty) {
        _killerTimer?.cancel();
        _killerTimer = null;
      }
    });
  }
}

class _SnackbarData {
  final OverlayEntry entry;
  final AnimationController controller;
  final DateTime expiryTime;
  _SnackbarData(this.entry, this.controller, this.expiryTime);
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