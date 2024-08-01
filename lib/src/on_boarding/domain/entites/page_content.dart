import 'package:equatable/equatable.dart';

class PageContent extends Equatable {
  const PageContent({
    required this.image,
    required this.name,
    required this.description,
  });

  const PageContent.first()
      : this(
          image:
              'https://img.freepik.com/premium-vector/list-agenda-reminder-target-checkmark-management-timeline-business-planner-flat-vector-banner-landing-page-website_128772-2050.jpg?w=1380',
          name: 'Todo List',
          description: 'Enhance Your Life with Todo',
        );

  final String image;
  final String name;
  final String description;

  @override
  List<Object?> get props => [image, name, description];
}
