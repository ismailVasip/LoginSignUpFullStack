class ApiUrls {
  static const baseUrl = 'http://10.0.2.2:5124/';
  static const register = '${baseUrl}api/auth/register';
  static const login = '${baseUrl}api/auth/login';
  static const forgotPassword = '${baseUrl}api/auth/forgot-password';
  static const verifyCode = '${baseUrl}api/auth/verify-reset-code';
  static const resetPassword = '${baseUrl}api/auth/reset-password';
  static const getUsers = '${baseUrl}api/user';  
}