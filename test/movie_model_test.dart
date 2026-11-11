
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/models/movie.dart';

void main() {

  final movieJson = {'id': 550, 'title': 'Fight Club', 'release_date': '1999-10-15'};
  final tvJson = {'id': 1668, 'name': 'Friends', 'first_air_date': '1994-09-22'};
  final tvNoDateJson = {'id': 999, 'name': 'New Show'};
  test('tv json uses name as title', () {
    final movie = Movie.fromJson(tvJson);
    expect(movie.title, 'Friends');
  });

  test('tv json without a date gets an empty release date', (){
    final movie = Movie.fromJson(tvNoDateJson);
    expect(movie.releaseDate, '');
  });

  test('movie and tv show with the same id are not the same', (){
    final swatMovie = Movie(id: 1, title: 'swat', releaseDate: '1995-04-05', mediaType: 'movie');
    final swatShow = Movie(id: 1, title: 'swat', releaseDate: '1995-04-05', mediaType: 'tv');
    
    expect(swatMovie.isSame(swatShow), false);
  });  
  
  test('two movies with the same id are the same', (){
    final swatMovie = Movie(id: 1, title: 'swat', releaseDate: '1995-04-06', mediaType: 'movie');
    final princeShow = Movie(id: 1, title: 'prince', releaseDate: '1995-04-05', mediaType: 'movie');
    
    expect(swatMovie.isSame(princeShow), true);
  });

  test('after toJson and fromJson we get the same movie',(){
    final swatMovie1 = Movie(id: 1, title: 'swat', releaseDate: '1995-04-06', mediaType: 'tv');
    final swatMovieJson = swatMovie1.toJson();
    final swatMovie2 = Movie.fromJson(swatMovieJson);
    expect(swatMovie2.isSame(swatMovie1), true);
  });

}