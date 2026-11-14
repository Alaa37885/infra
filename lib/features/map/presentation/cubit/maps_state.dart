part of 'maps_cubit.dart';

@immutable
abstract class MapsState {}

class MapsInitial extends MapsState {}

class PlacesLoaded extends MapsState {
  final List<PlaceSuggestion> suggestions;
  PlacesLoaded(this.suggestions);
}

class PlaceLocationLoaded extends MapsState {
  final Place place;
  PlaceLocationLoaded(this.place);
}
