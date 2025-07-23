import 'base_view_model.dart';

class OnboardingViewModel extends BaseViewModel {
  int _currentPage = 0;
  
  int get currentPage => _currentPage;
  
  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }
  
  void nextPage() {
    _currentPage++;
    notifyListeners();
  }
  
  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      notifyListeners();
    }
  }
  
  void reset() {
    _currentPage = 0;
    notifyListeners();
  }
  
  Future<void> completeOnboarding() async {
    // Save onboarding completion status to SharedPreferences
    // This can be implemented based on your app's requirements
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate async operation
  }
}