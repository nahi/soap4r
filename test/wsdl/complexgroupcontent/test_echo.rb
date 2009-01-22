require 'test/unit'
require 'wsdl/parser'
require 'wsdl/soap/wsdl2ruby'
require 'soap/rpc/standaloneServer'
require 'soap/wsdlDriver'
require File.join(File.dirname(File.expand_path(__FILE__)), '..', '..', 'testutil.rb')

#$DEBUG = true

module WSDL; module ComplexGroupContent

class TestEcho < Test::Unit::TestCase
  class Server < ::SOAP::RPC::StandaloneServer
    Namespace = 'urn:complexGroupContent'

    def on_init
      add_document_method(
        self,
        nil,
        'echo',
        XSD::QName.new(Namespace, 'echo'),
        XSD::QName.new(Namespace, 'echo')
      )
    end
  
    def echo(arg)
      arg
    end
  end

  DIR = File.dirname(File.expand_path(__FILE__))
  Port = 17171

  def setup
    setup_server
    setup_classdef
    @client = nil
  end

  def teardown
    teardown_server if @server
    unless $DEBUG
      File.unlink(pathname('complexGroupContent.rb'))
      File.unlink(pathname('complexGroupContentMappingRegistry.rb'))
    end
    @client.reset_stream if @client
  end

  def setup_server
    @server = Server.new('Test', Server::Namespace, 'localhost', Port)
    @server.level = Logger::Severity::ERROR
    @server_thread = TestUtil.start_server_thread(@server)
  end

  def setup_classdef
    gen = WSDL::SOAP::WSDL2Ruby.new
    gen.location = pathname("complexGroupContent.wsdl")
    gen.basedir = DIR
    gen.logger.level = Logger::FATAL
    gen.opt['module_path'] = self.class.to_s.sub(/::[^:]+$/, '')
    gen.opt['classdef'] = nil
    gen.opt['mapping_registry'] = nil
    gen.opt['force'] = true
    gen.run
    TestUtil.require(DIR, 'complexGroupContentMappingRegistry.rb', 'complexGroupContent.rb')
  end

  def teardown_server
    @server.shutdown
    @server_thread.kill
    @server_thread.join
  end

  def pathname(filename)
    File.join(DIR, filename)
  end

  def test_wsdl
    wsdl = File.join(DIR, 'complexGroupContent.wsdl')
    @client = ::SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver
    @client.endpoint_url = "http://localhost:#{Port}/"
    # We don't want to use the registry, because it masks the bug.
    # @client.literal_mapping_registry = ComplexGroupContentMappingRegistry::LiteralRegistry
    @client.wiredump_dev = STDOUT if $DEBUG
    params = {
      "item" => {
        "Name" => "jerith",
        "GCElem" => "foo",
        "GSElem" => "bar",
      }
    }
    resp = @client.echo(params)
    assert_instance_of(::SOAP::Mapping::Object, resp)
    assert_equal('jerith', resp.item.name)
    assert_equal('foo', resp.item.gCElem)
    assert_equal('bar', resp.item.gSElem)
  end

  def test_wsdl_with_registry
    wsdl = File.join(DIR, 'complexGroupContent.wsdl')
    @client = ::SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver
    @client.endpoint_url = "http://localhost:#{Port}/"
    @client.literal_mapping_registry = ComplexGroupContentMappingRegistry::LiteralRegistry
    @client.wiredump_dev = STDOUT if $DEBUG
    params = Echo.new
    params.item = Derived.new
    params.item.name = 'jerith'
    params.item.gCElem = 'foo'
    params.item.gSElem = 'bar'
    resp = @client.echo(params)
    assert_instance_of(Echo, resp)
    assert_equal('jerith', resp.item.name)
    assert_equal('foo', resp.item.gCElem)
    assert_equal('bar', resp.item.gSElem)
  end
end


end; end
