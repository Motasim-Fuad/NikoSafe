import '../../../models/userSearch/userServiceProviderModel/user_services_provider.dart';


class UserServiceProviderRepository {
  Future<List<UserServiceProvider>> fetchProviders() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // Hardcoded list of multiple service providers
    return [
      UserServiceProvider(
        id: '1',
        name: 'Lukas Wagner',
        service: 'Plumber',
        experience: '10+ Years',
        rate: '\$50/hour',
        imageUrl: 'https://i.pravatar.cc/150?img=10',
        skills: ['Pipe repair', 'Leak detection', 'Water heater installation'],
        reviews: [
          ReviewModel(
            reviewerName: "Alice",
            rating: 4.5,
            reviewText: "Very professional and quick response.",
            reviewDate: "2025-06-21",
          ),
          ReviewModel(
            reviewerName: "Bob",
            rating: 5.0,
            reviewText: "Excellent service, highly recommend!",
            reviewDate: "2025-06-18",
          ),
        ],
        rating: 4.8,
        totalRatings: 20,
        totalReviews: 15,

      ),
      UserServiceProvider(
        id: '2',
        name: 'Sophia Lee',
        service: 'Electrician',
        experience: '8 Years',
        rate: '\$45/hour',
        imageUrl: 'https://i.pravatar.cc/150?img=11',
        skills: ['Wiring', 'Lighting', 'Panel upgrade'],
        reviews: [
          ReviewModel(
            reviewerName: "Alice",
            rating: 4.5,
            reviewText: "Very professional and quick response.",
            reviewDate: "2025-06-21",
          ),
          ReviewModel(
            reviewerName: "Bob",
            rating: 5.0,
            reviewText: "Excellent service, highly recommend!",
            reviewDate: "2025-06-18",
          ),
        ],
        rating: 4.8,
        totalRatings: 20,
        totalReviews: 15,

      ),
      UserServiceProvider(
        id: '3',
        name: 'Daniel Smith',
        service: 'Painter',
        experience: '12 Years',
        rate: '\$60/hour',
        imageUrl: 'https://i.pravatar.cc/150?img=20',
        skills: ['Wiring', 'Lighting', 'Panel upgrade'],
        reviews: [
          ReviewModel(
            reviewerName: "Alice",
            rating: 4.5,
            reviewText: "Very professional and quick response.",
            reviewDate: "2025-06-21",
          ),
          ReviewModel(
            reviewerName: "Bob",
            rating: 5.0,
            reviewText: "Excellent service, highly recommend!",
            reviewDate: "2025-06-18",
          ),
        ],
        rating: 4.8,
        totalRatings: 20,
        totalReviews: 15,

      ),
      UserServiceProvider(
        id: '4',
        name: 'Emma Brown',
        service: 'Carpenter',
        experience: '7 Years',
        rate: '\$55/hour',
        imageUrl: 'https://i.pravatar.cc/150?img=14',
        skills: ['Wiring', 'Lighting', 'Panel upgrade'],
        reviews: [
          ReviewModel(
            reviewerName: "Alice",
            rating: 4.5,
            reviewText: "Very professional and quick response.",
            reviewDate: "2025-06-21",
          ),
          ReviewModel(
            reviewerName: "Bob",
            rating: 5.0,
            reviewText: "Excellent service, highly recommend!",
            reviewDate: "2025-06-18",
          ),
        ],
        rating: 4.8,
        totalRatings: 20,
        totalReviews: 15,

      ),
      UserServiceProvider(
        id: '5',
        name: 'Olivia Wilson',
        service: 'Electrician',
        experience: '6 Years',
        rate: '\$40/hour',
        imageUrl: 'https://i.pravatar.cc/150?img=19',
        skills: ['Wiring', 'Lighting', 'Panel upgrade'],
        reviews: [
          ReviewModel(
            reviewerName: "Alice",
            rating: 4.5,
            reviewText: "Very professional and quick response.",
            reviewDate: "2025-06-21",
          ),
          ReviewModel(
            reviewerName: "Bob",
            rating: 5.0,
            reviewText: "Excellent service, highly recommend!",
            reviewDate: "2025-06-18",
          ),
        ],
        rating: 4.8,
        totalRatings: 20,
        totalReviews: 15,

      ),
      UserServiceProvider(
        id: '6',
        name: 'James Johnson',
        service: 'Plumber',
        experience: '15 Years',
        rate: '\$65/hour',
        imageUrl: 'https://i.pravatar.cc/150?img=16',
        skills: ['Wiring', 'Lighting', 'Panel upgrade'],
        reviews: [
          ReviewModel(
            reviewerName: "Alice",
            rating: 4.5,
            reviewText: "Very professional and quick response.",
            reviewDate: "2025-06-21",
          ),
          ReviewModel(
            reviewerName: "Bob",
            rating: 5.0,
            reviewText: "Excellent service, highly recommend!",
            reviewDate: "2025-06-18",
          ),
        ],
        rating: 4.8,
        totalRatings: 20,
        totalReviews: 15,

      ),
      UserServiceProvider(
        id: '7',
        name: 'Ava Garcia',
        service: 'Painter',
        experience: '9 Years',
        rate: '\$50/hour',
        imageUrl: 'https://i.pravatar.cc/150?img=17',
        skills: ['Wiring', 'Lighting', 'Panel upgrade'],
        reviews: [
          ReviewModel(
            reviewerName: "Alice",
            rating: 4.5,
            reviewText: "Very professional and quick response.",
            reviewDate: "2025-06-21",
          ),
          ReviewModel(
            reviewerName: "Bob",
            rating: 5.0,
            reviewText: "Excellent service, highly recommend!",
            reviewDate: "2025-06-18",
          ),
        ],
        rating: 4.8,
        totalRatings: 20,
        totalReviews: 15,

      ),
      UserServiceProvider(
        id: '8',
        name: 'William Martinez',
        service: 'Carpenter',
        experience: '11 Years',
        rate: '\$60/hour',
        imageUrl: 'https://i.pravatar.cc/150?img=18',
        skills: ['Wiring', 'Lighting', 'Panel upgrade'],
        reviews: [
          ReviewModel(
            reviewerName: "Alice",
            rating: 4.5,
            reviewText: "Very professional and quick response.",
            reviewDate: "2025-06-21",
          ),
          ReviewModel(
            reviewerName: "Bob",
            rating: 5.0,
            reviewText: "Excellent service, highly recommend!",
            reviewDate: "2025-06-18",
          ),
        ],
        rating: 4.8,
        totalRatings: 20,
        totalReviews: 15,

      ),   UserServiceProvider(
        id: '9',
        name: 'Niko Williams',
        service: 'Trainer',
        experience: '11 Years',
        rate: '\$60/hour',
        imageUrl: 'https://i.pravatar.cc/150?img=49',
        skills: ['Wiring', 'Lighting', 'Panel upgrade'],
        reviews: [
          ReviewModel(
            reviewerName: "Alice",
            rating: 4.5,
            reviewText: "Very professional and quick response.",
            reviewDate: "2025-06-21",
          ),
          ReviewModel(
            reviewerName: "Bob",
            rating: 5.0,
            reviewText: "Excellent service, highly recommend!",
            reviewDate: "2025-06-18",
          ),
        ],
        rating: 4.8,
        totalRatings: 20,
        totalReviews: 15,

      ),

      UserServiceProvider(
        id: '10',
        name: 'Kan Devilry',
        service: 'Therapy',
        experience: '11 Years',
        rate: '\$60/hour',
        imageUrl: 'https://i.pravatar.cc/150?img=30',
        skills: ['Wiring', 'Lighting', 'Panel upgrade'],
        reviews: [
          ReviewModel(
            reviewerName: "Alice",
            rating: 4.5,
            reviewText: "Very professional and quick response.",
            reviewDate: "2025-06-21",
          ),
          ReviewModel(
            reviewerName: "Bob",
            rating: 5.0,
            reviewText: "Excellent service, highly recommend!",
            reviewDate: "2025-06-18",
          ),
        ],
        rating: 4.8,
        totalRatings: 20,
        totalReviews: 15,

      ),

      UserServiceProvider(
        id: '11',
        name: 'Vini',
        service: 'Trainer',
        experience: '11 Years',
        rate: '\$60/hour',
        imageUrl: 'https://i.pravatar.cc/150?img=32',
        skills: ['Wiring', 'Lighting', 'Panel upgrade'],
        reviews: [
          ReviewModel(
            reviewerName: "Alice",
            rating: 4.5,
            reviewText: "Very professional and quick response.",
            reviewDate: "2025-06-21",
          ),
          ReviewModel(
            reviewerName: "Bob",
            rating: 5.0,
            reviewText: "Excellent service, highly recommend!",
            reviewDate: "2025-06-18",
          ),
        ],
        rating: 4.8,
        totalRatings: 20,
        totalReviews: 15,

      ),

      UserServiceProvider(
        id: '12',
        name: 'Messi',
        service: 'Therapy',
        experience: '11 Years',
        rate: '\$60/hour',
        imageUrl: 'https://i.pravatar.cc/150?img=33',
        skills: ['Wiring', 'Lighting', 'Panel upgrade'],
        reviews: [
          ReviewModel(
            reviewerName: "Alice",
            rating: 4.5,
            reviewText: "Very professional and quick response.",
            reviewDate: "2025-06-21",
          ),
          ReviewModel(
            reviewerName: "Bob",
            rating: 5.0,
            reviewText: "Excellent service, highly recommend!",
            reviewDate: "2025-06-18",
          ),
        ],
        rating: 4.8,
        totalRatings: 20,
        totalReviews: 15,

      ),
    ];
  }
}
