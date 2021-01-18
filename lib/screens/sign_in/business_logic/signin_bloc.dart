import 'dart:async';

class SignInBloc {
  final StreamController<bool> _isLoadingController = StreamController<bool>();

  ///get loading state stream
  Stream<bool> get getLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  ///Set a loading state
  void setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);
}
