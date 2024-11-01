import 'package:flutter/material.dart'
    show Widget, BuildContext, StatefulWidget, Icon, Icons, State, IconButton, PopupMenuDivider, PopupMenuItem, ListTile, RelativeRect, Color, Text, Colors, RoundedRectangleBorder, BorderRadius, showMenu;
    
class CustomPopupMenu extends StatefulWidget {
  final Function(int) onItemSelected;

  const CustomPopupMenu({super.key, required this.onItemSelected});

  @override
  State<CustomPopupMenu> createState() => _CustomPopupMenuState();
}

class _CustomPopupMenuState extends State<CustomPopupMenu> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.account_circle,
          color: Color.fromRGBO(232, 232, 232, 1)),
      onPressed: () {
        _showPopupMenu(context);
      },
    );
  }

  // Méthode pour afficher le menu déroulant
  void _showPopupMenu(BuildContext context) async {
    // Affiche le menu et stocke le résultat
    final result = await showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(1000, 70, 0, 0),
      items: [
        PopupMenuItem<int>(
          value: 1,
          child: ListTile(
            leading: const Icon(Icons.person, color: Colors.black),
            title: const Text('Profil'),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<int>(
          value: 2,
          child: ListTile(
            leading: const Icon(Icons.logout, color: Colors.black),
            title: const Text('Déconnexion'),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    // Vérifie si le widget est monté avant d'utiliser le context
    if (mounted) {
      // Vérifie le résultat
      if (result != null) { 
        widget.onItemSelected(result);
      }
    }
  }
}
