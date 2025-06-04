

import '../../models/userHome/poll/create_poll_model.dart';

class PollRepository {
  Future<void> createPoll(PollModel poll) async {
    // Replace with real API call
    await Future.delayed(Duration(seconds: 1));
    print("Poll Created: ${poll.toJson()}");
  }
}
