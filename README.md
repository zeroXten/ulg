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

Edge Lines
----------

* `==` - solid
* `--` - dashed
* `..` - dotted
* `== label ==` - edge label
* `== label|red ==` - label is red

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
