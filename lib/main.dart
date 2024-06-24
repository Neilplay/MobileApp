import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'homepage.dart';
import 'themeProvider.dart';
import 'databaseService.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Trash System',
          theme: ThemeData(
            brightness:
                themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
            primarySwatch: Colors.green,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const LoginPage(),
        );
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    Map<String, dynamic> userData =
        await DatabaseService().getUserByEmail(email);
    if (userData.isNotEmpty && userData['password'] == password) {
      int userId = userData['id'];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userId: userId)),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Invalid email or password. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF66BB6A), Color(0xFF81C784)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Trash System',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 48.0),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    labelStyle: TextStyle(color: Colors.white),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegistrationPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Don\'t have an account? Register',
                    style: TextStyle(color: Colors.white),
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

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String name = _nameController.text;

    Map<String, dynamic> userData =
        await DatabaseService().getUserByEmail(email);

    if (userData.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Registration Failed'),
            content: const Text('Email already exists. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      await DatabaseService().createUser(email, password, name);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF66BB6A), Color(0xFF81C784)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Register',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 48.0),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person, color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.white,
                ),
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
