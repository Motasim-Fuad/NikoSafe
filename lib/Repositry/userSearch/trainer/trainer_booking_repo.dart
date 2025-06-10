
import '../../../models/userSearch/trainer/trainer_booking_model.dart';

class TrainerBookingRepository {
  Future<void> bookTrainer(TrainerBookingModel booking) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    print("Booking sent: ${booking.toJson()}");
    // Here, integrate your API call using http or your custom NetworkApiServices
  }
}
