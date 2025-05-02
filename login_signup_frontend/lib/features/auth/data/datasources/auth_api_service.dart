import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:login_signup_frontend/core/constants/api_urls.dart';
import 'package:login_signup_frontend/core/network/dio_client.dart';
import 'package:login_signup_frontend/features/auth/data/models/signup_request_params.dart';
import 'package:login_signup_frontend/service_locator.dart';

abstract class AuthApiService {
  Future<Either> signUp(SignUpRequestParams signUpReq);
}

class AuthApiServiceImpl implements AuthApiService {
  @override
  Future<Either> signUp(SignUpRequestParams signUpReq) async {
    try {
      final response = await serviceLocator<DioClient>().post(
        ApiUrls.register,
        data: signUpReq.toMap(),
      );

      if (response.statusCode == 201) {
        return Right(response);
      } else {
        String errorMessage =
            "An unexpected server solution was provided (Code: ${response.statusCode}).";
        if (response.data != null &&
            response.data is Map &&
            response.data.containsKey('message')) {
          errorMessage = response.data['message'].toString();
        }
        return Left(errorMessage);
      }
    } on DioException catch (e) {
      String errorMessage = "An unknown server error occurred.";

      if (e.response?.data != null) {
        final responseData = e.response!.data;

        if (responseData is Map<String, dynamic>) {
          errorMessage = _parseErrorResponse(responseData);
        } else {
          errorMessage = responseData.join('\n').toString();
        }
      }
      // Timeout errors
      else if ([
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ].contains(e.type)) {
        errorMessage =
            "Connection timeout. Please check your internet connection.";
      }
      // Connection errors
      else if ([
        DioExceptionType.unknown,
        DioExceptionType.connectionError,
      ].contains(e.type)) {
        errorMessage = "Network error. Could not connect to the server.";
      }
      // Other errors
      else {
        errorMessage =
            e.message ??
            "An unexpected error occurred. Please try again later.";
      }

      return Left(errorMessage);
    } catch (e) {
      return Left("An unexpected error occurred: ${e.toString()}");
    }
  }

  String _parseErrorResponse(Map<String, dynamic> responseData) {
    if (responseData.containsKey('errors')) {
      final errorValue = responseData['errors'];

      if (errorValue is Map) {
        final messages =
            errorValue.entries.expand((entry) {
              if (entry.value is List) {
                return (entry.value as List).map((e) => e.toString());
              }
              return [entry.value.toString()];
            }).toList();

        return messages.join('\n');
      } else if (errorValue is List) {
        return errorValue.isNotEmpty
            ? errorValue.map((item) => item.toString()).join('\n')
            : "An unexpected error occurred. Please try again later.";
      } else if (errorValue != null) {
        return errorValue.toString();
      }
    }
    // Single message responses
    else if (responseData.containsKey('message')) {
      return responseData['message']?.toString() ??
          "An unexpected error occurred.";
    }

    // Fallback
    return responseData.toString();
  }
}
