import 'package:flutter/material.dart';
import 'package:flutter_application_7/servicios/registro_service.dart';

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _nomloginController = TextEditingController();
  final TextEditingController _contraseniaController = TextEditingController();
  final TextEditingController _idRolController = TextEditingController();

  final RegistroService _registroService = RegistroService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Registro de Usuario'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¡Crea tu cuenta!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Completa los campos para registrarte',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            _buildTextField(_cedulaController, 'Cédula', Icons.assignment),
            const SizedBox(height: 16),
            _buildTextField(_nombresController, 'Nombres', Icons.person),
            const SizedBox(height: 16),
            _buildTextField(_apellidosController, 'Apellidos', Icons.people),
            const SizedBox(height: 16),
            _buildTextField(
              _correoController,
              'Correo electrónico',
              Icons.email,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              _nomloginController,
              'Nombre de usuario',
              Icons.account_circle,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              _contraseniaController,
              'Contraseña',
              Icons.lock,
              isObscure: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              _idRolController,
              'ID Rol (1=Admin, 2=Usuario)',
              Icons.vpn_key,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formIsValid()) {
                    try {
                      await _registroService.registrar(
                        _cedulaController.text,
                        _nombresController.text,
                        _apellidosController.text,
                        _correoController.text,
                        _nomloginController.text,
                        _contraseniaController.text,
                        _idRolController.text,
                      );

                      // ✅ LIMPIA LOS CAMPOS
                      _clearFields();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('✅ ¡Registro exitoso!'),
                        ),
                      );

                      // Opcional: vuelve al login automáticamente
                      // Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('❌ Error: $e'),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text(
                  'Registrar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  '← Volver al Login',
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isObscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple),
        ),
        filled: true,
        fillColor: Colors.white,
        hoverColor: Colors.deepPurple.withOpacity(0.1),
      ),
    );
  }

  bool _formIsValid() {
    if (_cedulaController.text.isEmpty ||
        _nombresController.text.isEmpty ||
        _apellidosController.text.isEmpty ||
        _correoController.text.isEmpty ||
        _nomloginController.text.isEmpty ||
        _contraseniaController.text.isEmpty ||
        _idRolController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Completa todos los campos')),
      );
      return false;
    }
    return true;
  }

  void _clearFields() {
    _cedulaController.clear();
    _nombresController.clear();
    _apellidosController.clear();
    _correoController.clear();
    _nomloginController.clear();
    _contraseniaController.clear();
    _idRolController.clear();
  }
}
