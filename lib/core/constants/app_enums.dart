enum UserRole { driver, rider }

extension UserRoleExtension on UserRole {
  String get name {
    switch (this) {
      case UserRole.driver:
        return 'driver';
      case UserRole.rider:
        return 'rider';
    }
  }
}

extension StringToUserRole on String {
  UserRole get toUserRole {
    switch (this) {
      case 'driver':
        return UserRole.driver;
      case 'rider':
        return UserRole.rider;
      default:
        throw Exception('Unknown userRole detected');
    }
  }
}

//
enum UserPhotoModalSelectedOption {
  camera,
  gallery,
}
