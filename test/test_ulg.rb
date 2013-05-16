require 'test/unit'
require 'ulg'

class ULGTest < Test::Unit::TestCase

  def test_all_the_things

    a_nodes = [ "anode", "a node", "   a node ", "  a node  " ]
    b_nodes = [ "bnode", "b node", "   b node ", "  b node  " ]
    edge_labels = [ "none", "edge", "ed ge", "   edge ", "  ed ge   " ]

    colours = [ "red", "none" ]

    shapes = {
      "oval"    => "()",
      "none"    => ""
    }

    lines = {
      "dashed"  => "-",
      "solid"   => "="
    }

    arrows = {
      "normal"  => ">",
      "none"    => ""
    }

    test_data = {}
    test_case = 0

    puts ULG.new.arrow_regex
    puts "------------------------------"

    a_nodes.each do |anode|
      shapes.keys.each do |a_shape_name|
        colours.each do |a_fontcolor|
          lines.keys.each do |line_name|
            edge_labels.each do |edge_label|
              b_nodes.each do |bnode|
                shapes.keys.each do |b_shape_name|
                  colours.each do |b_fontcolor|
 
                    test_data[test_case] = {
                      'nodes' => { 
                        'anode' => { 'attr' => {} },
                        'bnode' => { 'attr' => {} }
                      },
                      'edge' => { 'attr' => {} }
                    }

                    line = []
                    line << shapes[a_shape_name][0] if a_shape_name != "none"
                    line << anode
                    line << "|"+a_fontcolor if a_fontcolor != "none"
                    line << shapes[a_shape_name][1] if a_shape_name != "none"
                    line << " "
                    line << lines[line_name]
                    line << edge_label if edge_label != "none"
                    line << lines[line_name]
                    line << ">"
                    line << " "
                    line << shapes[b_shape_name][0] if b_shape_name != "none"
                    line << bnode
                    line << "|"+b_fontcolor if b_fontcolor != "none"
                    line << shapes[b_shape_name][1] if b_shape_name != "none"

                    test_data[test_case]['line'] = line.join

                    test_data[test_case]['nodes']['anode']['attr']['label'] = anode.rstrip.lstrip
                    test_data[test_case]['nodes']['bnode']['attr']['label'] = bnode.rstrip.lstrip

                    if a_shape_name == "none"
                      test_data[test_case]['nodes']['anode']['attr']['shape'] = "box"
                    else
                      test_data[test_case]['nodes']['anode']['attr']['shape'] = a_shape_name
                    end

                    if b_shape_name == "none"
                      test_data[test_case]['nodes']['bnode']['attr']['shape'] = "box"
                    else
                      test_data[test_case]['nodes']['bnode']['attr']['shape'] = b_shape_name
                    end

                    if a_fontcolor == "none"
                      test_data[test_case]['nodes']['anode']['attr']['fontcolor'] = "black"
                    else
                      test_data[test_case]['nodes']['anode']['attr']['fontcolor'] = a_fontcolor
                    end

                    if b_fontcolor == "none"
                      test_data[test_case]['nodes']['bnode']['attr']['fontcolor'] = "black"
                    else
                      test_data[test_case]['nodes']['bnode']['attr']['fontcolor'] = b_fontcolor
                    end

                    test_data[test_case]['edge']['attr']['style'] = line_name
                    test_data[test_case]['edge']['attr']['label'] = edge_label.rstrip.lstrip if edge_label != "none"

                    test_case += 1

                  end
                end
              end
            end
          end
        end
      end
    end

    test_data.keys.each do |test_case|

      line = test_data[test_case]['line']
      puts line

      ulg = ULG.new
      ulg.parse_line line

      test_data[test_case]['nodes'].keys.each do |node_name|
        test_data[test_case]['nodes'][node_name]['attr'].keys.each do |attr_name|
          expected_value = test_data[test_case]['nodes'][node_name]['attr'][attr_name]
          value = ulg.nodes[node_name]['attr'][attr_name]
          assert_equal expected_value, value
        end
      end

      test_data[test_case]['edge']['attr'].keys.each do |attr_name|
        expected_value = test_data[test_case]['edge']['attr'][attr_name]
        value = ulg.edges['anode']['bnode']['attr'][attr_name]
        assert_equal expected_value, value
      end

    end

  end

end
