import 'package:nikosafe/resource/asseets/image_assets.dart';

import '../../../models/Provider/providerEarningData/providerEarningData.dart';


class ProviderEarningDataRepo {
  // Simulate fetching data from an API
  Future<List<ProviderEarningDataModel>> getEarnings() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return [
      ProviderEarningDataModel(
        serial: '01',
        name: 'Robert Fox',
        accNumber: '(516) 831-1111',
        date: '02-24-2024',
        amount: '\$200',
        avatarUrl:ImageAssets.restaurant4, // Placeholder
      ),
      ProviderEarningDataModel(
        serial: '02',
        name: 'Michal ',
        accNumber: '(516) 831-1111',
        date: '02-24-2024',
        amount: '\$200',
        avatarUrl: ImageAssets.restaurant4,
      ),
      ProviderEarningDataModel(
        serial: '03',
        name: 'Robert Fox',
        accNumber: '(516) 831-1111',
        date: '02-24-2024',
        amount: '\$200',
        avatarUrl: ImageAssets.restaurant4,
      ),
      ProviderEarningDataModel(
        serial: '04',
        name: 'Robert Fox',
        accNumber: '(516) 831-1111',
        date: '02-24-2024',
        amount: '\$200',
        avatarUrl: ImageAssets.restaurant4,
      ),
      ProviderEarningDataModel(
        serial: '05',
        name: 'Robert Fox',
        accNumber: '(516) 831-1111',
        date: '02-24-2024',
        amount: '\$200',
        avatarUrl: ImageAssets.restaurant4,
      ),
      ProviderEarningDataModel(
        serial: '06',
        name: 'Robert Fox',
        accNumber: '(516) 831-1111',
        date: '02-24-2024',
        amount: '\$200',
        avatarUrl: ImageAssets.restaurant4,
      ),
      ProviderEarningDataModel(
        serial: '07',
        name: 'Robert Fox',
        accNumber: '(516) 831-1111',
        date: '02-24-2024',
        amount: '\$200',
        avatarUrl: ImageAssets.restaurant4,
      ),
      ProviderEarningDataModel(
        serial: '08',
        name: 'Robert Fox',
        accNumber: '(516) 831-1111',
        date: '02-24-2024',
        amount: '\$200',
        avatarUrl: ImageAssets.restaurant4,
      ),
      ProviderEarningDataModel(
        serial: '09',
        name: 'Robert Fox',
        accNumber: '(516) 831-1111',
        date: '02-24-2024',
        amount: '\$200',
        avatarUrl: ImageAssets.restaurant4,
      ),
    ];
  }
}