import '../../../models/userSearch/userServiceProviderModel/user_services_provider.dart';


class UserServiceProviderRepository {
  Future<List<UserServiceProvider>> fetchProviders() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // Hardcoded list of multiple service providers
    return [
      UserServiceProvider(
        name: 'Lukas Wagner',
        service: 'Plumber',
        experience: '10+ Years',
        rate: '\$50/hour',
        imageUrl: 'https://i.pravatar.cc/150?img=10',
        skills: ['Pipe repair', 'Leak detection', 'Water heater installation'],
      ),
      UserServiceProvider(
        name: 'Sophia Lee',
        service: 'Electrician',
        experience: '8 Years',
        rate: '\$45/hour',
        imageUrl: 'https://i.pravatar.cc/150?img=11',
        skills: ['Wiring', 'Lighting', 'Panel upgrade'],
      ),
      UserServiceProvider(
        name: 'Daniel Smith',
        service: 'Painter',
        experience: '12 Years',
        rate: '\$60/hour',
        imageUrl: 'https://i.pravatar.cc/150?img=20',
        skills: ['Wiring', 'Lighting', 'Panel upgrade'],
      ),
      UserServiceProvider(
        name: 'Emma Brown',
        service: 'Carpenter',
        experience: '7 Years',
        rate: '\$55/hour',
        imageUrl: 'https://i.pravatar.cc/150?img=14',
        skills: ['Wiring', 'Lighting', 'Panel upgrade'],
      ),
      UserServiceProvider(
        name: 'Olivia Wilson',
        service: 'Electrician',
        experience: '6 Years',
        rate: '\$40/hour',
        imageUrl: 'https://i.pravatar.cc/150?img=19',
        skills: ['Wiring', 'Lighting', 'Panel upgrade'],
      ),
      UserServiceProvider(
        name: 'James Johnson',
        service: 'Plumber',
        experience: '15 Years',
        rate: '\$65/hour',
        imageUrl: 'https://i.pravatar.cc/150?img=16',
        skills: ['Wiring', 'Lighting', 'Panel upgrade'],
      ),
      UserServiceProvider(
        name: 'Ava Garcia',
        service: 'Painter',
        experience: '9 Years',
        rate: '\$50/hour',
        imageUrl: 'https://i.pravatar.cc/150?img=17',
        skills: ['Wiring', 'Lighting', 'Panel upgrade'],
      ),
      UserServiceProvider(
        name: 'William Martinez',
        service: 'Carpenter',
        experience: '11 Years',
        rate: '\$60/hour',
        imageUrl: 'https://i.pravatar.cc/150?img=18',
        skills: ['Wiring', 'Lighting', 'Panel upgrade'],
      ),
    ];
  }
}
