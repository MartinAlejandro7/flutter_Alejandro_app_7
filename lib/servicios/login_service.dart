import 'package:dio/dio.dart';
import 'package:flutter_application_7/servicios/api_service.dart';

class LoginService {
  ApiService service = ApiService();

  Future<dynamic> login(String correo, String contrasenia) async {
    try {
      final response = await Dio().post(
        service.urlLogin(),
        data: {'nomloginUsuario': correo, 'contraseniaUsuario': contrasenia},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error en la respuesta del servidor');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw Exception('No hay conexión con el servidor');
      } else {
        throw Exception('Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error desconocido: $e');
    }
  }
}
