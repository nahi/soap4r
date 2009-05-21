require 'test/unit'
require 'soap/rpc/driver'
require 'soap/rpc/standaloneServer'
require 'soap/attachment'
require File.expand_path('../../testutil.rb', File.dirname(__FILE__))


module SOAP
module SWA


class TestFile < Test::Unit::TestCase
  Port = 17171
  THIS_FILE = File.expand_path(__FILE__)
  TMP_FILE = File.expand_path('out.txt', File.dirname(__FILE__))

  class SwAService
    def get_file
      return {
     	'name' => $0,
	'file' => SOAP::Attachment.new(File.open(THIS_FILE)) # closed when GCed.
      }
    end
  
    def put_file(name, file)
      io = StringIO.new
      file.write(io)
      file.save(TMP_FILE)
      if io.string != File.read(TMP_FILE)
        raise
      end
      if io.string != file.to_s
        raise
      end
      "File '#{name}' was received ok."
    end
  end

  def setup
    @server = SOAP::RPC::StandaloneServer.new('SwAServer',
      'http://www.acmetron.com/soap', 'localhost', Port)
    @server.add_servant(SwAService.new)
    @server.level = Logger::Severity::ERROR
    @t = Thread.new {
      @server.start
    }
    @endpoint = "http://localhost:#{Port}/"
    @client = SOAP::RPC::Driver.new(@endpoint, 'http://www.acmetron.com/soap')
    @client.add_method('get_file')
    @client.add_method('put_file', 'name', 'file')
    @client.wiredump_dev = STDERR if $DEBUG
  end

  def teardown
    @server.shutdown if @server
    if @t
      @t.kill
      @t.join
    end
    @client.reset_stream if @client
    TestUtil.safe_unlink(TMP_FILE)
  end

  def test_get_file
    assert_equal(
      File.open(THIS_FILE) { |f| f.read },
      @client.get_file['file'].content
    )
  end

  def test_put_file
    assert_equal(
      "File 'foo' was received ok.",
      @client.put_file('foo',
	SOAP::Attachment.new(File.open(THIS_FILE)))
    )
    assert_equal(
      "File 'bar' was received ok.",
      @client.put_file('bar',
	SOAP::Attachment.new(File.open(THIS_FILE) { |f| f.read }))
    )
  end
end


end
end
