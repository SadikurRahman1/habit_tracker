class ResponseModel<T> {
  final bool isSuccess;
  final int statusCode;
  final T? data;
  final String? message;

  ResponseModel({
    required this.isSuccess,
    required this.statusCode,
    this.data,
    this.message,
  });
}
