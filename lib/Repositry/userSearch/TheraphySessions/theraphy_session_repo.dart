import '../../../models/userSearch/theraphy_session/theraphy_session_model.dart';
import '../../../resource/asseets/image_assets.dart';


class TheraphySessionRepository {
  Future<List<TheraphySessionModel>> fetchTherapySessions() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API delay

    return [
      TheraphySessionModel(
        price: '\$100',
        imageUrl: ImageAssets.spa1,
        isAvailable: true,
        name: 'Swedish massage',
        time: '9:00 AM - 3:30 PM',
        weekend: 'Monday to Friday'
      ),
      TheraphySessionModel(
        price: '\$80',
        imageUrl: ImageAssets.spa2,
        isAvailable: false,
        name: 'Deep tissue massage',
        time: '9:00 AM - 3:30 PM',
        weekend: 'Monday to Friday'
      ),
      TheraphySessionModel(
        price: '\$120',
        imageUrl: ImageAssets.spa3,
        isAvailable: true,
        name: 'Hot stone massage',
          time: '9:00 AM - 3:30 PM',
          weekend: 'Monday to Friday'
      ),

      TheraphySessionModel(
        price: '\$120',
        imageUrl: ImageAssets.spa4,
        isAvailable: true,
        name: 'Thai massage',
          time: '9:00 AM - 3:30 PM',
          weekend: 'Monday to Friday'
      ),

      TheraphySessionModel(
        price: '\$70',
        imageUrl: ImageAssets.bar5,
        isAvailable: true,
        name: 'Shiatsu',
          time: '9:00 AM - 3:30 PM',
          weekend: 'Monday to Friday'
      ),
    ];
  }
}
