class ApiService {
  // Stub for future API calls
  static const String baseUrl = 'https://api.example.com/v1';

  Future<Map<String, dynamic>> login(String email, String password) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'user@example.com' && password == 'password') {
      return {'status': 'success', 'token': 'dummy_token'};
    }
    throw Exception('Invalid credentials');
  }

  Future<Map<String, dynamic>> signup(Map<String, dynamic> userData) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 2));
    return {'status': 'success', 'token': 'dummy_token'};
  }
}
