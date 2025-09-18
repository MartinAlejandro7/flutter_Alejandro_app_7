import 'package:dio/dio.dart';
import 'package:flutter_application_7/servicios/api_service.dart';
import 'package:flutter_application_7/modelos/categoria.dart';

class CategoriaService {
  ApiService service = ApiService();

  Future<List<Categoria>> getCategorias() async {
    try {
      final response = await Dio().get(service.urlCategorias());
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Categoria.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener categorías');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<void> crearCategoria(String nombre) async {
    try {
      final response = await Dio().post(
        service.urlCategorias(),
        data: {'nombre': nombre},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al crear categoría');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}
