class AuthService {
  static User getCurrentUser() {
    // Implement user retrieval logic
    return User(username: 'DummyUser', email: 'dummy@example.com');
  }
}

class User {
  final String username;
  final String email;

  User({required this.username, required this.email});
}
