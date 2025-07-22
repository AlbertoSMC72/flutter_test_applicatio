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
            
            if (currentState.showFollowOptions) ...[
              const SizedBox(height: 8),
              _buildFollowOptionsPanel(context),
            ],
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
          context.read<ProfileCubit>().toggleFollowOptions();
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

  Widget _buildFollowOptionsPanel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFollowOption(
            context,
            'Todas',
            Icons.notifications_active,
            'Recibir todas las notificaciones',
          ),
          const Divider(height: 1),
          _buildFollowOption(
            context,
            'Personalizadas',
            Icons.tune,
            'Configurar notificaciones',
          ),
          const Divider(height: 1),
          _buildFollowOption(
            context,
            'Ninguna',
            Icons.notifications_off,
            'Sin notificaciones',
          ),
        ],
      ),
    );
  }

  Widget _buildFollowOption(
    BuildContext context,
    String option,
    IconData icon,
    String description,
  ) {
    return InkWell(
      onTap: () {
        context.read<ProfileCubit>().toggleFollow(option);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
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