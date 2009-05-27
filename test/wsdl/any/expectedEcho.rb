require 'xsd/qname'

module WSDL; module Any


# {urn:example.com:echo-type}foo.bar
#   before - SOAP::SOAPString
#   after - SOAP::SOAPString
class FooBar
  attr_accessor :before
  attr_reader :__xmlele_any
  attr_accessor :after

  def set_any(elements)
    @__xmlele_any = elements
  end

  def initialize(before = nil, after = nil)
    @before = before
    @__xmlele_any = nil
    @after = after
    yield(self) if block_given?
  end
end

# {urn:example.com:echo-type}type478
#   xmlattr_dialect - SOAP::SOAPAnyURI
class Type478
  AttrDialect = XSD::QName.new(nil, "dialect")

  def __xmlattr
    @__xmlattr ||= {}
  end

  def xmlattr_dialect
    __xmlattr[AttrDialect]
  end

  def xmlattr_dialect=(value)
    __xmlattr[AttrDialect] = value
  end

  def initialize
    @__xmlattr = {}
    yield(self) if block_given?
  end
end

# {urn:example.com:echo-type}setOutputAndCompleteRequest
#   taskId - SOAP::SOAPString
#   data - WSDL::Any::SetOutputAndCompleteRequest::C_Data
#   participantToken - SOAP::SOAPString
class SetOutputAndCompleteRequest

  # inner class for member: data
  # {}data
  class C_Data
    attr_reader :__xmlele_any

    def set_any(elements)
      @__xmlele_any = elements
    end

    def initialize
      @__xmlele_any = nil
      yield(self) if block_given?
    end
  end

  attr_accessor :taskId
  attr_accessor :data
  attr_accessor :participantToken

  def initialize(taskId = nil, data = nil, participantToken = nil)
    @taskId = taskId
    @data = data
    @participantToken = participantToken
    yield(self) if block_given?
  end
end


end; end
