import 'package:flutter/material.dart';
import 'loading_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // État pour gérer l'affichage du spinner sur le bouton
  bool _isLoading = false;

  // Clé globale pour identifier et valider le formulaire
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour récupérer les textes saisis
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // --- LOGIQUE DE CONNEXION ---
  void _handleLogin() async {
    // Vérification de la validité des champs du formulaire
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Active l'indicateur de chargement
      });

      // Simulation d'un délai réseau (ex: appel API)
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isLoading = false; // Désactive l'indicateur
      });

      // Vérification statique des identifiants (Admin Test)
      if (_emailController.text == "fmardoche89@gmail.com" &&
          _passwordController.text == "dieune@123") {
        if (mounted) {
          // Redirection vers l'écran de chargement
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoadingScreen()),
          );
        }
      } else {
        // Affichage d'une erreur si les identifiants sont faux
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- EN-TÊTE (HEADER) ---
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

            // --- CORPS DU FORMULAIRE ---
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

                    // Champ Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
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

                    // Champ Mot de Passe
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

                    // --- BOUTON DE CONNEXION ---
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
                                  color: Colors.white,
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
