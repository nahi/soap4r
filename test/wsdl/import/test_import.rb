require 'test/unit'
require 'wsdl/parser'


module WSDL


class TestImport < Test::Unit::TestCase
  def setup
    file = File.expand_path('import.wsdl', File.dirname(__FILE__))
    @xml = File.open(file) { |f| f.read }
  end

  def test_import
    wsdl = WSDL::Parser.new.parse(@xml)
    assert_equal('dummy', wsdl.collect_elements[0].name.name)
  end

  def test_file_import
    path = File.expand_path('import.xsd', File.dirname(__FILE__))
    xml = @xml.sub(/import.xsd/, "file://#{path}")
    wsdl = WSDL::Parser.new.parse(xml)
    assert_equal('dummy', wsdl.collect_elements[0].name.name)
  end

  def test_file_escaped_import # %-encode in file URI.
    path = File.expand_path('import%2exsd', File.dirname(__FILE__))
    xml = @xml.sub(/import.xsd/, "file://#{path}")
    wsdl = WSDL::Parser.new.parse(xml)
    assert_equal('dummy', wsdl.collect_elements[0].name.name)
  end
end


end
