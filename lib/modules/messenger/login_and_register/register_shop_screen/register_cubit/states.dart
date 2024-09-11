abstract class ShopRegisterStates{}

class RegisterInitialState extends ShopRegisterStates{}

class LoadingRegisterScreen extends ShopRegisterStates{}

class SuccessRegisterScreen extends ShopRegisterStates{}

class ErrorRegisterScreen extends ShopRegisterStates{
  ErrorRegisterScreen(error);
}

class IsPassShownRegister extends ShopRegisterStates{}






