require 'test/unit'
require 'wsdl/parser'


module WSDL


class TestImport < Test::Unit::TestCase
  DIR = File.dirname(__FILE__)

  def setup
    file = File.expand_path('import.wsdl', DIR)
    @xml = File.open(file) { |f| f.read }
    @parser = WSDL::Parser.new(:location => URI.parse("file://#{file}"))
  end

  def test_import
    wsdl = @parser.parse(@xml)
    assert_equal('dummy', wsdl.collect_elements[0].name.name)
  end

  def test_file_import
    path = File.expand_path('import.xsd', DIR)
    xml = @xml.sub(/import.xsd/, "file://#{path}")
    wsdl = @parser.parse(xml)
    assert_equal('dummy', wsdl.collect_elements[0].name.name)
  end

  def test_file_escaped_import # %-encode in file URI.
    path = File.expand_path('import%2exsd', DIR)
    xml = @xml.sub(/import.xsd/, "file://#{path}")
    wsdl = @parser.parse(xml)
    assert_equal('dummy', wsdl.collect_elements[0].name.name)
  end
end


end
