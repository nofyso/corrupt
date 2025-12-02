class FafuLoginParameter {
  String studentId;
  String password;

  FafuLoginParameter(this.studentId, this.password);
}

class FafuLoginResult {
  String studentName;
  String token;

  FafuLoginResult(this.studentName, this.token);
}
