require 'xsd/qname'

# {urn:example.com:simpletype-rpc-type}version_struct
#   version - Version
#   msg - SOAP::SOAPString
class Version_struct
  attr_accessor :version
  attr_accessor :msg

  def initialize(version = nil, msg = nil)
    @version = version
    @msg = msg
    yield(self) if block_given?
  end
end

# {urn:example.com:simpletype-rpc-type}version
class Version < ::String
  C_16 = new("1.6")
  C_18 = new("1.8")
  C_19 = new("1.9")
end
