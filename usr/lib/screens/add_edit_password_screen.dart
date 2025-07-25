import 'package:flutter/material.dart';
import '../models/password_model.dart';

class AddEditPasswordScreen extends StatefulWidget {
  final Password? password;

  const AddEditPasswordScreen({super.key, this.password});

  @override
  State<AddEditPasswordScreen> createState() => _AddEditPasswordScreenState();
}

class _AddEditPasswordScreenState extends State<AddEditPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _websiteController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _websiteController = TextEditingController(text: widget.password?.website ?? '');
    _usernameController = TextEditingController(text: widget.password?.username ?? '');
    _passwordController = TextEditingController(text: widget.password?.password ?? '');
  }

  @override
  void dispose() {
    _websiteController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // NOTE: This is where you would typically save the data to a database.
      // Since no Supabase project is selected, we will just pop the screen
      // with the new data. In a real app, you would handle the database
      // operation here.
      final newPassword = Password(
        id: widget.password?.id ?? DateTime.now().toString(),
        website: _websiteController.text,
        username: _usernameController.text,
        password: _passwordController.text,
      );
      Navigator.of(context).pop(newPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.password == null ? 'Add Password' : 'Edit Password'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(
                  labelText: 'Website/Service',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a website or service name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username/Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username or email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
