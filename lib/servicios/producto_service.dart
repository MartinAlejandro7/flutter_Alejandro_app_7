import 'package:dio/dio.dart';
import 'package:flutter_application_7/servicios/api_service.dart';
import 'package:flutter_application_7/modelos/producto.dart';

class ProductoService {
  final ApiService service = ApiService();
  final Dio _dio = Dio();

  Future<List<Producto>> getProductos(int idCategoria) async {
    try {
      final response = await _dio.get(
        service.urlProductos(),
        queryParameters: {'idCategoria': idCategoria},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Producto.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener productos');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  /// ✅ Método para crear producto
  Future<void> crearProducto(
    String nombre,
    String descripcion,
    double precio,
    int idCategoria,
  ) async {
    try {
      final response = await _dio.post(
        service.urlProductos(),
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          'nombre': nombre,
          'descripcion': descripcion,
          'precio': precio,
          'idCategoria': idCategoria,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Error al crear producto: ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión al crear producto: ${e.message}');
    }
  }
}
