import 'package:http/http.dart' as http;
import '../../exported_files/exported_file.dart';
import 'response_model.dart';

class NetworkCaller {
  // ==========================================
  // CONFIGURATION & VARIABLES
  // ==========================================
  final String _baseUrl = "https://ijarahub-app-dev.nexill.com/api";

  // API Endpoints
  String get refreshTokenUrl => "$_baseUrl/token/refresh";

  // Refresh Token Control
  bool isRefreshTokenEnabled = true;

  // Logger Colors
  final String reset = "\x1B[0m",
      red = "\x1B[31m",
      green = "\x1B[32m",
      yellow = "\x1B[33m",
      blue = "\x1B[34m",
      cyan = "\x1B[36m",
      magenta = "\x1B[35m";

  final http.Client _client = http.Client();
  final _tokenService = Get.find<STService>();

  // ==========================================
  // TOKEN MANAGEMENT HELPER METHODS
  // ==========================================

  Future<void> _saveRefreshToken(String token) async =>
      await _tokenService.saveData(AuthConstants.refreshTokenKey, token);

  Future<void> _deleteAccessToken() =>
      _tokenService.removeData(AuthConstants.accessTokenKey);
  String? _getAccessToken() =>
      _tokenService.getData(AuthConstants.accessTokenKey);
  String? _getRefreshToken() =>
      _tokenService.getData(AuthConstants.refreshTokenKey);
  Future<void> _saveAccessToken(String token) async =>
      await _tokenService.saveData(AuthConstants.accessTokenKey, token);

  // ==========================================
  // PUBLIC API METHODS
  // ==========================================

  // GET Request
  Future<ResponseModel<T>> getRequest<T>({
    required String url,
    Map<String, String>? queryParams,
    String? actionName,
    bool showLog = false,
    bool showAlert = false,
    RxBool? loader,
  }) async {
    return _baseRequest<T>(
      url: url,
      method: 'GET',
      queryParams: queryParams,
      actionName: actionName,
      showLog: showLog,
      showAlert: showAlert,
      loader: loader,
    );
  }

  // POST Request
  Future<ResponseModel<T>> postRequest<T>({
    required String url,
    Map<String, dynamic>? body,
    String? actionName,
    bool showLog = false,
    bool showAlert = false,
    RxBool? loader,
  }) async {
    return _baseRequest<T>(
      url: url,
      method: 'POST',
      body: body,
      actionName: actionName,
      showLog: showLog,
      showAlert: showAlert,
      loader: loader,
    );
  }

  // PUT Request
  Future<ResponseModel<T>> putRequest<T>({
    required String url,
    Map<String, dynamic>? body,
    String? actionName,
    bool showLog = false,
    bool showAlert = false,
    RxBool? loader,
  }) async {
    return _baseRequest<T>(
      url: url,
      method: 'PUT',
      body: body,
      actionName: actionName,
      showLog: showLog,
      showAlert: showAlert,
      loader: loader,
    );
  }

  // DELETE Request
  Future<ResponseModel<T>> deleteRequest<T>({
    required String url,
    Map<String, dynamic>? body,
    String? actionName,
    bool showLog = false,
    bool showAlert = false,
    RxBool? loader,
  }) async {
    return _baseRequest<T>(
      url: url,
      method: 'DELETE',
      body: body,
      actionName: actionName,
      showLog: showLog,
      showAlert: showAlert,
      loader: loader,
    );
  }

  // MULTIPART Request
  Future<ResponseModel<T>> multipartRequest<T>({
    required String url,
    required String method,
    required Map<String, String> fields,
    List<http.MultipartFile>? files,
    String? actionName,
    bool showLog = false,
    bool showAlert = false,
    RxBool? loader,
  }) async {
    try {
      loader?.value = true;
      final uri = Uri.parse(url);
      final request = http.MultipartRequest(method.toUpperCase(), uri);
      final headers = await _buildHeaders();

      request.headers.addAll(headers);
      request.headers['Content-Type'] = 'multipart/form-data';
      request.fields.addAll(fields);
      if (files != null) request.files.addAll(files);

      if (showLog)
        debugPrint('$cyan🧜‍♂️ [$actionName] MULTIPART $method: $uri$reset');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 401) {
        if (isRefreshTokenEnabled) {
          bool refreshed = await _handleRefreshToken();
          if (!refreshed) sectionExpire();
        } else {
          sectionExpire();
        }
      }

      return _handleResponse<T>(
        response,
        method: method,
        actionName: actionName,
        showLog: showLog,
        showAlert: showAlert,
      );
    } catch (e) {
      return ResponseModel<T>(
        isSuccess: false,
        statusCode: 0,
        message: e.toString(),
      );
    } finally {
      loader?.value = false;
    }
  }

  // ==========================================
  // INTERNAL BASE REQUEST LOGIC
  // ==========================================
  Future<ResponseModel<T>> _baseRequest<T>({
    required String url,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    String? actionName,
    bool showLog = false,
    bool showAlert = false,
    RxBool? loader,
  }) async {
    try {
      loader?.value = true;
      Uri uri = Uri.parse(url);
      if (queryParams != null) uri = uri.replace(queryParameters: queryParams);

      final headers = await _buildHeaders();
      if (showLog) {
        debugPrint('$cyan🧜‍♂️ [$actionName] $method: $uri$reset');
        if (body != null) debugPrint('$magenta➡️ BODY: $body$reset');
      }

      http.Response response = await _sendRequest(method, uri, headers, body);

      // Handle Unauthorized Access
      if (response.statusCode == 401) {
        if (isRefreshTokenEnabled) {
          if (showLog)
            debugPrint('$yellow🔄 Token expired, attempting refresh...$reset');
          bool refreshed = await _handleRefreshToken();
          if (refreshed) {
            final newHeaders = await _buildHeaders();
            response = await _sendRequest(method, uri, newHeaders, body);
          } else {
            sectionExpire();
          }
        } else {
          sectionExpire();
        }
      }

      return _handleResponse<T>(
        response,
        method: method,
        actionName: actionName,
        showLog: showLog,
        showAlert: showAlert,
      );
    } catch (e) {
      return ResponseModel<T>(
        isSuccess: false,
        statusCode: 0,
        message: e.toString(),
      );
    } finally {
      loader?.value = false;
    }
  }

  // ==========================================
  // CORE HTTP HANDLERS
  // ==========================================

  Future<http.Response> _sendRequest(
    String method,
    Uri uri,
    Map<String, String> headers,
    Map<String, dynamic>? body,
  ) async {
    final bodyJson = jsonEncode(body);
    switch (method.toUpperCase()) {
      case 'GET':
        return await _client.get(uri, headers: headers);
      case 'POST':
        return await _client.post(uri, headers: headers, body: bodyJson);
      case 'PUT':
        return await _client.put(uri, headers: headers, body: bodyJson);
      case 'DELETE':
        // Some APIs require body in DELETE, others don't. Handled dynamically here.
        return await _client.delete(uri, headers: headers, body: bodyJson);
      default:
        throw Exception('Unsupported HTTP Method: $method');
    }
  }

  Future<Map<String, String>> _buildHeaders() async {
    final token = _getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // ==========================================
  // CONFIGURATION & VARIABLES (Added missing keys)
  // ==========================================
  Future<bool> _handleRefreshToken() async {
    try {
      // 1. Get the stored refresh token using your helper
      final rToken = _getRefreshToken();
      if (rToken == null || rToken.isEmpty) return false;

      // 2. Make the API call
      // Note: We use the key names expected by your Backend here
      final response = await http.post(
        Uri.parse(refreshTokenUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "refresh_token": rToken, // The key name your API expects
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);

        // 3. Extract tokens from API response
        // Using common defaults 'token' and 'refresh_token' from the JSON
        final String? newToken = decoded['token'];
        final String? newRefreshToken = decoded['refresh_token'];

        if (newToken != null) {
          // 4. Save using your AuthConstants keys via your helper methods
          await _saveAccessToken(newToken);

          if (newRefreshToken != null) {
            await _saveRefreshToken(newRefreshToken);
          }

          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ==========================================
  Future<ResponseModel<T>> _handleResponse<T>(
    http.Response response, {
    required String method,
    String? actionName,
    bool showLog = false,
    bool showAlert = false,
  }) async {
    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      decoded = response.body;
    }

    bool success = response.statusCode >= 200 && response.statusCode < 300;

    if (showLog) {
      String statusColor = success
          ? green
          : (response.statusCode == 401 ? yellow : red);
      debugPrint(
        '$statusColor⬅️ [$actionName] STATUS: ${response.statusCode}$reset',
      );
      debugPrint('$blue⬅️ RESPONSE DATA: $decoded$reset');
    }

    if (showAlert && decoded is Map && decoded['message'] != null) {
      _showAlert(
        title: success ? 'Success' : 'Error',
        message: decoded['message'],
      );
    }

    return ResponseModel<T>(
      isSuccess: success,
      statusCode: response.statusCode,
      message: decoded is Map ? decoded['message'] : null,
      data: decoded,
    );
  }

  // ==========================================
  // UTILITIES
  // ==========================================

  void _showAlert({required String title, required String message}) {
    Get.defaultDialog(
      title: title,
      middleText: message,
      textConfirm: 'OK',
      buttonColor: Get.theme.primaryColor,
      onConfirm: () => Get.back(),
    );
  }

  void sectionExpire() async {
    await _deleteAccessToken();
    // Use Get.offAllNamed(YOUR_LOGIN_ROUTE) here to redirect the user
  }

  void dispose() => _client.close();
}
