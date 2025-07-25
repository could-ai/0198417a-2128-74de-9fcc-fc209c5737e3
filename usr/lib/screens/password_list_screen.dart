import 'package:flutter/material.dart';
import '../models/password_model.dart';
import 'add_edit_password_screen.dart';

class PasswordListScreen extends StatefulWidget {
  const PasswordListScreen({super.key});

  @override
  State<PasswordListScreen> createState() => _PasswordListScreenState();
}

class _PasswordListScreenState extends State<PasswordListScreen> {
  // This is a placeholder for your password data.
  // In a real application, you would fetch this from a secure database.
  // I am using a local list here because no Supabase project is selected.
  final List<Password> _passwords = [
    Password(id: '1', website: 'Google', username: 'user@gmail.com', password: 'password123'),
    Password(id: '2', website: 'Facebook', username: 'user@facebook.com', password: 'password456'),
  ];

  void _addOrUpdatePassword(Password password) {
    final existingIndex = _passwords.indexWhere((p) => p.id == password.id);
    setState(() {
      if (existingIndex >= 0) {
        _passwords[existingIndex] = password;
      } else {
        _passwords.add(password);
      }
    });
  }

  void _navigateToAddEditScreen([Password? password]) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditPasswordScreen(password: password),
      ),
    );

    if (result != null && result is Password) {
      _addOrUpdatePassword(result);
    }
  }

  void _deletePassword(String id) {
    // NOTE: This is where you would typically delete data from a database.
    // Since no Supabase project is selected, we are just removing from the local list.
    setState(() {
      _passwords.removeWhere((p) => p.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password deleted.'), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Manager'),
      ),
      body: _passwords.isEmpty
          ? const Center(
              child: Text(
                'No passwords saved yet.\nTap the + button to add one!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _passwords.length,
              itemBuilder: (context, index) {
                final password = _passwords[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.lock_outline, size: 40),
                    title: Text(password.website, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(password.username),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            // In a real app, you'd copy the password to the clipboard
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Password copied (not really!)')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _deletePassword(password.id),
                        ),
                      ],
                    ),
                    onTap: () => _navigateToAddEditScreen(password),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditScreen(),
        tooltip: 'Add Password',
        child: const Icon(Icons.add),
      ),
    );
  }
}
