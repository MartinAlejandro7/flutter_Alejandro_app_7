import 'package:dio/dio.dart';
import 'package:flutter_application_7/servicios/api_service.dart';

// lib/servicios/registro_service.dart
class RegistroService {
  ApiService service = ApiService();

  Future<void> registrar(
    String cedula,
    String nombres,
    String apellidos,
    String correo,
    String nomlogin,
    String contrasenia,
    String idRol,
  ) async {
    try {
      final response = await Dio().post(
        service.urlRegistro(),
        data: {
          'cedulaUsuario': cedula,
          'nombresUsuario': nombres,
          'apellidosUsuarios': apellidos,
          'correoUsuario': correo,
          'nomloginUsuario': nomlogin,
          'contraseniaUsuario': contrasenia,
          'idRol': idRol,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al registrar usuario');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}
