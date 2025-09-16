class ApiService {
  final String baseUrl = "http://192.168.100.91/APIJAPON_V1/APIAPPJAPON";

  String urlLogin(String nomloginUsuario, String contraseniaUsuario) =>
      '$baseUrl/login.php?nomloginUsuario=$nomloginUsuario&contraseniaUsuario=$contraseniaUsuario';
}
