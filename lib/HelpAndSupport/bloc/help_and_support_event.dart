abstract class HelpAndSupportEvent {}

class NameChanged extends HelpAndSupportEvent {
  final String name;
  NameChanged(this.name);
}

class EmailChanged extends HelpAndSupportEvent {
  final String email;
  EmailChanged(this.email);
}

class QueryChanged extends HelpAndSupportEvent {
  final String query;
  QueryChanged(this.query);
}

class SubmitForm extends HelpAndSupportEvent {}

class ResetForm extends HelpAndSupportEvent {}