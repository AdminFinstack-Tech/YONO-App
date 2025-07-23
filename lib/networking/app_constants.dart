class AppConstants {
  // API Base URLs
  static const String BASE_URL = "https://api.yonobusiness.sbi/v1/";
  static const String BASE_URL_UAT = "https://uat-api.yonobusiness.sbi/v1/";
  static const String BASE_URL_DEV = "https://dev-api.yonobusiness.sbi/v1/";
  
  // API Endpoints
  static const String LOGIN = "auth/login";
  static const String LOGOUT = "auth/logout";
  static const String REFRESH_TOKEN = "auth/refresh";
  static const String VERIFY_OTP = "auth/verify-otp";
  static const String RESEND_OTP = "auth/resend-otp";
  static const String FORGOT_PASSWORD = "auth/forgot-password";
  static const String RESET_PASSWORD = "auth/reset-password";
  static const String CHANGE_PIN = "auth/change-pin";
  
  // User Endpoints
  static const String USER_PROFILE = "user/profile";
  static const String UPDATE_PROFILE = "user/update-profile";
  static const String BUSINESS_PROFILE = "business/profile";
  static const String UPDATE_BUSINESS = "business/update";
  
  // Account Endpoints
  static const String ACCOUNTS_LIST = "accounts/list";
  static const String ACCOUNT_DETAILS = "accounts/details";
  static const String ACCOUNT_BALANCE = "accounts/balance";
  static const String ACCOUNT_STATEMENT = "accounts/statement";
  static const String ACCOUNT_TRANSACTIONS = "accounts/transactions";
  
  // Payment Endpoints
  static const String INITIATE_PAYMENT = "payments/initiate";
  static const String CONFIRM_PAYMENT = "payments/confirm";
  static const String PAYMENT_STATUS = "payments/status";
  static const String PAYMENT_HISTORY = "payments/history";
  static const String BULK_PAYMENT_UPLOAD = "payments/bulk/upload";
  static const String BULK_PAYMENT_STATUS = "payments/bulk/status";
  
  // Beneficiary Endpoints
  static const String BENEFICIARY_LIST = "beneficiary/list";
  static const String ADD_BENEFICIARY = "beneficiary/add";
  static const String UPDATE_BENEFICIARY = "beneficiary/update";
  static const String DELETE_BENEFICIARY = "beneficiary/delete";
  static const String VERIFY_BENEFICIARY = "beneficiary/verify";
  
  // Transaction Endpoints
  static const String TRANSACTION_LIST = "transactions/list";
  static const String TRANSACTION_DETAILS = "transactions/details";
  static const String TRANSACTION_RECEIPT = "transactions/receipt";
  
  // Approval Endpoints
  static const String PENDING_APPROVALS = "approvals/pending";
  static const String APPROVE_TRANSACTION = "approvals/approve";
  static const String REJECT_TRANSACTION = "approvals/reject";
  static const String APPROVAL_HISTORY = "approvals/history";
  
  // Settings Endpoints
  static const String TRANSACTION_LIMITS = "settings/limits";
  static const String UPDATE_LIMITS = "settings/limits/update";
  static const String NOTIFICATION_SETTINGS = "settings/notifications";
  static const String SECURITY_SETTINGS = "settings/security";
  
  // Shared Preferences Keys
  static const String ACCESS_TOKEN = "access_token";
  static const String REFRESH_TOKEN_KEY = "refresh_token";
  static const String USER_ID = "user_id";
  static const String USER_NAME = "user_name";
  static const String BUSINESS_ID = "business_id";
  static const String BUSINESS_NAME = "business_name";
  static const String LANGUAGE_CODE = "language_code";
  static const String THEME_MODE = "theme_mode";
  static const String BIOMETRIC_ENABLED = "biometric_enabled";
  static const String REMEMBER_ME = "remember_me";
  static const String FIREBASE_TOKEN = "firebase_token";
  static const String DEVICE_ID = "device_id";
  static const String IS_FIRST_TIME = "is_first_time";
  static const String LAST_LOGIN = "last_login";
  
  // Request Headers
  static const String HEADER_AUTH = "Authorization";
  static const String HEADER_CONTENT_TYPE = "Content-Type";
  static const String HEADER_ACCEPT = "Accept";
  static const String HEADER_DEVICE_ID = "X-Device-Id";
  static const String HEADER_APP_VERSION = "X-App-Version";
  static const String HEADER_PLATFORM = "X-Platform";
  
  // Response Codes
  static const int SUCCESS = 200;
  static const int CREATED = 201;
  static const int NO_CONTENT = 204;
  static const int BAD_REQUEST = 400;
  static const int UNAUTHORIZED = 401;
  static const int FORBIDDEN = 403;
  static const int NOT_FOUND = 404;
  static const int CONFLICT = 409;
  static const int SERVER_ERROR = 500;
  static const int SERVICE_UNAVAILABLE = 503;
  
  // Validation Rules
  static const int MIN_PASSWORD_LENGTH = 8;
  static const int MAX_PASSWORD_LENGTH = 20;
  static const int PIN_LENGTH = 6;
  static const int OTP_LENGTH = 6;
  static const int MOBILE_LENGTH = 10;
  static const int ACCOUNT_NUMBER_LENGTH = 16;
  static const int IFSC_LENGTH = 11;
  
  // Time Constants
  static const int CONNECTION_TIMEOUT = 30000; // 30 seconds
  static const int RECEIVE_TIMEOUT = 30000; // 30 seconds
  static const int OTP_RESEND_TIME = 30; // 30 seconds
  static const int SESSION_TIMEOUT = 300; // 5 minutes
  static const int CACHE_VALIDITY = 300; // 5 minutes
  
  // Pagination
  static const int PAGE_SIZE = 20;
  static const int INITIAL_PAGE = 1;
  
  // File Upload
  static const int MAX_FILE_SIZE = 5 * 1024 * 1024; // 5 MB
  static const List<String> ALLOWED_FILE_TYPES = ['pdf', 'jpg', 'jpeg', 'png', 'csv', 'xls', 'xlsx'];
  
  // Transaction Types
  static const String TXN_TYPE_CREDIT = "CREDIT";
  static const String TXN_TYPE_DEBIT = "DEBIT";
  static const String TXN_TYPE_TRANSFER = "TRANSFER";
  static const String TXN_TYPE_PAYMENT = "PAYMENT";
  
  // Payment Modes
  static const String PAYMENT_MODE_IMPS = "IMPS";
  static const String PAYMENT_MODE_NEFT = "NEFT";
  static const String PAYMENT_MODE_RTGS = "RTGS";
  static const String PAYMENT_MODE_UPI = "UPI";
  
  // Account Types
  static const String ACCOUNT_TYPE_CURRENT = "CURRENT";
  static const String ACCOUNT_TYPE_OVERDRAFT = "OVERDRAFT";
  static const String ACCOUNT_TYPE_CASH_CREDIT = "CASH_CREDIT";
  static const String ACCOUNT_TYPE_LOAN = "LOAN";
  static const String ACCOUNT_TYPE_DEPOSIT = "DEPOSIT";
  
  // Status Types
  static const String STATUS_ACTIVE = "ACTIVE";
  static const String STATUS_INACTIVE = "INACTIVE";
  static const String STATUS_PENDING = "PENDING";
  static const String STATUS_APPROVED = "APPROVED";
  static const String STATUS_REJECTED = "REJECTED";
  static const String STATUS_SUCCESS = "SUCCESS";
  static const String STATUS_FAILED = "FAILED";
  
  // Error Messages
  static const String ERROR_NETWORK = "Network connection error. Please check your internet connection.";
  static const String ERROR_TIMEOUT = "Request timeout. Please try again.";
  static const String ERROR_SERVER = "Server error. Please try again later.";
  static const String ERROR_UNAUTHORIZED = "Session expired. Please login again.";
  static const String ERROR_GENERIC = "Something went wrong. Please try again.";
}