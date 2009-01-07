require 'test/unit'
require 'soap/marshal'


module SOAP

# test for #455: Adding attributes to NilClass wrecks havoc
class TestNilAttr < Test::Unit::TestCase
  def test_nil_attr
    str = File.read(File.expand_path('nil_attr.xml', File.dirname(__FILE__)))
    env = SOAP::Processor.unmarshal(str)
    result = env.body['UpdateAdKeywordState']
    assert_equal([], nil.instance_variables)
    obj = SOAP::Mapping.soap2obj(result)
    assert_equal('off', obj.ad_keyword.ad_keyword_state)
    # in 1.5.8, nil's instance_variables is poisoned when a defined xsi:type in
    # request exists as a class of Ruby (such as 'Struct') but the class cannot
    # be allocated (such as ::Struct).
    assert_equal([], nil.instance_variables)
  end
end


end
