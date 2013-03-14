About
=====

Ultra Light Graphs, or ULG, is a simple way of creating graph images from nothing more than a few lines of text such as

    (internet)	===>	[web dmz]

Installaton
===========

ULG is just a ruby script that uses two gems. Install ruby, for example using rvm, then run

    $ gem install ruby-graphviz
    $ gem install getopt

Usage
=====

    $ ./ulg.rb -f file.ulg

This will create file.ulg.png by default. Run

    $ ./ulg.rb -h

for more options.

Syntax
======

See [Ultra Light Graphs](http://blog.0x10.co.uk/2013/03/ultra-light-graphs-ulg.html)
