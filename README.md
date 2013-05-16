About
=====

Ultra Light Graphs, or ULG, is a simple way of creating graph images from nothing more than a few lines of text such as

    (internet)	===>	[web dmz]

Installaton
===========

Install the gem as usual

    $ gem install ulg

ULG requires ruby-graphviz and getopt

    $ gem install ruby-graphviz
    $ gem install getopt

Usage
=====

You can give it a file

    $ ulg file.ulg

This will create file.ulg.png by default. 

You can give it multiple files

    $ ulg file1.ulg file2.ulg

ULG will parse each file in the order specified, effectively concatinating them into one big file. Default output file is graph.png.

You can read from STDIN, especially useful if copying and pasting some graphs from documentation etc

    $ ulg
    (test1) ==> [test2]

Or

    $ ulg <<EOF
    (test1) ==> [test2]
    EOF

Other options:

    $ ulg -h
    Usage: ulg.rb [-o OUTPUT] [-s FILE] [-d] FILE FILE...

    Reads from stdin if no input FILE given

    Other options:

      -o OUTPUT  Output format (png, dot, svg). Default png
      -s FILE    Save to file
      -d         Debug mode
      -h         This help

Syntax
======

    # A comment

    # Set global graphviz options
    option NAME VALUE

    # Include nodes and edges from other files
    include FILE

    # Clear style for existing node
    clear NODE

    # General format is NODE ARROW NODE
    nodeA ==> nodeB

Nodes
-----

* `node A` - box
* `[node A]` - box
* `(node A)` - oval
* `<node A>` - diamond
* `{node A}` - hexagon
* `[node A|red]` - label is red

Style is determined by the first occurance of a node, so you can do this

    (node A|green) ==> [node B|red]
    node A         ==> {node C}

Instead of this

    (node A|green) ==> [node B|red]
    (node A|green) ==> {node C}
   
So you only have to update a style in one place.

You can however clear the style of an existing node:

    (node A|green) ==> [node B|red]

    clear node A

    [node A|red] ==> [node C|yellow]

This would result in a red boxed node A. You might want to use this to change nodes defined in other files being used.

Edge Lines
----------

* `==` - solid
* `--` - dashed
* `..` - dotted
* `== label ==` - edge label
* `== label|red ==` - label is red

At least two arrow characters are required. If using a label, at least one character must be on either side of the label.

Arrow Head
----------

* `==` - none
* `==>` - normal
* `==<>` - diamond
* `==x` - box
* `==o` - dot

Note: Arrow tails are not currently supported.

Any colour understood by graphviz should work for edge and node labels.

Tutorial
========

See [Ultra Light Graphs](http://blog.0x10.co.uk/2013/03/ultra-light-graphs-ulg.html)

Changelog
=========

ULG 0.2.3, 2013-05-15
---------------------

* Started a change log :D
* Fix whitespace left at the end of labels
* Added some unit tests (more to come)#


