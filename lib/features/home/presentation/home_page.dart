import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intentary_pro/features/inventory/presentation/pages/product_list_page.dart';
import 'package:intentary_pro/features/movements/presentation/pages/movements_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<_NavItem> _items = <_NavItem>[
    _NavItem(
      title: 'Inventario',
      icon: Icons.list_alt,
      page: ProductListPage(),
    ),
    _NavItem(
      title: 'Ordenes',
      icon: Icons.settings,
      page: MovementsListPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: Text(_items[_selectedIndex].title)),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primary),
              child: const Center(
                child: Text('Menú', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
            ),
            ...List.generate(_items.length, (i) {
              final _NavItem item = _items[i];
              final bool selected = i == _selectedIndex;
              final Color color = selected ? primary : Colors.grey.shade600;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Material(
                  color: selected
                      ? primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    leading: Icon(item.icon, color: color),
                    title: Text(item.title, style: TextStyle(color: color)),
                    selected: selected,
                    onTap: () {
                      setState(() => _selectedIndex = i);
                      context.pop();
                    },
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _items.map((e) => e.page).toList(),
      ),
    );
  }
}

class _NavItem {
  final String title;
  final IconData icon;
  final Widget page;
  const _NavItem({required this.title, required this.icon, required this.page});
}