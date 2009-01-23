require 'test/unit'
require 'soap/rpc/httpserver'
require 'soap/wsdlDriver'
require File.expand_path('../../testutil.rb', File.dirname(__FILE__))


module SOAP


class TestWSDLDriverProperty < Test::Unit::TestCase
  DIR = File.dirname(File.expand_path(__FILE__))
  PROPERTY_FILE = File.join(DIR, 'soap', 'property')
  COOKIE_FILE = File.join(DIR, 'cookie.dat')
  Port = 1717
  URL = "http://localhost:#{Port}/"

  def setup
    if File.exist?(COOKIE_FILE)
      File.unlink(COOKIE_FILE)
    end
    if File.exist?(PROPERTY_FILE)
      File.unlink(PROPERTY_FILE)
    end
    setup_server
  end

  def teardown
    teardown_server if @server
    if File.exist?(COOKIE_FILE)
      File.unlink(COOKIE_FILE)
    end
    if File.exist?(PROPERTY_FILE)
      File.unlink(PROPERTY_FILE)
    end
  end

  def setup_server
    @server = ::SOAP::RPC::HTTPServer.new(
      :BindAddress => "localhost",
      :Port => Port,
      :AccessLog => [],
      :SOAPDefaultNamespace => 'urn:test',
      :WSDLDocumentDirectory => DIR
    )
    @server.level = Logger::Severity::ERROR
    @server_thread = TestUtil.start_server_thread(@server)
    # set cookies and redirect to WSDL URL
    @server.server.mount_proc('/redirect') do |req, res|
      res['Set-Cookie'] = "foo=bar; expires=#{Time.mktime(2030, 12, 31).httpdate}"
      res.set_redirect(WEBrick::HTTPStatus::Found, URL + "wsdl/calc.wsdl")
    end
  end

  def teardown_server
    @server.shutdown
    @server_thread.join
  end

  def test_soap_property
    begin
      $: << DIR
      File.open(PROPERTY_FILE, 'w') do |f|
        f << "client.protocol.http.cookie_store_file = #{COOKIE_FILE}"
      end
      wsdl = URL + "redirect"
      assert(!File.exist?(COOKIE_FILE))
      driver = ::SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver
      assert(File.exist?(COOKIE_FILE))
    ensure
      $:.delete(DIR)
    end
  end
end


end
