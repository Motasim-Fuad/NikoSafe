import 'package:nikosafe/resource/asseets/image_assets.dart';
import '../../../models/userSearch/trainer/trainer_model.dart';

class TrainerRepository {
  Future<List<TrainerModel>> fetchTrainers() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network delay

    return [
      TrainerModel(
        name: 'John Smith',
        role: 'Fitness trainer',
        experience: '10+ Years',
        rate: '\$50/hour',
        imageUrl: ImageAssets.bar3,
      ),
      TrainerModel(
        name: 'Jane Doe',
        role: 'Yoga instructor',
        experience: '8+ Years',
        rate: '\$45/hour',
        imageUrl: ImageAssets.bar2,
      ),
      TrainerModel(
        name: 'Mike Tyson',
        role: 'Boxing coach',
        experience: '15+ Years',
        rate: '\$70/hour',
        imageUrl: ImageAssets.bar1,
      ),
      TrainerModel(
        name: 'Anna Lee',
        role: 'Pilates expert',
        experience: '5+ Years',
        rate: '\$40/hour',
        imageUrl: ImageAssets.bar4,
      ),
      TrainerModel(
        name: 'Chris Evans',
        role: 'Strength coach',
        experience: '12+ Years',
        rate: '\$60/hour',
        imageUrl: ImageAssets.bar5,
      ),
      TrainerModel(
        name: 'Nina Brown',
        role: 'Dance trainer',
        experience: '7+ Years',
        rate: '\$55/hour',
        imageUrl: ImageAssets.restaurant4,
      ),
    ];
  }
}
