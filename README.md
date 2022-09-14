# Weather Track

This app is simple and has two main functionalities: it shows the forecast for 5 cities and let you search the current weather for any city in the world.

In the home screen, the forecast is shown for the following cities:

- Silverstone, UK
- São Paulo, Brazil
- Melbourne, Australia
- Monte Carlo, Monaco

The app will show cards for each city. The card is scrollable, and you can see up to 5 days ahead in time. You can pull down to refresh the current data in home screen.

At the top of the screen, there's a search button that leads you to a search screen. You can see suggested cities there. You can type the name of any city in the world, and the app will fetch the current weather for the city, and show it for you. You can pull down to refresh the current data in this screen.

This app also supports offline mode. In order to use it offline, you must open the app at least one time, and it will automatically store the data fetched from server. Searches made using current weather are not stored.

This app uses a layered architecture that aims to follow SOLID principles, where the main focus is to keep the app domain decoupled from any kind of external agent. We use abstractions for interacting with the external world, such as an API or local cache. With this approach, we can easily change packages, when they become outdated, or even incompatible with newer versions of Dart and Flutter. Futhermore, testing is easy at this level of decoupling, since we can mock any external agent due the factor we are relying on abstractions instead of real implementations.

The following packages are used:
  - bloc, to manage the state in a predictable way
  - flutter_bloc, to build the screen, since we are using bloc (we could also use a StreamBuilder, but this package is better) 
  - connectivity_plus, to be informed if the device has an active internet connection (althrough we could write our own methods)
  - hive, to cache some data
  - uno, a new HTTP client inspired by Axios
  - path_provider, to provide us a path for our cache
  - animations, for a simple fade through transition
  - faker, to mock some data
  - mocktail, to mock classes and perform some unit tests
  - flutter_modular, to modularization, routing and dependency injection

Not everything is properly tested due time, but its perfectly possible to do it later. There are some extensions in the project that you may find useful. The main goal here is not to use a package for everything, but just what is necessary (or convenient).

### Screenshots

<span>
  <img src="https://raw.githubusercontent.com/pedrolemoz/weather_track/master/assets/1.png" width=250px/>
  <img src="https://raw.githubusercontent.com/pedrolemoz/weather_track/master/assets/2.png" width=250px/>
  <img src="https://raw.githubusercontent.com/pedrolemoz/weather_track/master/assets/3.png" width=250px/>
</span>

<span>
  <img src="https://raw.githubusercontent.com/pedrolemoz/weather_track/master/assets/4.png" width=250px/>
  <img src="https://raw.githubusercontent.com/pedrolemoz/weather_track/master/assets/5.png" width=250px/>
  <img src="https://raw.githubusercontent.com/pedrolemoz/weather_track/master/assets/6.png" width=250px/>
</span>
