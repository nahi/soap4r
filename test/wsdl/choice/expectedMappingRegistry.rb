require 'choice.rb'
require 'soap/mapping'

module WSDL; module Choice

module ChoiceMappingRegistry
  EncodedRegistry = ::SOAP::Mapping::EncodedRegistry.new
  LiteralRegistry = ::SOAP::Mapping::LiteralRegistry.new
  NsChoice = "urn:choice"

  EncodedRegistry.register(
    :class => WSDL::Choice::Andor,
    :schema_type => XSD::QName.new(NsChoice, "andor"),
    :schema_element => [
      ["a", ["SOAP::SOAPString", XSD::QName.new(nil, "A")]],
      [ :choice,
        ["b1", ["SOAP::SOAPString", XSD::QName.new(nil, "B1")]],
        [
          ["b2a", ["SOAP::SOAPString", XSD::QName.new(nil, "B2a")]],
          ["b2b", ["SOAP::SOAPString", XSD::QName.new(nil, "B2b")]]
        ],
        [ :choice,
          ["b3a", ["SOAP::SOAPString", XSD::QName.new(nil, "B3a")]],
          ["b3b", ["SOAP::SOAPString", XSD::QName.new(nil, "B3b")]]
        ]
      ],
      [
        ["c1", ["SOAP::SOAPString", XSD::QName.new(nil, "C1")]],
        ["c2", ["SOAP::SOAPString", XSD::QName.new(nil, "C2")]]
      ]
    ]
  )

  EncodedRegistry.register(
    :class => WSDL::Choice::EmptyArrayAtFirst,
    :schema_type => XSD::QName.new(NsChoice, "emptyArrayAtFirst"),
    :schema_element => [
      [ :choice,
        ["a", ["SOAP::SOAPString[]", XSD::QName.new(nil, "A")], [1, nil]],
        ["b1", ["SOAP::SOAPString", XSD::QName.new(nil, "B1")]],
        ["b2", ["SOAP::SOAPString", XSD::QName.new(nil, "B2")]]
      ]
    ]
  )

  LiteralRegistry.register(
    :class => WSDL::Choice::Andor,
    :schema_type => XSD::QName.new(NsChoice, "andor"),
    :schema_element => [
      ["a", ["SOAP::SOAPString", XSD::QName.new(nil, "A")]],
      [ :choice,
        ["b1", ["SOAP::SOAPString", XSD::QName.new(nil, "B1")]],
        [
          ["b2a", ["SOAP::SOAPString", XSD::QName.new(nil, "B2a")]],
          ["b2b", ["SOAP::SOAPString", XSD::QName.new(nil, "B2b")]]
        ],
        [ :choice,
          ["b3a", ["SOAP::SOAPString", XSD::QName.new(nil, "B3a")]],
          ["b3b", ["SOAP::SOAPString", XSD::QName.new(nil, "B3b")]]
        ]
      ],
      [
        ["c1", ["SOAP::SOAPString", XSD::QName.new(nil, "C1")]],
        ["c2", ["SOAP::SOAPString", XSD::QName.new(nil, "C2")]]
      ]
    ]
  )

  LiteralRegistry.register(
    :class => WSDL::Choice::EmptyArrayAtFirst,
    :schema_type => XSD::QName.new(NsChoice, "emptyArrayAtFirst"),
    :schema_element => [
      [ :choice,
        ["a", ["SOAP::SOAPString[]", XSD::QName.new(nil, "A")], [1, nil]],
        ["b1", ["SOAP::SOAPString", XSD::QName.new(nil, "B1")]],
        ["b2", ["SOAP::SOAPString", XSD::QName.new(nil, "B2")]]
      ]
    ]
  )

  LiteralRegistry.register(
    :class => WSDL::Choice::TerminalID,
    :schema_name => XSD::QName.new(NsChoice, "terminalID"),
    :schema_element => [ :choice,
      ["imei", ["SOAP::SOAPString", XSD::QName.new(nil, "imei")]],
      ["devId", ["SOAP::SOAPString", XSD::QName.new(nil, "devId")]]
    ]
  )

  LiteralRegistry.register(
    :class => WSDL::Choice::Echoele,
    :schema_name => XSD::QName.new(NsChoice, "echoele"),
    :schema_element => [
      ["terminalID", "WSDL::Choice::TerminalID", [0, 1]]
    ]
  )

  LiteralRegistry.register(
    :class => WSDL::Choice::Echo_response,
    :schema_name => XSD::QName.new(NsChoice, "echo_response"),
    :schema_element => [
      ["terminalID", "WSDL::Choice::TerminalID", [0, 1]]
    ]
  )

  LiteralRegistry.register(
    :class => WSDL::Choice::Echoele_complex,
    :schema_name => XSD::QName.new(NsChoice, "echoele_complex"),
    :schema_element => [
      ["data", ["WSDL::Choice::Andor", XSD::QName.new(nil, "data")]]
    ]
  )

  LiteralRegistry.register(
    :class => WSDL::Choice::Echo_complex_response,
    :schema_name => XSD::QName.new(NsChoice, "echo_complex_response"),
    :schema_element => [
      ["data", ["WSDL::Choice::Andor", XSD::QName.new(nil, "data")]]
    ]
  )

  LiteralRegistry.register(
    :class => WSDL::Choice::Echoele_complex_emptyArrayAtFirst,
    :schema_name => XSD::QName.new(NsChoice, "echoele_complex_emptyArrayAtFirst"),
    :schema_element => [
      ["data", ["WSDL::Choice::EmptyArrayAtFirst", XSD::QName.new(nil, "data")]]
    ]
  )
end

end; end
