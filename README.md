TODO:
* Contact the GGLib owner to talk about the FadeScreen bug. Thank him so much for making this lib and make my life easier
* Code map editor's save screen and test Map::save_file()
* Code map editor's new map screen asking for parameters in TextBox'es.
* Think about the IA
* Load sprites with files as with maps
* Think about a play button in the map editor, just calling the state made for the game
* Fix the horrible map file format, please
* Test paths in file formats, so that you can load everything everywhere, and not to have every map all over the source tree.
* Add GUIs to map editor for creating, saving and loading. [33.3%]
* Put a bit of order in ZOrder.
* Get a beer.


ACHIEVED:
* 2 ways to make a Map. From zero and from a file
* Command line help and stuff. Two ways to launch the map editor (specify map data by params or specify just one file). Three in the future (add calling the mapeditor without args, splashing to create new map).
* Basic interface with GGLib::StateObject switching and a nice background
* Added save, load and new map buttons
* In map editor, if no args specified, create new map (splash the gui).
* Switching between Edition and Load, and successful data (map) sharing with some tricky code. 