# WSDL4R - XMLSchema pattern definition for WSDL.
# Copyright (C) 2000-2007  NAKAMURA, Hiroshi <nahi@ruby-lang.org>.

# This program is copyrighted free software by NAKAMURA, Hiroshi.  You can
# redistribute it and/or modify it under the same terms of Ruby's license;
# either the dual license version in 2003, or any later version.


require 'wsdl/info'


module WSDL
module XMLSchema


class Pattern < Info
  def initialize
    super
  end

  def parse_element(element)
    nil
  end

  def parse_attr(attr, value)
    case attr
    when ValueAttrName
      begin
        parent.pattern = /\A#{value.source}\z/n
      rescue RegexpError
        warn("cannot parse as a Ruby's Regexp source (ignored): #{value.source}")
      end
      value.source
    end
  end
end


end
end
