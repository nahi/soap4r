require 'xsd/qname'

module WSDL; module Choice


# {urn:choice}andor
#   a - SOAP::SOAPString
#   (choice)
#     b1 - SOAP::SOAPString
#     b2a - SOAP::SOAPString
#     b2b - SOAP::SOAPString
#   (choice)
#     b3a - SOAP::SOAPString
#     b3b - SOAP::SOAPString
#     c1 - SOAP::SOAPString
#     c2 - SOAP::SOAPString
class Andor
  attr_accessor :a
  attr_accessor :b1
  attr_accessor :b2a
  attr_accessor :b2b
  attr_accessor :b3a
  attr_accessor :b3b
  attr_accessor :c1
  attr_accessor :c2

  def initialize(a = nil, b1 = nil, b2a = nil, b2b = nil, b3a = nil, b3b = nil, c1 = nil, c2 = nil)
    @a = a
    @b1 = b1
    @b2a = b2a
    @b2b = b2b
    @b3a = b3a
    @b3b = b3b
    @c1 = c1
    @c2 = c2
  end
end

# {urn:choice}emptyArrayAtFirst
#   (choice)
#     a - SOAP::SOAPString[]
#     b1 - SOAP::SOAPString
#     b2 - SOAP::SOAPString
class EmptyArrayAtFirst
  attr_accessor :a
  attr_accessor :b1
  attr_accessor :b2

  def initialize(a = [], b1 = nil, b2 = nil)
    @a = a
    @b1 = b1
    @b2 = b2
  end
end

# {urn:choice}terminalID
#   imei - SOAP::SOAPString
#   devId - SOAP::SOAPString
class TerminalID
  attr_accessor :imei
  attr_accessor :devId

  def initialize(imei = nil, devId = nil)
    @imei = imei
    @devId = devId
  end
end

# {urn:choice}echoele
#   terminalID - WSDL::Choice::TerminalID?
class Echoele
  attr_accessor :terminalID

  def initialize(terminalID = nil)
    @terminalID = terminalID
  end
end

# {urn:choice}echo_response
#   terminalID - WSDL::Choice::TerminalID?
class Echo_response
  attr_accessor :terminalID

  def initialize(terminalID = nil)
    @terminalID = terminalID
  end
end

# {urn:choice}echoele_complex
#   data - WSDL::Choice::Andor
class Echoele_complex
  attr_accessor :data

  def initialize(data = nil)
    @data = data
  end
end

# {urn:choice}echo_complex_response
#   data - WSDL::Choice::Andor
class Echo_complex_response
  attr_accessor :data

  def initialize(data = nil)
    @data = data
  end
end

# {urn:choice}echoele_complex_emptyArrayAtFirst
#   data - WSDL::Choice::EmptyArrayAtFirst
class Echoele_complex_emptyArrayAtFirst
  attr_accessor :data

  def initialize(data = nil)
    @data = data
  end
end


end; end
