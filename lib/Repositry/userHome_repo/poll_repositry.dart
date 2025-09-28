import 'package:nikosafe/Data/Network/Network_api_services.dart';
import 'package:nikosafe/models/userHome/poll/create_poll_model.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';

class PollRepository {
  final _apiService = NetworkApiServices();

  Future<CreatePollResponse> createPoll(PollModel poll) async {
    try {
      final response = await _apiService.postApi(
        poll.toJson(),
        AppUrl.socialCreatePolls,
        requireAuth: true,
      );

      return CreatePollResponse.fromJson(response);
    } catch (e) {
      print('Error creating poll: $e');
      rethrow;
    }
  }

  // Additional method to get poll by ID if needed
  Future<dynamic> getPoll(String pollId) async {
    try {
      final response = await _apiService.getApi(
        '${AppUrl.socialCreatePolls}$pollId/',
        requireAuth: true,
      );
      return response;
    } catch (e) {
      print('Error fetching poll: $e');
      rethrow;
    }
  }
}