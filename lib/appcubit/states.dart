abstract class NewsStates {}

class InitialState extends NewsStates {}

class BottomNavigationState extends NewsStates {}



class NewsGetBussinessLoadingState extends NewsStates{}

class NewsGetBussionsSuccesState extends NewsStates{}

class NewsGetBussionsErrorState extends NewsStates 
{
  final String error;
  NewsGetBussionsErrorState(this.error);
}

class NewsGetSportsLoadingState extends NewsStates {}

class NewsGetSportsSuccesState extends NewsStates{}

class NewsGetSportsErrorState extends NewsStates 
{
  final String error;
  NewsGetSportsErrorState(this.error);
}


class NewsGetScienceLoadingState extends NewsStates {}

class NewsGetScienceSuccesState extends NewsStates{}

class NewsGetScienceErrorState extends NewsStates 
{
  final String error;
  NewsGetScienceErrorState(this.error);
}

class ChangeAppMode extends NewsStates{}