import 'base_view_model.dart';
import '../models/transaction_model.dart';
import '../networking/http_util.dart';
import '../networking/app_constants.dart';
import '../networking/base_response.dart';

class TransactionViewModel extends BaseViewModel {
  List<TransactionModel> _transactions = [];
  Map<String, dynamic>? _transactionFilters;
  TransactionModel? _selectedTransaction;
  Map<String, dynamic>? _transactionSummary;
  
  List<TransactionModel> get transactions => _transactions;
  TransactionModel? get selectedTransaction => _selectedTransaction;
  Map<String, dynamic>? get transactionSummary => _transactionSummary;
  Map<String, dynamic>? get transactionFilters => _transactionFilters;
  
  Future<void> loadTransactions({
    String? accountId,
    DateTime? fromDate,
    DateTime? toDate,
    String? transactionType,
    String? status,
    double? minAmount,
    double? maxAmount,
    int page = 1,
    int limit = 20,
  }) async {
    await makeApiCall<BaseResponse<PaginatedResponse<TransactionModel>>>(
      () async {
        final response = await HttpUtil.get(
          AppConstants.TRANSACTION_LIST,
          queryParameters: {
            if (accountId != null) 'account_id': accountId,
            if (fromDate != null) 'from_date': fromDate.toIso8601String(),
            if (toDate != null) 'to_date': toDate.toIso8601String(),
            if (transactionType != null) 'transaction_type': transactionType,
            if (status != null) 'status': status,
            if (minAmount != null) 'min_amount': minAmount,
            if (maxAmount != null) 'max_amount': maxAmount,
            'page': page,
            'limit': limit,
            'sort': 'date_desc',
          },
        );
        return BaseResponse.fromJson(
          response.data,
          (json) => PaginatedResponse.fromJson(
            json as Map<String, dynamic>,
            (item) => TransactionModel.fromJson(item as Map<String, dynamic>),
          ),
        );
      },
      onSuccess: (response) {
        if (response.success && response.data != null) {
          if (page == 1) {
            _transactions = response.data!.items;
          } else {
            _transactions.addAll(response.data!.items);
          }
        }
      },
    );
  }
  
  Future<TransactionModel?> getTransactionDetails(String transactionId) async {
    final result = await makeApiCall<BaseResponse<TransactionModel>>(
      () async {
        final response = await HttpUtil.get(
          '${AppConstants.TRANSACTION_DETAILS}/$transactionId',
        );
        return BaseResponse.fromJson(
          response.data,
          (json) => TransactionModel.fromJson(json as Map<String, dynamic>),
        );
      },
      onSuccess: (response) {
        if (response.success && response.data != null) {
          _selectedTransaction = response.data;
        }
      },
    );
    
    return result?.data;
  }
  
  Future<String?> getTransactionReceipt(String transactionId) async {
    final result = await makeApiCall<BaseResponse<Map<String, dynamic>>>(
      () async {
        final response = await HttpUtil.get(
          '${AppConstants.TRANSACTION_RECEIPT}/$transactionId',
        );
        return BaseResponse.fromJson(
          response.data,
          (json) => json as Map<String, dynamic>,
        );
      },
    );
    
    return result?.data?['receipt_url'];
  }
  
  Future<void> loadTransactionSummary({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    await makeApiCall<BaseResponse<Map<String, dynamic>>>(
      () async {
        final response = await HttpUtil.get(
          '/transactions/summary',
          queryParameters: {
            if (fromDate != null) 'from_date': fromDate.toIso8601String(),
            if (toDate != null) 'to_date': toDate.toIso8601String(),
          },
        );
        return BaseResponse.fromJson(
          response.data,
          (json) => json as Map<String, dynamic>,
        );
      },
      onSuccess: (response) {
        if (response.success && response.data != null) {
          _transactionSummary = response.data;
        }
      },
    );
  }
  
  void setTransactionFilters(Map<String, dynamic> filters) {
    _transactionFilters = filters;
    notifyListeners();
  }
  
  void clearFilters() {
    _transactionFilters = null;
    notifyListeners();
  }
  
  void selectTransaction(TransactionModel transaction) {
    _selectedTransaction = transaction;
    notifyListeners();
  }
  
  Future<void> refreshTransactions() async {
    await loadTransactions();
  }
}