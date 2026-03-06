import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSettingItem(Icons.person_outline_rounded, 'Perfil do Administrador'),
        _buildSettingItem(Icons.notifications_none_rounded, 'Notificações'),
        _buildSettingItem(Icons.security_rounded, 'Segurança e Senha'),
        _buildSettingItem(Icons.help_outline_rounded, 'Ajuda e Suporte'),
        _buildSettingItem(Icons.info_outline_rounded, 'Sobre o App'),
        const SizedBox(height: 20),
        const Divider(),
        _buildSettingItem(Icons.logout_rounded, 'Sair da Conta', color: Colors.redAccent),
      ],
    );
  }

  Widget _buildSettingItem(IconData icon, String title, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? const Color(0xFF1A1A1A)),
      title: Text(title, style: TextStyle(color: color ?? const Color(0xFF1A1A1A), fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: () {},
    );
  }
}
