class UserModel {
  String? uid;
  String? Firstname;
  String? Lastname;
  //String? Adress;
  String? nombre;
  String? email;
  String? password;
  String? image;
  String? job;
  String? Adress;
  String? description;
  UserModel({
    this.uid,
    this.email,
    this.Firstname,
    this.Lastname,
    this.password,
    this.nombre,
    this.image,
    this.job,
    this.Adress,
    this.description,
  });

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      Firstname: map['Firstname'],
      Lastname: map['Lastname'],
      Adress: map['Adress'],
      nombre: map['nombre'],
      password: map['password'],
      image: map['image'],
      job: map['job'],
      description: map['description'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'Firstname': Firstname,
      'Lastname': Lastname,
      'nombre': nombre,
      'password': password,
      'image': image,
      'job': job,
      'description': description,
      'Adress': Adress,
    };
  }
}
