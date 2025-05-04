# 🔐 Login & Signup App (Flutter Frontend)

This project is a modern user authentication application developed with Flutter. The application supports all basic authentication scenarios such as user registration, login, and "forgot password" processes. The project is written in accordance with Clean Architecture, BLoC (Cubit) state management, modern UI/UX, and layered structure principles. The backend is developed with ASP.NET Core Web API.

## 📱 Screens
- Login Screen
- Register Screen
- Forgot Password Screen
- Verification Code Screen
- Reset Password Screen

## 🧠 Architecture: Clean Architecture
The project applies Clean Architecture principles. Folder structure:

```
lib/
├── common/                # Common components, UI widgets, Cubits
├── core/                  # General definitions, error classes, network support
├── features/
│   └── auth/
│       ├── data/          # API calls (Dio), data models (DTO)
│       ├── domain/        # Entities, UseCases
│       ├── presentation/  # Screens, Cubits, widgets
```

This layered structure enhances testability, maintainability, and readability.

## 🧩 Used Packages
| Package | Description |
|---------|-------------|
| flutter_bloc | State management with BLoC/Cubit |
| get_it | Dependency Injection (service locator) |
| flutter_secure_storage | Secure local storage (e.g., tokens) |
| dio | HTTP client (API calls) |
| dartz | Functional programming, for Either type |

## 🧠 State Management and Repository Pattern
The project uses the BLoC/Cubit pattern for state management. The repository pattern abstracts the data layer:

- **AuthRepository**: Repository interface for authentication operations
- **AuthApiService**: Service layer for API calls
- **UseCases**: Separate use case classes for each operation (SignIn, SignUp, ResetPassword, etc.)

Example usage:

```dart
Future<Either> signIn(SignInRequestParams signInReq) async {
  Either result = await serviceLocator<AuthApiService>().signIn(signInReq);

  return result.fold(
    (error) {
      return Left(error);
    },
    (data) async {
      Response response = data;
      final storage = const FlutterSecureStorage();
      final token = response.data['accessToken'] as String?;

      await storage.write(key: 'access_token', value: token);

      return Right(response);
    },
  );
}
```

## 🔑 Token Management
The application uses `flutter_secure_storage` to securely store authentication tokens:

- **access_token**: Token received after user login
- **reset_token**: Temporary token received for password reset process

## 🧪 Verification Flow
1. User enters email on the "Forgot Password" screen
2. Request is sent to the backend
3. User enters the verification code
4. Code is sent to the backend and verified
5. If verification is successful, the user is redirected to the "Reset Password" screen
6. A new password is set, and the process is completed

## 🚀 Getting Started
```bash
flutter pub get
flutter run
```

## 📂 Backend Integration
This frontend works in integration with the following backend project developed with ASP.NET Core Web API:
https://github.com/ismailVasip/LoginSignUpFullStack/tree/main/login_signup_backend

## 🧑‍💻 Developer
İsmail Vasip

Through this project, I gained experience in Clean Architecture, Cubit/BLoC structure, and sustainable frontend development in Flutter. I ensured the code is readable, testable, and extendable. I applied modern UI/UX principles to enhance the user experience.
.......................................................................................

# 🔐 Login & Signup App (Flutter Frontend)

Bu proje, Flutter ile geliştirilmiş modern bir kullanıcı kimlik doğrulama uygulamasıdır. Uygulama, kullanıcıların kayıt olması, giriş yapması, "şifremi unuttum" işlemleri gibi tüm temel auth senaryolarını destekler. Proje, Clean Architecture, BLoC (Cubit) state management, modern UI/UX ve katmanlı yapı prensipleri doğrultusunda yazılmıştır. Backend ASP.NET Core Web API ile geliştirilmiştir.

## 📱 Ekranlar
- Giriş (Login) Ekranı
- Kayıt (Register) Ekranı
- Şifremi Unuttum (Forgot Password) Ekranı
- Doğrulama Kodu (Verification Code) Ekranı
- Şifre Sıfırlama (Reset Password) Ekranı

## 🧠 Mimari: Clean Architecture
Projede Clean Architecture prensipleri uygulanmıştır. Klasör yapısı:

```
lib/
├── common/                # Ortak bileşenler, UI widget'ları, Cubit'ler
├── core/                  # Genel tanımlar, hata sınıfları, network desteği
├── features/
│   └── auth/
│       ├── data/          # API çağrıları (Dio), veri modelleri (DTO)
│       ├── domain/        # Entity'ler, UseCase'ler
│       ├── presentation/  # Ekranlar, Cubit'ler, widget'lar
```

Bu katmanlı yapı, test edilebilirliği, sürdürülebilirliği ve okunabilirliği artırır.

## 🧩 Kullanılan Paketler
| Paket | Açıklama |
|-------|----------|
| flutter_bloc | BLoC/Cubit ile state management |
| get_it | Dependency Injection (servis locator) |
| flutter_secure_storage | Güvenli local storage (token vs.) |
| dio | HTTP istemcisi (API çağrıları) |
| dartz | Functional programming, Either tipi için |

## 🧠 State Management ve Repository Pattern
Projede BLoC/Cubit pattern kullanılarak state management sağlanmıştır. Repository pattern ile veri katmanı soyutlanmıştır:

- **AuthRepository**: Kimlik doğrulama işlemleri için repository arayüzü
- **AuthApiService**: API çağrıları için servis katmanı
- **UseCase'ler**: Her bir işlem için ayrı use case sınıfları (SignIn, SignUp, ResetPassword, vb.)

Örnek kullanım:

```dart
Future<Either> signIn(SignInRequestParams signInReq) async {
  Either result = await serviceLocator<AuthApiService>().signIn(signInReq);

  return result.fold(
    (error) {
      return Left(error);
    },
    (data) async {
      Response response = data;
      final storage = const FlutterSecureStorage();
      final token = response.data['accessToken'] as String?;

      await storage.write(key: 'access_token', value: token);

      return Right(response);
    },
  );
}
```

## 🔑 Token Yönetimi
Uygulama, kimlik doğrulama token'larını güvenli bir şekilde saklamak için `flutter_secure_storage` kullanır:

- **access_token**: Kullanıcı girişi sonrası alınan token
- **reset_token**: Şifre sıfırlama işlemi için alınan geçici token

## 🧪 Doğrulama Akışı
1. Kullanıcı "Şifremi Unuttum" ekranında email girer
2. Backend'e istek atılır
3. Kullanıcı doğrulama kodunu girer
4. Kod backend'e gönderilir ve doğrulanır
5. Doğrulama başarılıysa "Şifre Sıfırlama" ekranına yönlendirilir
6. Yeni şifre belirlenir ve işlem tamamlanır

## 🚀 Başlatma
```bash
flutter pub get
flutter run
```

## 📂 Backend Entegrasyonu
Bu frontend, ASP.NET Core Web API ile geliştirilmiş şu backend projesiyle entegre çalışır:
https://github.com/ismailVasip/LoginSignUpFullStack/tree/main/login_signup_backend

## 🧑‍💻 Geliştirici
İsmail Vasip

Bu proje ile Flutter'da Clean Architecture, Cubit/BLoC yapısı ve sürdürülebilir frontend geliştirme deneyimi kazandım. Kodun okunabilir, test edilebilir ve genişletilebilir olmasına özen gösterdim. Modern UI/UX prensiplerini uygulayarak kullanıcı deneyimini iyileştirdim.
