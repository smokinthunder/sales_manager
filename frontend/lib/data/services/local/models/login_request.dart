class LoginRequest {
  final String phoneNumber;
  final String otp;

  const LoginRequest({required this.phoneNumber, required this.otp});
@override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginRequest &&
          runtimeType == other.runtimeType &&
          phoneNumber == other.phoneNumber &&
          otp == other.otp;

  @override
  int get hashCode => phoneNumber.hashCode ^ otp.hashCode;
  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      phoneNumber: json['phone_number'] as String,
      otp: json['otp'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'phone_number': phoneNumber, 'otp': otp};
  }
}
