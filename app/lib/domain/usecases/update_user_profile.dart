import '../entities/user.dart';
import '../entities/user_profile.dart'; // Added import for UserProfile
import '../repositories/user_repository.dart';

class UpdateUserProfile {
  final UserRepository repository;

  UpdateUserProfile(this.repository);

  // Option 1: Convert User to UserProfile before passing to repository
  Future<void> call(User user) {
    // Convert User to UserProfile or extract the profile data
    final userProfile = UserProfile.fromUser(
      user,
    ); // Assuming this constructor exists
    return repository.updateUserProfile(userProfile);
  }

  // Option 2: Alternative implementation if UserProfile is the correct parameter type
  // Future<void> call(UserProfile userProfile) {
  //   return repository.updateUserProfile(userProfile);
  // }
}
