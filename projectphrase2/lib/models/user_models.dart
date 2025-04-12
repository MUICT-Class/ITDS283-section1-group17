class UserModels {
  final String name;
  final String email;
  final String mobile;

  UserModels({
    required this.name,
    required this.email,
    required this.mobile,
  });
}

final demoUser = UserModels(
  name: "Thanakrit Smith",
  email: "firstname.sur@student.mahidol.ac.th",
  mobile: "xxx-xxx-xxxx",
);
