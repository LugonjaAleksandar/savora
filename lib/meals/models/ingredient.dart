import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final String name;
  final String measure;

  const Ingredient({required this.name, required this.measure});

  @override
  List<Object?> get props => <Object?>[name, measure];

  String get imageUrl => 'https://www.themealdb.com/images/ingredients/${Uri.encodeComponent(name)}-small.png';
}
