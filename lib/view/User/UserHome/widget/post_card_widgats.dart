// view/User/UserHome/widget/post_card_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nikosafe/View_Model/Controller/user/userHome/feedController.dart';
import 'package:nikosafe/models/userHome/post_model.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class PostCardWidget extends StatelessWidget {
  final Data post;
  final FeedController controller;

  const PostCardWidget({
    Key? key,
    required this.post,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: AppColor.iconColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          _buildPostHeader(context),

          // Post Title
          if (post.title?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                post.title!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          // Post Content/Text
          if (post.text?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                post.text!,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),

          // Post Images (for normal and check-in posts)
          if (post.images.isNotEmpty && post.isPoll != true) _buildPostImages(),

          // Check-in Map Section
          if (post.checkIn != null) _buildCheckInSection(),
          // if(post.postType!.id == 3) _buildCheckInSection(),

          // Poll Section
          if (post.isPoll == true && post.pollOptions.isNotEmpty) _buildPollSection(),

          // if(post.postType!.id == 1)
          //   Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //   child: Text(
          //     post.checkIn!.locationName ??"",
          //     style: TextStyle(color: Colors.white, fontSize: 14),
          //   ),
          // ),

          // Post Actions (Like, Comment, etc.)
          _buildPostActions(),
        ],
      ),
    );
  }

  // Post Header with user info and menu
  Widget _buildPostHeader(BuildContext context) {
    final displayName = '${post.user?.firstName ?? ''} ${post.user?.lastName ?? ''}'.trim();

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(ImageAssets.userHome_userProfile),
        radius: 20,
      ),
      title: Text(
        displayName.isNotEmpty ? displayName : 'Unknown User',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: [
          Text(
            _formatDate(post.createdAt),
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          SizedBox(width: 8),
          Icon(Icons.public, color: Colors.grey, size: 12),
        ],
      ),
      trailing: PopupMenuButton<String>(
        color: AppColor.topLinear,
        onSelected: (value) => _handlePostMenuAction(value, context),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'hide',
            child: Row(
              children: [
                Icon(Icons.visibility_off, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Hide Post', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          if (post.user?.id == 2) // Replace with actual current user check
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red, size: 18),
                  SizedBox(width: 8),
                  Text('Delete Post', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
        ],
        icon: Icon(Icons.more_vert, color: Colors.white),
      ),
    );
  }

  // Helper method to extract image URL
  String _extractImageUrl(dynamic imageData) {
    try {
      if (imageData == null) return '';

      if (imageData is String) {
        // Direct URL string
        return imageData;
      } else if (imageData is Map<String, dynamic>) {
        // Object with image field
        final imageUrl = imageData['image'];
        if (imageUrl is String) {
          return imageUrl;
        }
      }

      // Fallback: try toString()
      final str = imageData.toString();
      if (str.contains('http')) {
        return str;
      }
    } catch (e) {
      print('Error extracting image URL: $e');
    }
    return '';
  }

  // Post Images
  Widget _buildPostImages() {
    if (post.images.isEmpty) return SizedBox.shrink();

    // Single Image
    if (post.images.length == 1) {
      final imageUrl = _extractImageUrl(post.images.first);

      print('Single Image URL extracted: $imageUrl');

      if (imageUrl.isEmpty) {
        return Container(
          height: 200,
          color: Colors.grey[800],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_not_supported, color: Colors.white54),
                SizedBox(height: 8),
                Text('No image URL', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        );
      }

      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        height: 300,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 300,
          color: Colors.grey[800],
          child: Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) {
          print('CachedNetworkImage Error: $error');
          return Container(
            height: 300,
            color: Colors.grey[800],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(height: 8),
                  Text('Failed to load', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          );
        },
      );
    }

    // Multiple Images - Instagram Style
    return _buildMultipleImagesCarousel();
  }

  // Instagram-style Multiple Images Carousel
  Widget _buildMultipleImagesCarousel() {
    return Container(
      height: 350,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: post.images.length,
            onPageChanged: (index) {
              // You can track current page here if needed
            },
            itemBuilder: (context, index) {
              final imageUrl = _extractImageUrl(post.images[index]);

              if (imageUrl.isEmpty) {
                return Container(
                  color: Colors.grey[800],
                  child: Center(
                    child: Icon(Icons.image_not_supported, color: Colors.white54),
                  ),
                );
              }

              return CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[800],
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) {
                  print('Multiple images error at index $index: $error');
                  return Container(
                    color: Colors.grey[800],
                    child: Center(
                      child: Icon(Icons.error, color: Colors.white54),
                    ),
                  );
                },
              );
            },
          ),
          // Image counter indicator (Instagram style)
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '1/${post.images.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // Dots indicator at bottom
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                post.images.length > 5 ? 5 : post.images.length,
                    (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == 0
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Check-in Section with Google Map
  Widget _buildCheckInSection() {
    if (post.checkIn == null) return SizedBox.shrink();

    // Parse latitude and longitude
    final latStr = post.checkIn!.latitude ?? '0';
    final lngStr = post.checkIn!.longitude ?? '0';
    final lat = double.tryParse(latStr) ?? 0.0;
    final lng = double.tryParse(lngStr) ?? 0.0;

    return Container(
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyan.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Google Map Widget
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Container(
              height: 200,
              width: double.infinity,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat, lng),
                  zoom: 15.0,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('checkin_${post.id}'),
                    position: LatLng(lat, lng),
                    infoWindow: InfoWindow(
                      title: post.checkIn!.locationName ?? 'Check-in Location',
                      snippet: post.checkIn!.address ?? '',
                    ),
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
                  ),
                },
                zoomControlsEnabled: false,
                zoomGesturesEnabled: true,
                scrollGesturesEnabled: true,
                rotateGesturesEnabled: false,
                tiltGesturesEnabled: false,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                liteModeEnabled: true, // Better performance for list items
              ),
            ),
          ),

          // Location Details
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.cyan.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.location_on, color: Colors.cyan, size: 20),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.checkIn!.locationName ?? 'Unknown Location',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (post.checkIn!.address?.isNotEmpty == true) ...[
                            SizedBox(height: 4),
                            Text(
                              post.checkIn!.address!,
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Coordinates
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.my_location, color: Colors.cyan, size: 14),
                      SizedBox(width: 6),
                      Text(
                        '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}',
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),

                // View on Maps Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _openGoogleMaps(post.checkIn!),
                    icon: Icon(Icons.map, size: 18),
                    label: Text('View on Google Maps'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Poll Section
  Widget _buildPollSection() {
    if (post.isPoll != true || post.pollOptions.isEmpty) return SizedBox.shrink();

    final hasVoted = post.userPollVote != null;
    final totalVotes = post.totalPollVotes ?? 0;

    // Safely get poll option id from userPollVote (can be int, Map, or null)
    int? userVotedOptionId;
    if (post.userPollVote != null) {
      if (post.userPollVote is Map<String, dynamic>) {
        userVotedOptionId = (post.userPollVote as Map<String, dynamic>)['poll_option_id'] as int?;
      } else if (post.userPollVote is int) {
        userVotedOptionId = post.userPollVote as int;
      }
    }

    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.pollTitle?.isNotEmpty == true)
            Text(
              post.pollTitle!,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          SizedBox(height: 16),
          ...post.pollOptions.map((option) {
            final optionMap = option as Map<String, dynamic>;
            final optionId = optionMap['id'];
            final optionText = optionMap['text'] ?? optionMap['option'] ?? '';
            final votes = optionMap['votes'] ?? optionMap['vote_count'] ?? 0;
            final percentage = totalVotes > 0 ? (votes / totalVotes) * 100 : 0.0;

            final isSelected = hasVoted && userVotedOptionId == optionId;

            return GestureDetector(
              onTap: hasVoted ? null : () => controller.voteOnPoll(post.id, optionId),
              child: Container(
                margin: EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            optionText,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (hasVoted)
                          Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Stack(
                      children: [
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected
                                ? Border.all(color: Colors.cyan, width: 2)
                                : null,
                          ),
                        ),
                        if (hasVoted)
                          FractionallySizedBox(
                            widthFactor: percentage / 100,
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.cyan : Colors.cyan.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        Container(
                          height: 40,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: hasVoted
                              ? Text(
                            '$votes votes',
                            style: TextStyle(color: Colors.white),
                          )
                              : Center(
                            child: Text(
                              'Tap to vote',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          SizedBox(height: 8),
          Text(
            'Total votes: $totalVotes',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Post Actions (Reactions, Comments)
  Widget _buildPostActions() {
    // Safely handle userReaction which can be String, Map, or null
    String? userReactionType;
    if (post.userReaction != null) {
      if (post.userReaction is Map<String, dynamic>) {
        userReactionType = (post.userReaction as Map<String, dynamic>)['type'] as String?;
      } else if (post.userReaction is String) {
        userReactionType = post.userReaction as String;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          // Reaction and Comment counts
          Row(
            children: [
              if ((post.totalReactions ?? 0) > 0) ...[
                _buildReactionIcon(userReactionType ?? 'like'),
                SizedBox(width: 4),
                Text(
                  '${post.totalReactions}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
              Spacer(),
              if ((post.totalComments ?? 0) > 0)
                Text(
                  '${post.totalComments} comments',
                  style: TextStyle(color: Colors.grey),
                ),
            ],
          ),
          Divider(color: Colors.grey[700], height: 16),
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                icon: userReactionType != null
                    ? _getReactionIcon(userReactionType)
                    : Icons.thumb_up_outlined,
                label: userReactionType != null
                    ? _capitalizeFirst(userReactionType)
                    : 'Like',
                color: userReactionType != null ? Colors.cyan : Colors.white,
                onTap: () => _showReactionPicker(),
                onLongPress: () => _showReactionPicker(),
              ),
              _buildActionButton(
                icon: Icons.comment_outlined,
                label: 'Comment',
                color: Colors.white,
                onTap: () => _navigateToComments(),
              ),
              _buildActionButton(
                icon: Icons.share_outlined,
                label: 'Share',
                color: Colors.white,
                onTap: () => _sharePost(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Action Button Widget
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
  }) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(width: 6),
            Text(label, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }

  // Show Reaction Picker
  void _showReactionPicker() {
    final reactionTypes = ['like', 'love', 'laugh', 'angry', 'sad', 'wow'];

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.iconColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'React to this post',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: reactionTypes.map((type) {
                return GestureDetector(
                  onTap: () {
                    controller.toggleReaction(post.id, type);
                    Get.back();
                  },
                  child: Column(
                    children: [
                      Icon(
                        _getReactionIcon(type),
                        size: 32,
                        color: _getReactionColor(type),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _capitalizeFirst(type),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Methods
  void _handlePostMenuAction(String action, BuildContext context) {
    switch (action) {
      case 'hide':
        controller.hidePost(post.id);
        break;
      case 'delete':
        _showDeleteConfirmation(context);
        break;
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColor.iconColor,
        title: Text('Delete Post', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete this post?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deletePost(post.id);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _openGoogleMaps(CheckIn checkIn) async {
    final lat = checkIn.latitude;
    final lng = checkIn.longitude;
    if (lat != null && lng != null) {
      final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    }
  }

  void _navigateToComments() {
    // Navigate to comments screen
    // Get.toNamed(RouteName.postCommentsView, arguments: post.id);
  }

  void _sharePost() {
    // Implement share functionality
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return DateFormat('MMM dd').format(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  IconData _getReactionIcon(String type) {
    switch (type) {
      case 'like':
        return Icons.thumb_up;
      case 'love':
        return Icons.favorite;
      case 'laugh':
        return Icons.sentiment_very_satisfied;
      case 'angry':
        return Icons.sentiment_very_dissatisfied;
      case 'sad':
        return Icons.sentiment_dissatisfied;
      case 'wow':
        return Icons.sentiment_satisfied_alt;
      default:
        return Icons.thumb_up;
    }
  }

  Widget _buildReactionIcon(String type) {
    return Icon(
      _getReactionIcon(type),
      color: _getReactionColor(type),
      size: 18,
    );
  }

  Color _getReactionColor(String type) {
    switch (type) {
      case 'like':
        return Colors.blue;
      case 'love':
        return Colors.red;
      case 'laugh':
        return Colors.yellow;
      case 'angry':
        return Colors.orange;
      case 'sad':
        return Colors.grey;
      case 'wow':
        return Colors.purple;
      default:
        return Colors.cyan;
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}