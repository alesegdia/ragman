TODO:

* Thinking about the IA
* Load sprites with files as with maps
* Fix the horrible map file format, please
* Check for paths in file formats (map
	and sprite), just to have every map into
	one single folder and not repeated in
	every use of it.
* Add GUIs to map editor for creating, saving and loading.
* In map editor, if no args specified, create new map (splash the gui).
* Put a bit of order in ZOrder.
* Save and load can be done in the future, within the same EditionState,
  so that we don't have to mess around states.
* When passing from EditionState to SaveState or others, everything is killed. 
  Maybe you'll have to make another state just to load the map the first time (without GUI, maybe a splash screen), and another just for editing.
* Get a beer.


ACHIEVED:
* 2 ways to make a Map. From zero and from a file
* Command line help and stuff. Two ways to launch the map editor (specify map data by params or specify just one file). Three in the future (add calling the mapeditor without args, splashing to create new map).
* Basic interface with GGLib::StateObject switching and a nice background
* Added save, load and new map buttons