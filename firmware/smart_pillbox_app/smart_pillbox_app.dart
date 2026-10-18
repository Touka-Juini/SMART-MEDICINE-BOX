import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SmartPillboxApp());
}

class SmartPillboxApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Pillbox',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: Color(0xFF0D47A1),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0D47A1),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          elevation: 5,
          centerTitle: true,
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.medical_services, size: 100, color: Colors.white),
              SizedBox(height: 20),
              Text(
                "Smart Pillbox",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Bienvenue dans Smart Pillbox",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              _buildCustomCard(context, "Créer un compte", Icons.person_add_alt_1, SignupScreen()),
              SizedBox(height: 20),
              _buildCustomCard(context, "Se connecter", Icons.login, LoginScreen()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomCard(BuildContext context, String text, IconData icon, Widget page) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 250,
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 30),
              SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  // Loading state
  bool _isLoading = false;

  // Sign up function
  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showError("Please fill in all fields");
      return;
    }

    if (password != confirmPassword) {
      _showError("Passwords do not match");
      return;
    }

    setState(() {
      _isLoading = true; // Show loading spinner
    });

    try {
      // Create user with Firebase Auth
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If successful, navigate to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() {
        _isLoading = false; // Hide loading spinner
      });
    }
  }

  // Show error message
  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Créer un compte")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Inscription",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
            ),
            SizedBox(height: 20),
            _buildCustomTextField("Email", Icons.email, controller: _emailController),
            _buildCustomTextField("Mot de passe", Icons.lock, isPassword: true, controller: _passwordController),
            _buildCustomTextField("Confirmer le mot de passe", Icons.lock, isPassword: true, controller: _confirmPasswordController),
            SizedBox(height: 30),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _signUp,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                backgroundColor: Color(0xFF0D47A1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                "S'inscrire",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTextField(String label, IconData icon, {bool isPassword = false, TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Color(0xFF0D47A1)),
          filled: true,
          fillColor: Colors.blueGrey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  // Function to handle sign in
  Future<void> _signIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // If successful, navigate to HomeScreen
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      // Show error message if login fails
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Failed to sign in. Please check your credentials."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Se connecter")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Connexion",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
            ),
            SizedBox(height: 20),
            _buildCustomTextField("Email", Icons.email, controller: _emailController),
            _buildCustomTextField("Mot de passe", Icons.lock, isPassword: true, controller: _passwordController),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _signIn,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                backgroundColor: Color(0xFF0D47A1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                "Se connecter",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            // Add Forgot Password Link
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForgotPasswordScreen(),
                  ),
                );
              },
              child: Text(
                "Mot de passe oublié?",
                style: TextStyle(color: Colors.blue, fontSize: 16, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the custom text fields for email and password
  Widget _buildCustomTextField(String label, IconData icon, {bool isPassword = false, TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Color(0xFF0D47A1)),
          filled: true,
          fillColor: Colors.blueGrey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}


// Forgot Password Screen
class ForgotPasswordScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  Future<void> _resetPassword(BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Succès"),
          content: Text("Un email de réinitialisation a été envoyé."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Erreur"),
          content: Text("Échec de l'envoi de l'email. Vérifiez l'adresse email."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Réinitialiser le mot de passe")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Entrez votre adresse email pour réinitialiser votre mot de passe",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Color(0xFF0D47A1)),
            ),
            SizedBox(height: 20),
            _buildCustomTextField("Email", Icons.email, controller: _emailController),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _resetPassword(context),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                backgroundColor: Color(0xFF0D47A1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                "Réinitialiser",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom text field to match the design of other screens
  Widget _buildCustomTextField(String label, IconData icon, {TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Color(0xFF0D47A1)),
          filled: true,
          fillColor: Colors.blueGrey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu Principal")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCustomCard(context, "Configurer le temps", Icons.access_time, IntervalSetupScreen()),
            SizedBox(height: 20),
            _buildCustomCard(context, "Configurer la dose", Icons.medication, DoseSetupScreen()),
            SizedBox(height: 20),
            // Add the "Voir les analyses" button here
            _buildCustomCard(context, "Voir les analyses", Icons.analytics, AnalysisScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomCard(BuildContext context, String text, IconData icon, Widget page) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF0D47A1), size: 35),
        title: Text(
          text,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFF0D47A1)),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
      ),
    );
  }
}

class IntervalSetupScreen extends StatelessWidget {
  final TextEditingController _openingTimeController = TextEditingController();
  final TextEditingController _closingTimeController = TextEditingController();

  // Function to pick time using TimeOfDay picker
  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    TimeOfDay selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ) ?? TimeOfDay.now();

    // Format the time and update the controller text
    String formattedTime = selectedTime.format(context);
    controller.text = formattedTime;
  }

  // Save interval data to Firestore
  Future<void> _saveIntervalData(BuildContext context) async {
    String openingTime = _openingTimeController.text;
    String closingTime = _closingTimeController.text;

    if (openingTime.isNotEmpty && closingTime.isNotEmpty) {
      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Convert the time strings to DateTime for Firestore (use DateTime to create a Timestamp)
        DateTime openingDateTime = DateTime.parse("2024-01-01 $openingTime:00");  // Date is just a placeholder
        DateTime closingDateTime = DateTime.parse("2024-01-01 $closingTime:00");

        await firestore.collection('intervals').add({
          'openingTime': Timestamp.fromDate(openingDateTime),
          'closingTime': Timestamp.fromDate(closingDateTime),
          'dateTime': Timestamp.now(), // Store current time
        });

        // After saving, navigate back to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (e) {
        // Show error message if data is not saved
        print("Error saving interval data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configurer le temps")),
      body: _buildFormScreen(
        context,
        "Intervalle d'ouverture/fermeture",
        [
          _buildCustomTextField("Temps d'ouverture (HH:MM)", Icons.timer, _openingTimeController, context),
          _buildCustomTextField("Temps de fermeture (HH:MM)", Icons.timer_off, _closingTimeController, context),
        ],
        "Enregistrer",
        context,
        _saveIntervalData,
      ),
    );
  }

  Widget _buildFormScreen(
      BuildContext context,
      String title,
      List<Widget> fields,
      String buttonText,
      BuildContext actionContext,
      Future<void> Function(BuildContext) onSave) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
          ),
          SizedBox(height: 20),
          ...fields,
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              onSave(actionContext); // Call the save function
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              backgroundColor: Color(0xFF0D47A1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              buttonText,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTextField(String label, IconData icon, TextEditingController controller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        readOnly: true, // Make it read-only since we'll use the time picker
        onTap: () {
          // Trigger the time picker when the user taps the text field
          _selectTime(context, controller);
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Color(0xFF0D47A1)),
          filled: true,
          fillColor: Colors.blueGrey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}


class DoseSetupScreen extends StatelessWidget {
  final TextEditingController _doseController = TextEditingController();

  // Save dose data to Firestore
  Future<void> _saveDoseData(BuildContext context) async {
    String doseQuantity = _doseController.text;

    if (doseQuantity.isNotEmpty) {
      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        await firestore.collection('doses').add({
          'doseQuantity': doseQuantity,
          'dateTime': Timestamp.now(), // Use timestamp to store the current time
        });

        // After saving, navigate back to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (e) {
        // Show error message if data is not saved
        print("Error saving dose data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configurer la dose")),
      body: _buildFormScreen(
        context,
        "Configuration de la dose",
        [
          _buildCustomTextField("Quantité (mg)", Icons.medical_services),
        ],
        "Enregistrer",
        context,
        _saveDoseData,
      ),
    );
  }

  Widget _buildFormScreen(
      BuildContext context,
      String title,
      List<Widget> fields,
      String buttonText,
      BuildContext actionContext,
      Future<void> Function(BuildContext) onSave) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
          ),
          SizedBox(height: 20),
          ...fields,
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              onSave(actionContext); // Call the save function
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              backgroundColor: Color(0xFF0D47A1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              buttonText,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTextField(String label, IconData icon, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: _doseController, // Attach the controller
        obscureText: isPassword,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Color(0xFF0D47A1)),
          filled: true,
          fillColor: Colors.blueGrey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class AnalysisScreen extends StatefulWidget {
  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  List<Map<String, dynamic>> pillStatusList = [];

  @override
  void initState() {
    super.initState();
    fetchPillData();
  }

  // Fetch pill data from Firebase
  Future<void> fetchPillData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      // Fetch all documents in the 'pillStatus' collection
      QuerySnapshot snapshot = await firestore.collection('pillStatus').get();
      List<QueryDocumentSnapshot> docs = snapshot.docs;

      // Clear previous data
      pillStatusList.clear();

      // Process data to build pill status list
      for (var doc in docs) {
        bool taken = doc['taken'] ?? false; // Default to false if 'taken' field doesn't exist
        String pillId = doc.id;  // Use the document ID (pill_001, pill_002, etc.)

        pillStatusList.add({
          'pillId': pillId,
          'taken': taken,
        });
      }

      // Trigger UI update after data is fetched
      setState(() {});
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Analyse des Médicaments")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Statut des Pilules",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Check if pillStatusList is not empty
            if (pillStatusList.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: pillStatusList.length,
                  itemBuilder: (context, index) {
                    var pill = pillStatusList[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Icon(
                          pill['taken'] ? Icons.check_circle : Icons.cancel,
                          color: pill['taken'] ? Colors.green : Colors.red,
                          size: 30,
                        ),
                        title: Text(
                          'Pill ID: ${pill['pillId']}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          pill['taken'] ? 'Pill Taken' : 'Pill Missed',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Center(child: CircularProgressIndicator()), // Loading spinner if data is empty
          ],
        ),
      ),
    );
  }
}

```
