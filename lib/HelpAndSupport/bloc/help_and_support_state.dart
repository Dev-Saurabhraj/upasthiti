class HelpAndSupportState {
  final String name;
  final String email;
  final String query;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String? errorMessage;

  HelpAndSupportState({
    this.name = '',
    this.email = '',
    this.query = '',
    this.isSubmitting = false,
    this.isSuccess = false,
    this.isFailure = false,
    this.errorMessage,
  });

  HelpAndSupportState copyWith({
    String? name,
    String? email,
    String? query,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? errorMessage,
  }) {
    return HelpAndSupportState(
      name: name ?? this.name,
      email: email ?? this.email,
      query: query ?? this.query,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}