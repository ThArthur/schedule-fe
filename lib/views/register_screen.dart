import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final theme = Theme.of(context);
    final goldColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                'Criar Conta',
                textAlign: TextAlign.left,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF2D2D2D),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'PSIQUE LOUNGE',
                textAlign: TextAlign.left,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: goldColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Preencha os dados abaixo para começar.',
                textAlign: TextAlign.left,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                controller: _nameController,
                label: 'Nome Completo',
                prefixIcon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                label: 'Senha',
                isPassword: true,
                prefixIcon: Icons.lock_outline_rounded,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _confirmPasswordController,
                label: 'Confirmar Senha',
                isPassword: true,
                prefixIcon: Icons.lock_reset_rounded,
              ),
              const SizedBox(height: 40),
              authViewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () async {
                        if (_passwordController.text != _confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('As senhas não coincidem.'),
                              backgroundColor: Colors.orangeAccent,
                            ),
                          );
                          return;
                        }
                        
                        final success = await authViewModel.register(
                          _nameController.text,
                          _emailController.text,
                          _passwordController.text,
                        );
                        
                        if (success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Conta criada! Faça seu login.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.of(context).pop();
                        } else if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Erro ao registrar. Tente novamente.'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A1A),
                        foregroundColor: goldColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: goldColor, width: 0.5),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'CADASTRAR',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                      ),
                    ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
