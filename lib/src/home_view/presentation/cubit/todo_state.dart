part of 'todo_cubit.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {
  TodoInitial() {
    print(' sat TodoInitial');
  }
}

class TodoLoading extends TodoState {
  TodoLoading(this.state) {
    print('sat loading $state');
  }

  final TodoState state;
}

String uuid = const Uuid().v4();

class TodoError extends TodoState {
  const TodoError(this.message, {this.value});

  TodoError.withUuid(this.message) : value = const Uuid().v4();

  const TodoError.empty(
    String message,
    String uuid,
  ) : this(value: uuid, message);

  final String message;
  final String? value;

  @override
  List<Object?> get props => [message, value];
}

class TodosLoaded extends TodoState {
  const TodosLoaded(this.todos);
  final List<Todo> todos;

  @override
  List<Object?> get props => [todos];
}

class FoldersLoaded extends TodoState {
  const FoldersLoaded(this.folders);
  final List<Folder> folders;

  @override
  List<Object?> get props => [folders];
}

class TodoActionCompleted extends TodoState {}

class SyncCompleted extends TodoState {}

class MyDayState extends TodoState {}

class ImportantState extends TodoState {}

class PlannedState extends TodoState {}

class CompletedState extends TodoState {}

class AllTodoState extends TodoState {}

class AddTaskCompletedState extends TodoState {}

class CreateFolderCompletedState extends TodoState {}

class DeleteSucessfulFolderState extends TodoState {}

class DeleteMultipleSucessfulFolderState extends TodoState {}

class DeleteTodoCompletedState extends TodoState {}

class FirstTimeLoadCompletedState extends TodoState {}

class StartListeningsCompletedState extends TodoState {}

class StopListeningsCompletedState extends TodoState {}

class UpdateTodoCompletedState extends TodoState {}

class UpdateImportantCompletedState extends TodoState {}

class FolderState extends TodoState {
  const FolderState(this.name);

  final String name;
}

class ChangeState extends TodoState {
  const ChangeState({required this.change});

  final bool change;
}
