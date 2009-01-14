#!/usr/bin/env ruby
require 'echo_versionServant.rb'
require 'echo_versionMappingRegistry.rb'
require 'soap/rpc/soaplet'

class Echo_version_port_type
  NsSimpletypeRpc = "urn:example.com:simpletype-rpc"

  Methods = [
    [ XSD::QName.new(NsSimpletypeRpc, "echo_version"),
      "urn:example.com:simpletype-rpc",
      "echo_version",
      [ ["in", "version", [nil, "urn:example.com:simpletype-rpc-type", "version"]],
        ["retval", "version_struct", ["Version_struct", "urn:example.com:simpletype-rpc-type", "version_struct"]] ],
      { :request_style =>  :rpc, :request_use =>  :encoded,
        :response_style => :rpc, :response_use => :encoded,
        :faults => {} }
    ],
    [ XSD::QName.new(NsSimpletypeRpc, "echo_version_r"),
      "urn:example.com:simpletype-rpc",
      "echo_version_r",
      [ ["in", "version_struct", ["Version_struct", "urn:example.com:simpletype-rpc-type", "version_struct"]],
        ["retval", "version", [nil, "urn:example.com:simpletype-rpc-type", "version"]] ],
      { :request_style =>  :rpc, :request_use =>  :encoded,
        :response_style => :rpc, :response_use => :encoded,
        :faults => {} }
    ]
  ]
end

class Echo_version_port_typeServlet < ::SOAP::RPC::SOAPlet
  def initialize(router = nil)
    super(router)
    servant = Echo_version_port_type.new
    Echo_version_port_type::Methods.each do |definitions|
      opt = definitions.last
      if opt[:request_style] == :document
        @router.add_document_operation(servant, *definitions)
      else
        @router.add_rpc_operation(servant, *definitions)
      end
    end
    @router.mapping_registry = Echo_versionMappingRegistry::EncodedRegistry
    @router.literal_mapping_registry = Echo_versionMappingRegistry::LiteralRegistry
  end
end

if $0 == __FILE__
  require 'webrick'
  server = WEBrick::HTTPServer.new(
    :BindAddress => "0.0.0.0",
    :Port => 10080,
    :DocumentRoot => "."
  )
  server.mount("/", Echo_version_port_typeServlet.new)
  trap(:INT) do
    server.shutdown
  end
  server.start
end
