import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'help_and_support_event.dart';
import 'help_and_support_state.dart';

class HelpAndSupportBloc extends Bloc<HelpAndSupportEvent, HelpAndSupportState> {

  HelpAndSupportBloc() : super(HelpAndSupportState()) {

    // Handle name changes
    on<NameChanged>((event, emit) {
      emit(state.copyWith(name: event.name));
    });

    // Handle email changes
    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    // Handle query changes
    on<QueryChanged>((event, emit) {
      emit(state.copyWith(query: event.query));
    });

    // Handle form submission with CORS and web fixes
    on<SubmitForm>((event, emit) async {


      // Basic validation
      if (state.name.isEmpty || state.email.isEmpty || state.query.isEmpty) {
        emit(state.copyWith(
          isSubmitting: false,
          isFailure: true,
          isSuccess: false,
          errorMessage: 'Please fill all fields',
        ));
        return;
      }

      // Show loading
      emit(state.copyWith(
        isSubmitting: true,
        isFailure: false,
        isSuccess: false,
        errorMessage: null,
      ));

      try {
        final url = kIsWeb
            ? 'https://send-email-server-m6hp.onrender.com/send-email'
            : 'https://send-email-server-m6hp.onrender.com/send-email';

        // Prepare request body
        final requestBody = {
          'name': state.name.trim(),
          'email': state.email.trim(),
          'query': state.query.trim(),
        };

        // Create HTTP client with proper headers for web
        final client = http.Client();

        try {
          // Make HTTP request with proper headers for CORS
          final response = await client.post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(requestBody),
          ).timeout(
            const Duration(seconds: 45),
          );



          if (response.statusCode == 200 || response.statusCode == 201) {
            emit(state.copyWith(
              isSubmitting: false,
              isSuccess: true,
              isFailure: false,
              name: '',
              email: '',
              query: '',
              errorMessage: null,
            ));
          } else if (response.statusCode == 0) {
            emit(state.copyWith(
              isSubmitting: false,
              isFailure: true,
              isSuccess: false,
              errorMessage: 'Network error: Please check your connection or try again later',
            ));
          } else {
            String errorMsg = 'Server error (${response.statusCode})';

            try {
              final errorData = jsonDecode(response.body);
              if (errorData is Map && errorData.containsKey('message')) {
                errorMsg = errorData['message'];
              } else if (errorData is Map && errorData.containsKey('error')) {
                errorMsg = errorData['error'];
              }
            } catch (e) {
              print('Could not parse error response: $e');
            }

            emit(state.copyWith(
              isSubmitting: false,
              isFailure: true,
              isSuccess: false,
              errorMessage: errorMsg,
            ));
          }
        } finally {
          client.close();
        }

      } on SocketException catch (e) {
        String errorMsg = 'Network error: Check your internet connection';

        if (e.message.contains('timeout')) {
          errorMsg = 'Request timeout: Server may be starting up, please try again';
        }

        emit(state.copyWith(
          isSubmitting: false,
          isFailure: true,
          isSuccess: false,
          errorMessage: errorMsg,
        ));
      } catch (e) {

        String errorMsg = 'Connection failed';

        if (e.toString().contains('Failed to fetch')) {
          errorMsg = 'Network error: Please check your internet connection and try again';
        } else if (e.toString().contains('CORS')) {
          errorMsg = 'Server configuration error: Please contact support';
        } else if (e.toString().contains('ClientException')) {
          errorMsg = 'Connection failed: Please check your network and try again';
        }

        emit(state.copyWith(
          isSubmitting: false,
          isFailure: true,
          isSuccess: false,
          errorMessage: errorMsg,
        ));
      }
    });

    // Handle form reset
    on<ResetForm>((event, emit) {
      emit(HelpAndSupportState());
    });
  }
}


class WebCompatibleHttpClient {
  static Future<http.Response> post({
    required String url,
    required Map<String, String> headers,
    required String body,
    Duration? timeout,
  }) async {
    try {
      final client = http.Client();
      final response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      ).timeout(timeout ?? const Duration(seconds: 30));
      client.close();
      return response;
    } catch (e) {
      // Fallback for web CORS issues - you might need to implement a proxy
      print('Direct request failed, error: $e');
      rethrow;
    }
  }
}