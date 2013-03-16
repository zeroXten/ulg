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

Run

    $ ulg -h

for more options.

Syntax
======

See [Ultra Light Graphs](http://blog.0x10.co.uk/2013/03/ultra-light-graphs-ulg.html)
