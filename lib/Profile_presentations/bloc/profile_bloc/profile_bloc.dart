import 'package:campusbuzz/Profile_presentations/bloc/profile_bloc/profile_event.dart';
import 'package:campusbuzz/Profile_presentations/bloc/profile_bloc/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../profile_firebase_service/profile_firebase_service.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;


  ProfileBloc(this._userRepository) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {

      final user = await _userRepository.getUser(event.userId, event.userRole);

      if (user != null) {
        emit(ProfileLoaded(user));

      } else {
        emit(ProfileError('User not found'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileUpdating());
    try {
      await _userRepository.updateUser(event.user);
      emit(ProfileUpdated(event.user));
      emit(ProfileLoaded(event.user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}