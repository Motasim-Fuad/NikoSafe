
import 'package:nikosafe/models/User/userSearch/userServiceProviderModel/bookingmodel.dart';

class BookingRepository {
  Future<void> book(BookingModel booking) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    print("Booking sent: ${booking.toJson()}");
    // Here, integrate your API call using http or your custom NetworkApiServices
  }
}