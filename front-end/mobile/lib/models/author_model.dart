class Author {
  String name;
  String imageUrl;
  Author({required this.name, required this.imageUrl});
}

final Author mark =
    Author(name: 'Mark Lewis', imageUrl: 'assets/author1.jpg');

final Author john =
    Author(name: 'John Sabestiam', imageUrl: 'assets/author2.jpg');

final Author mike =
    Author(name: 'Mike Ruther', imageUrl: 'assets/author3.jpg');

final Author adam =
    Author(name: 'Adam Zampal', imageUrl: 'assets/author4.jpg');
final Author justin =
    Author(name: 'Justin Neither', imageUrl: 'assets/author5.jpg');
final Author sam =
    Author(name: 'Samuel Tarly', imageUrl: 'assets/author6.jpg');
final Author luther =
    Author(name: 'Luther', imageUrl: 'assets/author7.jpg');

final List<Author> authors = [luther, sam, justin, adam, mike, john, mark];
