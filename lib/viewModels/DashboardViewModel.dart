import 'base_view_model.dart';
import '../models/account_model.dart';
import '../models/transaction_model.dart';
import '../networking/http_util.dart';
import '../networking/app_constants.dart';
import '../networking/base_response.dart';

class DashboardViewModel extends BaseViewModel {
  List<AccountModel> _accounts = [];
  List<TransactionModel> _recentTransactions = [];
  Map<String, dynamic>? _dashboardSummary;
  Map<String, dynamic>? _analytics;
  
  List<AccountModel> get accounts => _accounts;
  List<TransactionModel> get recentTransactions => _recentTransactions;
  Map<String, dynamic>? get dashboardSummary => _dashboardSummary;
  Map<String, dynamic>? get analytics => _analytics;
  
  double get totalBalance {
    return _accounts.fold(0.0, (sum, account) => sum + account.availableBalance);
  }
  
  Future<void> loadDashboardData() async {
    await Future.wait([
      fetchAccounts(),
      fetchRecentTransactions(),
      fetchDashboardSummary(),
      fetchAnalytics(),
    ]);
  }
  
  Future<void> fetchAccounts() async {
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
        }
      },
    );
  }
  
  Future<void> fetchRecentTransactions() async {
    await makeApiCall<BaseResponse<List<TransactionModel>>>(
      () async {
        final response = await HttpUtil.get(
          AppConstants.TRANSACTION_LIST,
          queryParameters: {
            'limit': 10,
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
          _recentTransactions = response.data!;
        }
      },
    );
  }
  
  Future<void> fetchDashboardSummary() async {
    await makeApiCall<BaseResponse<Map<String, dynamic>>>(
      () async {
        final response = await HttpUtil.get('/dashboard/summary');
        return BaseResponse.fromJson(
          response.data,
          (json) => json as Map<String, dynamic>,
        );
      },
      onSuccess: (response) {
        if (response.success && response.data != null) {
          _dashboardSummary = response.data;
        }
      },
    );
  }
  
  Future<void> fetchAnalytics() async {
    await makeApiCall<BaseResponse<Map<String, dynamic>>>(
      () async {
        final response = await HttpUtil.get('/dashboard/analytics');
        return BaseResponse.fromJson(
          response.data,
          (json) => json as Map<String, dynamic>,
        );
      },
      onSuccess: (response) {
        if (response.success && response.data != null) {
          _analytics = response.data;
        }
      },
    );
  }
  
  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }
}