import 'package:flutter/material.dart';
import 'package:jooblie_app/viewmodels/jobseeker_profile_viewmodel.dart';
import '../../../../core/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class ProfileAvtarAndNameHeader extends StatelessWidget {
  const ProfileAvtarAndNameHeader({
    super.key,
    required this.viewModel,
    required this.theme,
  });

  final JobseekerProfileViewModel viewModel;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: (viewModel.pickedImage == null &&
                          viewModel.profile.avatarUrl == null)
                      ? AppColors.gradientPrimary
                      : null,
                  border: Border.all(
                    color: AppColors.lightPrimary.withValues(alpha: 0.2),
                    width: 4,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: _buildAvatarImage(),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => viewModel.pickImage(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.lightPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (viewModel.pickedImage != null ||
              (viewModel.profile.avatarUrl != null && !viewModel.isImageRemoved))
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextButton.icon(
                onPressed: () => viewModel.removeImage(),
                icon: Icon(Icons.delete_outline, size: 16, color: theme.colorScheme.error),
                label: Text(
                  'Remove Photo',
                  style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            viewModel.profile.fullName,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Job Seeker',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarImage() {
    if (viewModel.pickedImage != null) {
      return Image.file(
        viewModel.pickedImage!,
        fit: BoxFit.cover,
      );
    }

    if (viewModel.profile.avatarUrl != null && !viewModel.isImageRemoved) {
      return CachedNetworkImage(
        imageUrl: viewModel.profile.avatarUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            color: Colors.white,
          ),
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.person_outline,
          color: Colors.white,
          size: 50,
        ),
      );
    }

    return const Icon(
      Icons.person_outline,
      color: Colors.white,
      size: 50,
    );
  }
}
