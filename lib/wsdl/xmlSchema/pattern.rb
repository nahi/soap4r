# WSDL4R - XMLSchema pattern definition for WSDL.
# Copyright (C) 2005-2009  NAKAMURA, Hiroshi <nahi@ruby-lang.org>.

# This program is copyrighted free software by NAKAMURA, Hiroshi.  You can
# redistribute it and/or modify it under the same terms of Ruby's license;
# either the dual license version in 2003, or any later version.


require 'wsdl/info'
require 'strscan'


module WSDL
module XMLSchema


class Pattern < Info

  # This class and pattern translation code is copyrighted by anonymous user at
  # ticket #475.  Thanks!
  class CharclassTranslatorToken
    def initialize(scanner, inside = false)
      @container = []
      @scanner = scanner
      @inside = inside
    end

    def to_a
      @container
    end

    def translate
      while !@scanner.eos?
        flat = @scanner.scan(/[a-zA-Z0-9]-[a-zA-Z0-9]/)
        unless flat.nil?
          @container << Range.new(*flat.scan(/[^-]+/)).to_a
          next
        end
        c = @scanner.getch()
        case c
        when "["
          c = CharclassTranslatorToken.new(@scanner,true)
          @container << c
          c.translate
        when "]"  
          break
        else
          @container << c
        end    
      end
      if @inside 
        i = 0
        while i < @container.length
          if @container[i].class != String and @container[i+1] == "-" and
              @container[i+2].class != String 
            @container[i] = @container[i].to_a - @container[i+2].to_a
            @container.delete_at(i+1) 
            @container.delete_at(i+1)
          else
            i += 1
          end  
        end  
        @container.flatten!
      end  
    end

    def to_s
      @container.inject('') { |s,i|
        i.class == String ? s << i : s << "[" + i.to_a.to_s + "]"
      }
    end  
  end

  def initialize
    super
  end

  def parse_element(element)
    nil
  end

  def parse_attr(attr, value)
    case attr
    when ValueAttrName
      s = value.source
      s.gsub!("\\i",'[_:A-Za-z]')
      s.gsub!("\\I",'[^_:A-Za-z]')
      s.gsub!("\\c",'[-._:A-Za-z0-9]')
      s.gsub!("\\C",'[^-._:A-Za-z0-9]')
      ss = CharclassTranslatorToken.new(StringScanner.new(s))
      ss.translate
      begin
        parent.pattern = /\A#{ss.to_s}\z/n
      rescue RegexpError
        warn("cannot parse as a Ruby's Regexp source (ignored): #{value.source}")
      end
      value.source
    end
  end
end


end
end
