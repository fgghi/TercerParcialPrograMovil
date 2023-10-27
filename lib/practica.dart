class AuthService {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    if (email == 'demo' && password == 'demo') {
      _isLoggedIn = true;
      return true;
    }
    return false;
  }

  void signOut() {
    _isLoggedIn = false;
  }
}
