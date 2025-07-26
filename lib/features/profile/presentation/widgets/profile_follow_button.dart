import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/edit_profile_modal.dart';

class ProfileFollowButtonWidget extends StatelessWidget {
  final ProfileLoaded profileState;

  const ProfileFollowButtonWidget({
    super.key,
    required this.profileState,
  });

  @override
  Widget build(BuildContext context) {
    if (profileState.isOwnProfile) {
      return IconButton(
        onPressed: () {
          _navigateToEditProfile(context);
        },
        icon: const Icon(Icons.edit),
        tooltip: 'Editar perfil',
      );
    }

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {

        final currentState = state is ProfileLoaded ? state : profileState;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMainFollowButton(context, currentState),
          ],
        );
      },
    );
  }

  Widget _buildMainFollowButton(BuildContext context, ProfileLoaded state) {
    return ElevatedButton.icon(
      onPressed: () {
        if (state.isFollowed) {
          context.read<ProfileCubit>().toggleFollow('unfollow');
        } else {
          context.read<ProfileCubit>().toggleFollowOptions('follow');
        }
      },
      icon: Icon(
        state.isFollowed ? Icons.person_remove : Icons.person_add,
        size: 18,
      ),
      label: Text(
        state.isFollowed ? 'Siguiendo' : 'Seguir',
        style: const TextStyle(fontSize: 14),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: state.isFollowed 
            ? Colors.grey.shade200 
            : Theme.of(context).primaryColor,
        foregroundColor: state.isFollowed 
            ? Colors.grey.shade700 
            : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditProfileModal(
        profileState: profileState,
      ),
    );
  }
}