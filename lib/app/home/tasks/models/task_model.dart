class Task {
  final String name;
  final int ratePerHour;

  Task({this.name, this.ratePerHour});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }

  //As this constructor always not returns the Class instance i.e it may return null
  //So we're using factory Constructor instead.
  factory Task.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Task(
      name: map['name'] as String,
      ratePerHour: map['ratePerHour'] as int,
    );
  }
}
