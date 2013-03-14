#!/usr/bin/env ruby

require "getopt/std"
require "graphviz"

class ULG

  attr_accessor :destfile, :output

  def initialize
    @debug = 0
    @destfile = nil
    @output = "png"

    @read_files = []

    @graphviz_options = { "type" => "digraph" }

    @nodes = {}
    @edges = {}

    @rex = []

    @rex << '(?<from_open>[\[\<\(\{]*)'
    @rex << '(?<from_label>[^\]\>\)\|\}\=\-\.]+)'
    @rex << '(?<from_color>\|[^\]\>\)\}]+)?'
    @rex << '(?<from_close>[\]\>\)\}]*)\s+'
    
    @rex << '(?<from_arrow>[\<\>ox]*)'

    @rex << '(?<edge_open>[\=\-\.]+)'
    @rex << '(?<edge_label>[^\=\-\|\.]*)'
    @rex << '(?<edge_color>\|[^\=\-\|\.]+)?'
    @rex << '(?<edge_close>[\=\-\.]+)'

    @rex << '(?<to_arrow>[\<\>ox]*)\s+'

    @rex << '(?<to_open>[\[\<\(\{]*)'
    @rex << '(?<to_label>[^\]\>\)\|\}\=\-\.]+)'
    @rex << '(?<to_color>\|[^\]\>\)\}]+)?'
    @rex << '(?<to_close>[\]\>\)\}]*)'

    @arrow_regex = @rex.join('\s*')
  end

  def debug
    @debug = 1
  end

  def dputs(msg)
    puts "DEBUG #{msg}" if @debug == 1
  end

  def draw(file)
    dputs "Rex: #{@arrow_regex}"

    parse file

    g = GraphViz.new :G, @graphviz_options

    @edges.keys.each do |from|
      @edges[from].keys.each do |to|

	from_label = @nodes[from]["label"]
	from_opts = @nodes[from].clone
	from_opts.delete "label"

	to_label = @nodes[to]["label"]
	to_opts = @nodes[to].clone
	to_opts.delete "label"

	dputs "Building from node for #{from_label} as #{from}"
        from_node = g.add_nodes from_label, from_opts
	dputs "Building to node for #{to_label} as #{to}"
        to_node = g.add_nodes to_label, to_opts

	dputs "Building edge for #{from} #{to}"
        g.add_edges from_node, to_node, @edges[from][to]

      end
    end

    if not @destfile
      @destfile = "#{file}.#{@output}"
    end

    puts "Saving output to #{@destfile}"
    g.output @output => @destfile
  end

  def parse(file)

    puts "Reading #{file}"
    if @read_files.include? file
      dputs "Skipping #{file} as I've seen it before"
      return
    end

    fh = File.new file, "r"
    while line = fh.gets
      parse_line line
    end

    @read_files << file
  end

  def parse_line(line)
    line.chomp!

    case line
    when /^\s*option\s+(?<option>\w+)\s+(?<value>\w+)\s*$/i
      set_option $~[:option], $~[:value]

    when /^\s*include\s+(?<file>.*)$/i
      parse $~[:file]

    when /^\s*#{@arrow_regex}\s*$/
      from = add_node $~[:from_open], $~[:from_label], $~[:from_color], $~[:from_close]
      to = add_node $~[:to_open], $~[:to_label], $~[:to_color], $~[:to_close]

      add_edge from, to, $~[:from_arrow], $~[:edge_open], $~[:edge_label], $~[:edge_color], $~[:edge_close], $~[:to_arrow] 
    end
  end

  def set_option(option, value)
    @graphviz_options[option] = value
  end

  def add_node(open, label, color, close)

    label.lstrip.rstrip!
    name = label_to_name label

    if @nodes.has_key? name
      return name
    end

    dputs "Adding node #{name}"

    if color
      color = color.gsub /\|+/, ""
    else
      color = "black"
    end

    case open
    when '<'
      shape = "diamond"
    when '('
      shape = "oval"
    when '{'
      shape = "hexagon"
    else
      shape = "box"
    end

    @nodes[name] = { "shape" => shape, "label" => label, "fontcolor" => color }

    return name
  end

  def add_edge(from, to, from_arrow, open, label, color, close, to_arrow)

    label.lstrip.rstrip!

    from_name = label_to_name from
    to_name = label_to_name to

    return if @edges.has_key? from and @edges[from].has_key? to

    dputs "Adding edge for #{from_name} #{to_name}"

    if not @edges.has_key? from_name
      @edges[from_name] = {}
    end

    arrowtail = parse_arrow from_arrow
    arrowhead = parse_arrow to_arrow

    case open
    when /^\.+$/
      style = "dotted"
    when /^\-+$/
      style = "dashed"
    else
      style = "solid"
    end

    if color
      color = color.gsub /\|+/, ""
    else
      color = "black"
    end

    @edges[from_name][to_name] = { "style" => style, "label" => label, "arrowtail" => arrowtail, "arrowhead" => arrowhead, "fontcolor" => color }
  end

  def parse_arrow(arrow)
    case arrow
    when '<'
      arrow = "normal"
    when '>'
      arrow = "normal"
    when 'o'
      arrow = "dot"
    when 'x'
      arrow = "box"
    when '<>'
      arrow = "diamond"
    else
      arrow = "none"
    end

    return arrow
  end

  def label_to_name(label)
    name = label.gsub /\W+/, ""
    return name.downcase
  end

end

ulg = ULG.new
opt = Getopt::Std.getopts("f:o:s:dh")

def usage
  puts "Usage: ulg.rb -f FILE [-o OUTPUT] [-s FILE] [-d]"
  puts "  -f FILE    File to read"
  puts "  -o OUTPUT  Output format (png, dot, svg). Default png"
  puts "  -s FILE    Save to file"
  puts "  -d         Debug mode"
  puts "  -h         This help"
  exit
end

if opt["h"]
  usage
end

if opt["d"]
  ulg.debug
end

if opt["s"]
  ulg.destfile = opt["s"]
end

if opt["o"] and [ "png", "dot", "svg" ].include? opt["o"]
  ulg.output = opt["o"]
end

if opt["f"]
  ulg.draw opt["f"]
else
  puts "File missing"
  usage
end


