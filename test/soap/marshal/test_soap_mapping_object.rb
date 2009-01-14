require 'test/unit'
require 'soap/marshal'


module SOAP
module Marshal


class TestSOAPMappingObject < Test::Unit::TestCase
  def test_object
    org = SOAP::Mapping::Object.new
    SOAP::Mapping.protect_mapping do
      org[:foo] = 1
    end
    obj = convert(org)
    assert_equal(org[:foo], obj[:foo])
  end

  def convert(obj)
    SOAP::Marshal.unmarshal(SOAP::Marshal.marshal(obj))
  end
end


end
end
