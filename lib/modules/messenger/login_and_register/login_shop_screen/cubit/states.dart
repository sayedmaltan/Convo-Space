abstract class LoginStates{}

class InitialState extends LoginStates{}

class ChangeColorOfEmailLabel extends LoginStates{}

class ChangeColorOfPassLabel extends LoginStates{}

class ChangeHiddenOfSuffix extends LoginStates{}

class IsPassShown extends LoginStates{}

class ChangeSuffixIcon extends LoginStates{}

class ChangeFromEmail extends LoginStates{}

class ChangeFromPass extends LoginStates{}

class LoadingLoginScreen extends LoginStates{}

class SuccessLoginScreen extends LoginStates{}

class ErrorLoginScreen extends LoginStates{
  ErrorLoginScreen(error);
}

