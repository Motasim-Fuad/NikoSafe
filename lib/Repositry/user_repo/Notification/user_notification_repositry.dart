import 'package:nikosafe/models/User/Notification/userNotification_model.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';



class UserNotificationRepository {
  Future<List<UsernotificationModel>> fetchNotifications() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    return [
      // Alert notification
      UsernotificationModel(
        title: "You're Near the Limit! ...",
        message: "Based on your weight and drinks logged, your estimated BAC is 0.07%. The legal limit in your area is 0.08%.",
        time: "9:30",
        type: NotificationType.alert,
      ),

      // Connection request
      UsernotificationModel(
        title: "John wants to connect with you!",
        message: "Start sharing drink experiences, check-ins, and explore venues together.",
        time: "9:30",
        type: NotificationType.connection,
        action1: "Accept",
        action2: "Ignore",
        action3: "View Profile",
      ),

      // Quote from Plumber (matching your UI)
      UsernotificationModel(
        title: "Quote Received from John (Plumber)",
        message: "John has reviewed your job request and sent a price quote. Tap to review & accept",
        time: "9:30",
        type: NotificationType.quote,
        action1: "Review Now",
        serviceProvider: ServiceProvider(
          name: "John",
          profession: "Plumber",
          email: "abc@example.com",
          phoneNumber: "(319) 555-0115",
          location: "Downtown Los Angeles, CA",
          rating: 4.5,
          profileImageUrl: ImageAssets.userHome_peopleProfile2,
        ),
        quote: QuoteDetails(
          taskTitle: "Moving Service",
          taskDescription: "Lorem ipsum dolor sit amet consectetur. Ultrices id feugiat venenatis habitant mattis viverra elementum purus volutpat. Lacus eu molestie pulvinar rhoncus integer proin elementum. Pretium sit fringilla massa tristique aenean commodo leo. Aliquet viverra amet sit porta elementum et pellentesque posuere. Ullamcorper viverra tortor lobortis viverra auctor egestas.",
          hourlyRate: 15.0,
          totalAmount: 15.0,
          currency: "USD",
        ),
      ),

      // Quote from Lukas Wagner (matching your Review & Confirm screen)
      UsernotificationModel(
        title: "Quote Received from Lukas Wagner (Plumber)",
        message: "Lukas has reviewed your job request and sent a price quote. Tap to review & accept",
        time: "8:45",
        type: NotificationType.quote,
        action1: "Review Now",
        serviceProvider: ServiceProvider(
          name: "Lukas Wagner",
          profession: "Plumber",
          email: "lukas.wagner@example.com",
          phoneNumber: "(555) 123-4567",
          location: "Downtown Los Angeles, CA",
          rating: 4.5,
          profileImageUrl:  ImageAssets.userHome_peopleProfile3,
          appointmentDate: DateTime(2025, 1, 25),
          appointmentTime: "2:00 PM",
        ),
        quote: QuoteDetails(
          taskTitle: "Plumbing Service",
          taskDescription: "Emergency plumbing repair service for kitchen sink",
          hourlyRate: 15.0,
          totalAmount: 15.0,
          currency: "USD",
        ),
      ),

      // Electrician quote
      UsernotificationModel(
        title: "Quote Received from Mike (Electrician)",
        message: "Mike has reviewed your electrical work request and sent a competitive quote.",
        time: "7:20",
        type: NotificationType.quote,
        action1: "Review Now",
        serviceProvider: ServiceProvider(
          name: "Mike Johnson",
          profession: "Electrician",
          email: "mike.johnson@example.com",
          phoneNumber: "(555) 987-6543",
          location: "Beverly Hills, CA",
          rating: 4.8,
          profileImageUrl:  ImageAssets.userHome_peopleProfile4,
        ),
        quote: QuoteDetails(
          taskTitle: "Electrical Wiring",
          taskDescription: "Complete electrical wiring installation for new home office setup",
          hourlyRate: 25.0,
          totalAmount: 200.0,
          currency: "USD",
        ),
      ),

      // Therapist appointment
      UsernotificationModel(
        title: "Appointment Confirmed - Dr. Sarah (Therapist)",
        message: "Your therapy session has been confirmed. Don't forget to prepare any questions you'd like to discuss.",
        time: "Yesterday",
        type: NotificationType.appointment,
        action1: "View Details",
        action2: "Reschedule",
        serviceProvider: ServiceProvider(
          name: "Dr. Sarah Williams",
          profession: "Therapist",
          email: "dr.sarah@therapy.com",
          phoneNumber: "(555) 246-8135",
          location: "West Hollywood, CA",
          rating: 4.9,
          profileImageUrl: ImageAssets.userHome_peopleProfile1,
          appointmentDate: DateTime(2025, 1, 26),
          appointmentTime: "3:00 PM",
        ),
      ),

      // Personal Trainer quote
      UsernotificationModel(
        title: "Quote Received from Alex (Personal Trainer)",
        message: "Alex has prepared a custom training package quote based on your fitness goals.",
        time: "Yesterday",
        type: NotificationType.quote,
        action1: "Review Package",
        serviceProvider: ServiceProvider(
          name: "Alex Rodriguez",
          profession: "Personal Trainer",
          email: "alex.fitness@gmail.com",
          phoneNumber: "(555) 369-2580",
          location: "Santa Monica, CA",
          rating: 4.7,
          profileImageUrl:  ImageAssets.club_even1,
        ),
        quote: QuoteDetails(
          taskTitle: "Personal Training Package",
          taskDescription: "12-week comprehensive fitness training program including nutrition guidance and progress tracking",
          hourlyRate: 50.0,
          totalAmount: 600.0,
          currency: "USD",
        ),
      ),

      // Promotion notification
      UsernotificationModel(
        title: "Exclusive for Our Followers",
        message: "First 50 check-ins tonight get a free shot on the house!",
        time: "2 days ago",
        type: NotificationType.promotion,
        tag: "Downtown LA",
      ),
    ];
  }
}