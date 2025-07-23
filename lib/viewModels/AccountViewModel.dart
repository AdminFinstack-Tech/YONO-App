import 'base_view_model.dart';
import '../models/account_model.dart';
import '../models/transaction_model.dart';
import '../networking/http_util.dart';
import '../networking/app_constants.dart';
import '../networking/base_response.dart';

class AccountViewModel extends BaseViewModel {
  List<AccountModel> _accounts = [];
  AccountModel? _selectedAccount;
  Map<String, List<TransactionModel>> _accountTransactions = {};
  Map<String, dynamic>? _accountStatement;
  
  List<AccountModel> get accounts => _accounts;
  AccountModel? get selectedAccount => _selectedAccount;
  List<TransactionModel>? get currentAccountTransactions => 
      _selectedAccount != null ? _accountTransactions[_selectedAccount!.accountId] : null;
  
  Future<void> loadAccounts() async {
    await makeApiCall<BaseResponse<List<AccountModel>>>(
      () async {
        final response = await HttpUtil.get(AppConstants.ACCOUNTS_LIST);
        return BaseResponse.fromJson(
          response.data,
          (json) => (json as List)
              .map((item) => AccountModel.fromJson(item))
              .toList(),
        );
      },
      onSuccess: (response) {
        if (response.success && response.data != null) {
          _accounts = response.data!;
          if (_accounts.isNotEmpty && _selectedAccount == null) {
            _selectedAccount = _accounts.firstWhere(
              (account) => account.isPrimary,
              orElse: () => _accounts.first,
            );
          }
        }
      },
    );
  }
  
  void selectAccount(AccountModel account) {
    _selectedAccount = account;
    notifyListeners();
    loadAccountTransactions(account.accountId);
  }
  
  Future<void> loadAccountTransactions(String accountId) async {
    await makeApiCall<BaseResponse<List<TransactionModel>>>(
      () async {
        final response = await HttpUtil.get(
          '${AppConstants.ACCOUNT_TRANSACTIONS}/$accountId',
          queryParameters: {
            'limit': 50,
            'sort': 'date_desc',
          },
        );
        return BaseResponse.fromJson(
          response.data,
          (json) => (json as List)
              .map((item) => TransactionModel.fromJson(item))
              .toList(),
        );
      },
      onSuccess: (response) {
        if (response.success && response.data != null) {
          _accountTransactions[accountId] = response.data!;
        }
      },
    );
  }
  
  Future<Map<String, dynamic>?> getAccountStatement({
    required String accountId,
    required DateTime fromDate,
    required DateTime toDate,
    String format = 'pdf',
  }) async {
    final result = await makeApiCall<BaseResponse<Map<String, dynamic>>>(
      () async {
        final response = await HttpUtil.post(
          AppConstants.ACCOUNT_STATEMENT,
          data: {
            'account_id': accountId,
            'from_date': fromDate.toIso8601String(),
            'to_date': toDate.toIso8601String(),
            'format': format,
          },
        );
        return BaseResponse.fromJson(
          response.data,
          (json) => json as Map<String, dynamic>,
        );
      },
      onSuccess: (response) {
        if (response.success && response.data != null) {
          _accountStatement = response.data;
        }
      },
    );
    
    return result?.data;
  }
  
  Future<AccountModel?> getAccountDetails(String accountId) async {
    final result = await makeApiCall<BaseResponse<AccountModel>>(
      () async {
        final response = await HttpUtil.get('${AppConstants.ACCOUNT_DETAILS}/$accountId');
        return BaseResponse.fromJson(
          response.data,
          (json) => AccountModel.fromJson(json as Map<String, dynamic>),
        );
      },
    );
    
    return result?.data;
  }
  
  Future<Map<String, dynamic>?> getAccountBalance(String accountId) async {
    final result = await makeApiCall<BaseResponse<Map<String, dynamic>>>(
      () async {
        final response = await HttpUtil.get('${AppConstants.ACCOUNT_BALANCE}/$accountId');
        return BaseResponse.fromJson(
          response.data,
          (json) => json as Map<String, dynamic>,
        );
      },
    );
    
    return result?.data;
  }
}