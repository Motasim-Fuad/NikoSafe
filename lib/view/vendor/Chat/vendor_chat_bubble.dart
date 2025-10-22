// Path: View/user/chat/widgets/chat_bubble.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nikosafe/models/vendor/chat/vendor_message_model.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorChatBubble extends StatelessWidget {
  final VendorChatMessage message;
  final VoidCallback? onRetry;

  const VendorChatBubble({
    required this.message,
    this.onRetry,
    super.key,
  });

  void _copyText(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Copied to clipboard'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.text != null && message.text!.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.copy, color: Colors.white),
                title: const Text('Copy Text', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _copyText(context, message.text!);
                  Navigator.pop(context);
                },
              ),
            if (message.messageType == VendorMessageType.location)
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.white),
                title: const Text('Copy Location', style: TextStyle(color: Colors.white)),
                onTap: () {
                  if (message.text != null) {
                    _copyText(context, message.text!);
                    Navigator.pop(context);
                  }
                },
              ),
            if (message.status == VendorMessageStatus.failed)
              ListTile(
                leading: const Icon(Icons.refresh, color: Colors.white),
                title: const Text('Retry', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  onRetry?.call();
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMe = message.isSentByMe;

    return GestureDetector(
      onLongPress: () => _showOptions(context),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          constraints: const BoxConstraints(maxWidth: 300),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isMe ? Colors.teal : Colors.grey[700],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
                    bottomRight: isMe ? Radius.zero : const Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    _buildMessageContent(),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message.formattedTime,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                        if (isMe) ...[
                          const SizedBox(width: 4),
                          _buildStatusIcon(),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              if (message.status == VendorMessageStatus.failed) ...[
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onRetry,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.error_outline, color: Colors.red, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Failed to send. Tap to retry',
                          style: TextStyle(color: Colors.red, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent() {
    switch (message.messageType) {
      case VendorMessageType.text:
        return SelectableText(
          message.text ?? '',
          style: const TextStyle(color: Colors.white, fontSize: 15),
        );

      case VendorMessageType.image:
        return _buildImageMessage();

      case VendorMessageType.video:
        return _buildVideoMessage();

      case VendorMessageType.location:
        return _buildLocationMessage();

      case VendorMessageType.file:
        return _buildFileMessage();
    }
  }

  Widget _buildImageMessage() {
    return Column(
      crossAxisAlignment:
      message.isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (message.localFile != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              message.localFile!,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
          )
        else if (message.fileUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              message.fileUrl!,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 200,
                  width: 200,
                  color: Colors.grey[800],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                      color: Colors.white,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: 200,
                  color: Colors.grey[800],
                  child: const Center(
                    child: Icon(Icons.error, color: Colors.white),
                  ),
                );
              },
            ),
          ),
        if (message.text != null && message.text!.isNotEmpty) ...[
          const SizedBox(height: 6),
          SelectableText(
            message.text!,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ],
    );
  }

  Widget _buildVideoMessage() {
    return Column(
      crossAxisAlignment:
      message.isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.play_circle_filled, size: 50, color: Colors.white70),
              if (message.file != null)
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Text(
                    message.file ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
        if (message.text != null && message.text!.isNotEmpty) ...[
          const SizedBox(height: 6),
          SelectableText(
            message.text!,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ],
    );
  }

  Widget _buildLocationMessage() {
    return GestureDetector(
      onTap: () async {
        if (message.text != null && message.text!.contains('http')) {
          await _openUrl(message.text!);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.location_on, color: Colors.red, size: 24),
                SizedBox(width: 8),
                Text(
                  'Shared Location',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              message.text ?? 'Tap to open location',
              style: TextStyle(
                color: Colors.blue[300],
                fontSize: 12,
                decoration: TextDecoration.underline,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.insert_drive_file, color: Colors.white70, size: 32),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              message.file ?? 'File',
              style: const TextStyle(color: Colors.white, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    switch (message.status) {
      case VendorMessageStatus.sending:
        return const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70),
        );
      case VendorMessageStatus.sent:
        return const Icon(Icons.check, color: Colors.white70, size: 14);
      case VendorMessageStatus.delivered:
        return const Icon(Icons.done_all, color: Colors.white70, size: 14);
      case VendorMessageStatus.read:
        return const Icon(Icons.done_all, color: Colors.blue, size: 14);
      case VendorMessageStatus.failed:
        return const Icon(Icons.error, color: Colors.red, size: 14);
    }
  }

  Future<void> _openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (kDebugMode) print('Error opening URL: $e');
    }
  }
}
