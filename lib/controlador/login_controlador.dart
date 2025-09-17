import 'package:flutter_application_7/servicios/login_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_7/modelos/usuarios.dart';
import 'package:flutter_application_7/pantallas/home_page.dart';

class LoginControlador {
  final LoginService _loginService = LoginService();

  Future<bool> login(
    String usuario,
    String contrasenia,
    BuildContext context,
  ) async {
    try {
      dynamic response = await _loginService.login(usuario, contrasenia);

      if (response is Map<String, dynamic>) {
        if (response.containsKey('error')) {
          if (response['error'] == 'Credenciales inválidas') {
            print("==================================");
            print("❌ ERROR: Contraseña o usuario incorrecto");
            print("Usuario: $usuario");
            print("==================================");
          } else {
            print("==================================");
            print("❌ ERROR: ${response['error']}");
            print("==================================");
          }

          _mostrarError(context, response['error']);
          return false;
        }

        Usuario user = Usuario.fromJson(response);

        print("==================================");
        print("✅ LOGIN EXITOSO");
        print("Cédula: ${user.cedulaUsuario}");
        print("Nombres: ${user.nombresUsuario}");
        print("Apellidos: ${user.apellidosUsuarios}");
        print("==================================");

        _mostrarExito(context, user);
        return true;
      } else if (response is List && response.isNotEmpty) {
        Usuario user = Usuario.fromJson(response[0]);

        print("==================================");
        print("✅ LOGIN EXITOSO");
        print("Cédula: ${user.cedulaUsuario}");
        print("Nombres: ${user.nombresUsuario}");
        print("Apellidos: ${user.apellidosUsuarios}");
        print("==================================");

        _mostrarExito(context, user);
        return true;
      } else {
        print("==================================");
        print("❌ ERROR: Respuesta inesperada del servidor");
        print("==================================");

        _mostrarError(context, 'Respuesta inesperada del servidor');
        return false;
      }
    } on Exception catch (e) {
      print("==================================");
      print("❌ ERROR: ${e.toString().replaceAll('Exception: ', '')}");
      print("==================================");

      _mostrarError(context, e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  void _mostrarExito(BuildContext context, Usuario user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Bienvenido ${user.nombresUsuario}!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _mostrarError(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }
}
