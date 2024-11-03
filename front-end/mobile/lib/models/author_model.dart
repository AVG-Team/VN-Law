class Author {
  String name;
  String imageUrl;
  String role;
  Author({required this.name, required this.imageUrl, required this.role});
}

final Author mark =
    Author(name: 'Mark Lewis',role: "Quản trị viên" ,imageUrl: 'assets/author1.jpg');

final Author john =
    Author(name: 'John Sabestiam',role: "Thành viên" ,imageUrl: 'assets/author2.jpg');

final Author mike =
    Author(name: 'Mike Ruther', role: "Thành viên", imageUrl: 'assets/author3.jpg');

final Author adam =
    Author(name: 'Adam Zampal',role: "Thành viên", imageUrl: 'assets/author4.jpg');
final Author justin =
    Author(name: 'Justin Neither',role: "Thành viên", imageUrl: 'assets/author5.jpg');
final Author sam =
    Author(name: 'Samuel Tarly',role: "Thành viên", imageUrl: 'assets/author6.jpg');
final Author luther =
    Author(name: 'Luther',role: "Thành viên", imageUrl: 'assets/author7.jpg');

final List<Author> authors = [luther, sam, justin, adam, mike, john, mark];
