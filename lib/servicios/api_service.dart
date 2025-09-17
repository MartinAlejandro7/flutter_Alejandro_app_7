class ApiService {
  final String baseUrl = "http://192.168.100.91/APIJAPON_V1/APIAPPJAPON";

  // Método para login (POST)
  String urlLogin() => '$baseUrl/login.php';

  // Método para registrar usuarios (POST)
  String urlRegistro() => '$baseUrl/usuario.php';
}
