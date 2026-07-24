import 'package:cardifly/utils/constants.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final subtle = Theme.of(context).textTheme.displaySmall?.color;
    return Drawer(
      width: 260,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Constants.appPrimaryColor,
                          Constants.appPrimaryColor.withValues(alpha: 0.75),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.credit_card_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cardifly',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Bonjour, invité',
                          style: TextStyle(fontSize: 10, color: Colors.black45),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: Colors.black.withValues(alpha: 0.06),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 6),
                children: const [
                  _DrawerItem(
                    icon: Icons.credit_card_rounded,
                    label: 'Mes cartes',
                    selected: true,
                  ),
                  _DrawerItem(
                    icon: Icons.favorite_border_rounded,
                    label: 'Favoris',
                  ),
                  _DrawerItem(
                    icon: Icons.history_rounded,
                    label: 'Historique',
                  ),
                  _DrawerItem(
                    icon: Icons.settings_outlined,
                    label: 'Paramètres',
                  ),
                  _DrawerItem(
                    icon: Icons.help_outline_rounded,
                    label: 'Aide',
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: Colors.black.withValues(alpha: 0.06),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  const Icon(Icons.logout_rounded,
                      size: 16, color: Colors.redAccent),
                  const SizedBox(width: 10),
                  Text(
                    'Déconnexion',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.redAccent.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'v${Constants.appVersion}',
                    style: TextStyle(fontSize: 10, color: subtle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? Constants.appPrimaryColor.withValues(alpha: 0.10)
        : Colors.transparent;
    final fg = selected
        ? Constants.appPrimaryColor
        : Theme.of(context).iconTheme.color;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => Navigator.of(context).maybePop(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Icon(icon, size: 16, color: fg),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.w500,
                    color: fg,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
