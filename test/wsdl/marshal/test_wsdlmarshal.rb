require 'test/unit'
require 'wsdl/parser'
require 'soap/mapping/wsdlencodedregistry'
require 'soap/marshal'
require 'wsdl/soap/wsdl2ruby'
require File.expand_path('../../testutil.rb', File.dirname(__FILE__))


class WSDLMarshaller
  def initialize(wsdlfile)
    wsdl = WSDL::Parser.new.parse(File.open(wsdlfile) { |f| f.read })
    types = wsdl.collect_complextypes
    @opt = {
      :decode_typemap => types,
      :generate_explicit_type => false,
      :pretty => true
    }
    @mapping_registry = ::SOAP::Mapping::WSDLEncodedRegistry.new(types)
    TestUtil.require(File.dirname(__FILE__), 'person_org')
  end

  def dump(obj, io = nil)
    ele = ::SOAP::Mapping.obj2soap(obj, @mapping_registry)
    ele.elename = XSD::QName.new(nil, ele.type.name.to_s)
    ::SOAP::Processor.marshal(::SOAP::SOAPEnvelope.new(nil, ::SOAP::SOAPBody.new(ele)), @opt, io)
  end

  def load(io)
    header, body = ::SOAP::Processor.unmarshal(io, @opt)
    ::SOAP::Mapping.soap2obj(body.root_node, @mapping_registry)
  end
end

class TestWSDLMarshal < Test::Unit::TestCase
  DIR = File.dirname(File.expand_path(__FILE__))

  def assert_person_equal(lhs, rhs)
    lhs.familyname == rhs.familyname and
      lhs.givenname == rhs.givenname and
      lhs.var1 == rhs.var1 and
      lhs.var2 == rhs.var2 and
      lhs.var3 == rhs.var3
  end

  def test_marshal
    marshaller = WSDLMarshaller.new(pathname('person.wsdl'))
    obj = Person.new("NAKAMURA", "Hiroshi", 1, 1.0,  "1")
    str = marshaller.dump(obj)
    puts str if $DEBUG
    obj2 = marshaller.load(str)
    assert_person_equal(obj, obj2)
    assert_equal(str, marshaller.dump(obj2))
  end

  def test_classdef
    gen = WSDL::SOAP::WSDL2Ruby.new
    gen.location = pathname("person.wsdl")
    gen.basedir = DIR
    gen.logger.level = Logger::FATAL
    gen.opt['classdef'] = nil
    gen.opt['force'] = true
    gen.run
    compare("person_org.rb", "Person.rb")
    File.unlink(pathname('Person.rb')) unless $DEBUG
  end

  def compare(expected, actual)
    TestUtil.filecompare(pathname(expected), pathname(actual))
  end

  def pathname(filename)
    File.join(DIR, filename)
  end
end
