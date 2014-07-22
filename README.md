Works with
====
* Ruby 1.9.3
* Gosu 0.7.5 

To install gosu:

```
gem install gosu
```

Features
====
* AI platform for Pacman game
* Pacman and ghosts included
* Original rules respected (for ghosts, Pacman just dies and game is reset)
* Clean and easy-to-use interface for coding AI
* Pathfinding included using NavigationMap interface
* EDITOR INCLUDED!

Current state
====
The only thing somehow usable is the editor. You can also run the game, but
the focus is currently being on AI framework, so the game rules are still at
a half way. Also, I plan on writing a guide on using the AI interface
so that anyone can use it, but this is an early version of what it'll be.

Using the editor
====
We can load an existing map or create a new one from scratch

```
$ ruby mapeditor/Main.rb
Usage:
        * ruby Main.rb <map file>
        * ruby Main.rb <map width>
                       <map height>
```

In the editor, we can place tiles of several kinds:
* Solid
* Free
* Ghost spawn zone
* Pacman spawn
* Ghost barrier
* Warps (with a few restrictions of placement)

Also, we can save the map or load any other (remember you should be
running from root folder).


Running the bare version
====
We just have to execute Main.rb in order to play. Also, as this is a
very early version, it's currently of no interest at all. For example, you will
find that warps doesn't work, they just break the game.

```
ruby Main.rb
```

or

```
ruby Main.rb some/map
```


