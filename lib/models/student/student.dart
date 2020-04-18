class Student {
  // private vars >>
  String _name;
  String _phoneNumber;
  String _email;

  // constructor with all data >>
  Student({String name, String email, String phoneNumber}) {
    this._email = email;
    this._phoneNumber = phoneNumber;
    this._name = name;
  }

// return the current object as a map >>
  Map<String, dynamic> asMap() {
    return {
      'name': this._name,
      'phoneNumber': this._phoneNumber,
    };
  }

  //getters and setters >>
  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}
