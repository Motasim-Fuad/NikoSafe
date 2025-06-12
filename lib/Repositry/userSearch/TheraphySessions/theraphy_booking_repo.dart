
import 'package:nikosafe/models/userSearch/theraphy_session/theraphy_booking_model.dart';

class TheraphyBookingRepo {
  Future<void> bookTrainer(TheraphyBookingModel booking) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    print("Booking sent: ${booking.toJson()}");
    // Here, integrate your API call using http or your custom NetworkApiServices
  }
}
