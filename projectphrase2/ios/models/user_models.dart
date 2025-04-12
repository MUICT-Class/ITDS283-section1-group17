class UserModels {
  final String name;
  final String email;
  final String mobile;
  final String status;

  UserModels({
  required this.name,
  required this.email,
  required this.mobile,
  required this.status,
});
}

final demoUser = UserModels(
  name: "Thanakrit Smith", 
  email: "firstname.sur@student.mahidol.ac.th", 
  mobile: "xxx-xxx-xxxx", 
  status: "seller");
