require 'test/unit'
require 'soap/rpc/driver'
require File.join(File.dirname(File.expand_path(__FILE__)), '..', '..', 'testutil.rb')
TestUtil.require(File.dirname(__FILE__), 'hw_s.rb')


module SOAP
module HelloWorld


class TestHelloWorld < Test::Unit::TestCase
  Port = 17171

  def setup
    @server = HelloWorldServer.new('hws', 'urn:hws', 'localhost', Port)
    @server.level = Logger::Severity::ERROR
    @t = Thread.new {
      Thread.current.abort_on_exception = true
      @server.start
    }
    @endpoint = "http://localhost:#{Port}/"
    @client = SOAP::RPC::Driver.new(@endpoint, 'urn:hws')
    @client.wiredump_dev = STDERR if $DEBUG
    @client.add_method("hello_world", "from")
  end

  def teardown
    @server.shutdown if @server
    if @t
      @t.kill
      @t.join
    end
    @client.reset_stream if @client
  end

  def test_hello_world
    assert_equal("Hello World, from NaHi", @client.hello_world("NaHi"))
    assert_equal("Hello World, from <&>", @client.hello_world("<&>"))
  end
end


end
end
