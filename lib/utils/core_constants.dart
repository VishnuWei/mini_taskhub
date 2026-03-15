class CommonStatus<T> {
  final ScreenStateEnum screenState;
  final String? errorText;
  final T? successData;

  CommonStatus.initial()
      : screenState = ScreenStateEnum.initial,
        errorText = null,
        successData = null;

  CommonStatus.loading()
      : screenState = ScreenStateEnum.loading,
        errorText = null,
        successData = null;

  CommonStatus.error(this.errorText)
      : screenState = ScreenStateEnum.error,
        successData = null;

  CommonStatus.success(this.successData)
      : screenState = ScreenStateEnum.success,
        errorText = null;
}

enum ScreenStateEnum {
  initial,
  loading,
  success,
  error,
}