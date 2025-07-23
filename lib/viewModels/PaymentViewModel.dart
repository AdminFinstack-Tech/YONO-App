import 'dart:io';
import 'base_view_model.dart';
import '../models/payment_model.dart';
import '../models/beneficiary_model.dart';
import '../networking/http_util.dart';
import '../networking/app_constants.dart';
import '../networking/base_response.dart';

class PaymentViewModel extends BaseViewModel {
  List<BeneficiaryModel> _beneficiaries = [];
  PaymentModel? _currentPayment;
  List<PaymentModel> _paymentHistory = [];
  Map<String, dynamic>? _paymentLimits;
  
  List<BeneficiaryModel> get beneficiaries => _beneficiaries;
  PaymentModel? get currentPayment => _currentPayment;
  List<PaymentModel> get paymentHistory => _paymentHistory;
  Map<String, dynamic>? get paymentLimits => _paymentLimits;
  
  Future<void> loadBeneficiaries() async {
    await makeApiCall<BaseResponse<List<BeneficiaryModel>>>(
      () async {
        final response = await HttpUtil.get(AppConstants.BENEFICIARY_LIST);
        return BaseResponse.fromJson(
          response.data,
          (json) => (json as List)
              .map((item) => BeneficiaryModel.fromJson(item))
              .toList(),
        );
      },
      onSuccess: (response) {
        if (response.success && response.data != null) {
          _beneficiaries = response.data!;
        }
      },
    );
  }
  
  Future<String?> initiatePayment({
    required String fromAccountId,
    required String toAccount,
    required double amount,
    required String paymentMode,
    String? remarks,
    String? beneficiaryId,
  }) async {
    final result = await makeApiCall<BaseResponse<PaymentInitiationResponse>>(
      () async {
        final response = await HttpUtil.post(
          AppConstants.INITIATE_PAYMENT,
          data: {
            'from_account_id': fromAccountId,
            'to_account': toAccount,
            'amount': amount,
            'payment_mode': paymentMode,
            'remarks': remarks,
            'beneficiary_id': beneficiaryId,
          },
        );
        return BaseResponse.fromJson(
          response.data,
          (json) => PaymentInitiationResponse.fromJson(json as Map<String, dynamic>),
        );
      },
      onSuccess: (response) {
        if (response.success && response.data != null) {
          _currentPayment = response.data!.payment;
        }
      },
    );
    
    return result?.data?.transactionId;
  }
  
  Future<bool> confirmPayment({
    required String transactionId,
    required String otp,
  }) async {
    final result = await makeApiCall<BaseResponse<PaymentConfirmationResponse>>(
      () async {
        final response = await HttpUtil.post(
          AppConstants.CONFIRM_PAYMENT,
          data: {
            'transaction_id': transactionId,
            'otp': otp,
          },
        );
        return BaseResponse.fromJson(
          response.data,
          (json) => PaymentConfirmationResponse.fromJson(json as Map<String, dynamic>),
        );
      },
    );
    
    return result?.success ?? false;
  }
  
  Future<bool> addBeneficiary({
    required String name,
    required String accountNumber,
    required String ifscCode,
    String? bankName,
    String? email,
    String? mobile,
  }) async {
    final result = await makeApiCall<BaseResponse<BeneficiaryModel>>(
      () async {
        final response = await HttpUtil.post(
          AppConstants.ADD_BENEFICIARY,
          data: {
            'name': name,
            'account_number': accountNumber,
            'ifsc_code': ifscCode,
            'bank_name': bankName,
            'email': email,
            'mobile': mobile,
          },
        );
        return BaseResponse.fromJson(
          response.data,
          (json) => BeneficiaryModel.fromJson(json as Map<String, dynamic>),
        );
      },
      onSuccess: (response) {
        if (response.success && response.data != null) {
          _beneficiaries.add(response.data!);
        }
      },
    );
    
    return result?.success ?? false;
  }
  
  Future<bool> verifyBeneficiary({
    required String beneficiaryId,
    required String otp,
  }) async {
    final result = await makeApiCall<BaseResponse<dynamic>>(
      () async {
        final response = await HttpUtil.post(
          '${AppConstants.VERIFY_BENEFICIARY}/$beneficiaryId',
          data: {'otp': otp},
        );
        return BaseResponse.fromJson(
          response.data,
          (json) => json,
        );
      },
    );
    
    return result?.success ?? false;
  }
  
  Future<bool> deleteBeneficiary(String beneficiaryId) async {
    final result = await makeApiCall<BaseResponse<dynamic>>(
      () async {
        final response = await HttpUtil.delete(
          '${AppConstants.DELETE_BENEFICIARY}/$beneficiaryId',
        );
        return BaseResponse.fromJson(
          response.data,
          (json) => json,
        );
      },
      onSuccess: (response) {
        if (response.success) {
          _beneficiaries.removeWhere((b) => b.beneficiaryId == beneficiaryId);
        }
      },
    );
    
    return result?.success ?? false;
  }
  
  Future<void> loadPaymentHistory({
    DateTime? fromDate,
    DateTime? toDate,
    String? status,
  }) async {
    await makeApiCall<BaseResponse<List<PaymentModel>>>(
      () async {
        final response = await HttpUtil.get(
          AppConstants.PAYMENT_HISTORY,
          queryParameters: {
            if (fromDate != null) 'from_date': fromDate.toIso8601String(),
            if (toDate != null) 'to_date': toDate.toIso8601String(),
            if (status != null) 'status': status,
          },
        );
        return BaseResponse.fromJson(
          response.data,
          (json) => (json as List)
              .map((item) => PaymentModel.fromJson(item))
              .toList(),
        );
      },
      onSuccess: (response) {
        if (response.success && response.data != null) {
          _paymentHistory = response.data!;
        }
      },
    );
  }
  
  Future<Map<String, dynamic>?> processBulkPayment(File file) async {
    final result = await makeApiCall<BaseResponse<Map<String, dynamic>>>(
      () async {
        final response = await HttpUtil.uploadFile(
          AppConstants.BULK_PAYMENT_UPLOAD,
          file,
          fileKey: 'payment_file',
        );
        return BaseResponse.fromJson(
          response.data,
          (json) => json as Map<String, dynamic>,
        );
      },
    );
    
    return result?.data;
  }
  
  Future<void> loadPaymentLimits() async {
    await makeApiCall<BaseResponse<Map<String, dynamic>>>(
      () async {
        final response = await HttpUtil.get(AppConstants.TRANSACTION_LIMITS);
        return BaseResponse.fromJson(
          response.data,
          (json) => json as Map<String, dynamic>,
        );
      },
      onSuccess: (response) {
        if (response.success && response.data != null) {
          _paymentLimits = response.data;
        }
      },
    );
  }
}

// Response Models
class PaymentInitiationResponse {
  final String transactionId;
  final PaymentModel payment;
  
  PaymentInitiationResponse({
    required this.transactionId,
    required this.payment,
  });
  
  factory PaymentInitiationResponse.fromJson(Map<String, dynamic> json) {
    return PaymentInitiationResponse(
      transactionId: json['transaction_id'],
      payment: PaymentModel.fromJson(json['payment']),
    );
  }
}

class PaymentConfirmationResponse {
  final bool success;
  final String? referenceNumber;
  final String? message;
  
  PaymentConfirmationResponse({
    required this.success,
    this.referenceNumber,
    this.message,
  });
  
  factory PaymentConfirmationResponse.fromJson(Map<String, dynamic> json) {
    return PaymentConfirmationResponse(
      success: json['success'] ?? false,
      referenceNumber: json['reference_number'],
      message: json['message'],
    );
  }
}