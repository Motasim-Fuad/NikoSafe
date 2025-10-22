import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nikosafe/models/Provider/chat/provider_message_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ProviderChatBubble extends StatelessWidget {
  final ServiceProviderChatMessage message;
  final VoidCallback? onRetry;

  const ProviderChatBubble({
    Key? key,
    required this.message,
    this.onRetry,
  }) : super(key: key);

  void _copyText(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
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
            if (message.messageType == ServiceProviderMessageType.location)
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
            if (message.status == ServiceProviderMessageStatus.failed)
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
                  color: isMe ? Colors.blueAccent : Colors.grey[700],
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

              if (message.status == ServiceProviderMessageStatus.failed) ...[
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
      case ServiceProviderMessageType.text:
        return SelectableText(
          message.text ?? '',
          style: const TextStyle(color: Colors.white, fontSize: 15),
        );

      case ServiceProviderMessageType.image:
        return _buildImageMessage();

      case ServiceProviderMessageType.video:
        return _buildVideoMessage();

      case ServiceProviderMessageType.location:
        return _buildLocationMessage();

      case ServiceProviderMessageType.file:
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
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: 200,
                  width: 200,
                  color: Colors.grey[800],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                          : null,
                      color: Colors.white,
                    ),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                width: 200,
                color: Colors.grey[800],
                child: const Center(
                  child: Icon(Icons.error, color: Colors.white),
                ),
              ),
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
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(Icons.play_circle_fill, color: Colors.white70, size: 50),
      ),
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
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message.text ?? 'Shared Location',
                style: TextStyle(
                  color: Colors.blue[300],
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
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
      case ServiceProviderMessageStatus.sending:
        return const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70),
        );
      case ServiceProviderMessageStatus.sent:
        return const Icon(Icons.check, color: Colors.white70, size: 14);
      case ServiceProviderMessageStatus.delivered:
        return const Icon(Icons.done_all, color: Colors.white70, size: 14);
      case ServiceProviderMessageStatus.read:
        return const Icon(Icons.done_all, color: Colors.blue, size: 14);
      case ServiceProviderMessageStatus.failed:
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
