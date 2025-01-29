import 'package:habit/habit/data/habit_repository.dart';
import 'package:habit/habit/domain/create_habit_dto.dart';
import 'package:result_dart/result_dart.dart';

class CreateHabitUseCase {
  final HabitRepository _repository;

  CreateHabitUseCase({required HabitRepository repository})
      : _repository = repository;

  AsyncResult<Unit> execute(CreateHabitDto dto) async {
    await _repository.create(dto);
    return const Success(unit);
  }
}
