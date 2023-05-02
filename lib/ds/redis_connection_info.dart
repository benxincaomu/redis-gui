class RedisConnectionInfo {
  final int? id;
  final String name;
  final String host;
  final int port;
  final String? userName;
  final String? password;

  const RedisConnectionInfo({
    this.id,
    required this.name,
    required this.host,
    required this.port,
    this.userName,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "host": host,
      "port": port,
      "userName": userName,
      "password": password,
    };
  }
  

}
