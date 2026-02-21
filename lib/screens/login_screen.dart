import 'package:flutter/material.dart';
// IMPORTATION IMPORTANTE :
import 'loading_screen.dart'; // <-- Assure-toi de créer ce fichier avec le code précédent

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // 1. Simulation d'une petite vérification réseau (1 seconde suffit ici)
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isLoading = false;
      });

      // 2. Vérification des identifiants
      if (_emailController.text == "admin@test.com" &&
          _passwordController.text == "123456") {
        if (mounted) {
          // 3. NAVIGATION VERS LE LOADING SCREEN DE 5 SECONDES
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoadingScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Identifiants incorrects (admin@test.com / 123456)"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... Le reste de ton code build (UI) reste identique ...
    // Le bouton de connexion appellera maintenant le LoadingScreen en cas de succès
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header (Ton code actuel...)
            Container(
              height: 320,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_person_rounded,
                    size: 90,
                    color: Colors.white,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "TECH STORE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "Bienvenue !",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFF1A237E),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Veuillez entrer votre email" : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Mot de passe",
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFF1A237E),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: (value) =>
                          value!.length < 6 ? "Minimum 6 caractères" : null,
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A237E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  color: Color(0xFF00B8D4),
                                  strokeWidth: 3,
                                ),
                              )
                            : const Text(
                                "SE CONNECTER",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
