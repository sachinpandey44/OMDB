# OMDB 􏰀iOS App


## Overview

 OMDB is a mobile app that allows the user to search for any movie title, view the list of search results and details of the selected movie. The app fetches the movies data from The Open Movie Database (OMDb) REST API at http://www.omdbapi.com/.  The app contains two screens with details below:
 
1. Movies List Screen:
a. Includes facility to search for a movie with title
b. A list of movies that is scrollable and when the user reach the end of the screen, it 
fetches the next set of results if there is any.
d. The movie list is fetched from the OMDb. 
e. Tapping on a movie takes the user to Movie Details screen
2. Movie Details Screen:
a. The movie details is fetched from OMDb.
b. The user should be able to navigate back to the Movies List screen

## Salient Features:
- Implemented movie list screen with search and movie details screen.
- UI - Use of drop shadows and vibrancy for enhancing the visual experience.
- Unit test cases for testing the service and data layer. 
- Performance: Use of Apple recommended approach to fetch images from URL with image cache using CGImageSource. 
- Use of CollectionView prefetching for smoother background fetch of data to be displayed on upcoming cells as user scrolls. 

##improvements and future scope:
- Adding more details in Detail screen.
- Further performance enhancement. 
- Completely decoupling UI and data layers using MVVM or VIPER architecture. At present the UIViewController is coupled with it's data source. 

