
class GeneralConfigurations {
  static final GeneralConfigurations _shared = GeneralConfigurations._private();

  factory GeneralConfigurations() => _shared;

  GeneralConfigurations._private();

  // TODO: CHANGE THIS TO FALSE BEFORE UPLOAD For security purposes no logs or prints
  bool isDebug =true;
  
}
