# :stopdoc:

# Stolen from ruby core's uri/common.rb, with modifications to support 1.8.x
#
# https://github.com/ruby/ruby/blob/trunk/lib/uri/common.rb
#
#

module URI
  # Generate URL-encoded form data from given +enum+.
  #
  # This generates application/x-www-form-urlencoded data defined in HTML5
  # from given an Enumerable object.
  #
  # This internally uses URI.encode_www_form_component(str).
  #
  # This method doesn't convert the encoding of given items, so convert them
  # before call this method if you want to send data as other than original
  # encoding or mixed encoding data. (Strings which are encoded in an HTML5
  # ASCII incompatible encoding are converted to UTF-8.)
  #
  # This method doesn't handle files.  When you send a file, use
  # multipart/form-data.
  #
  # This is an implementation of
  # http://www.w3.org/TR/html5/forms.html#url-encoded-form-data
  #
  #    URI.encode_www_form([["q", "ruby"], ["lang", "en"]])
  #    #=> "q=ruby&lang=en"
  #    URI.encode_www_form("q" => "ruby", "lang" => "en")
  #    #=> "q=ruby&lang=en"
  #    URI.encode_www_form("q" => ["ruby", "perl"], "lang" => "en")
  #    #=> "q=ruby&q=perl&lang=en"
  #    URI.encode_www_form([["q", "ruby"], ["q", "perl"], ["lang", "en"]])
  #    #=> "q=ruby&q=perl&lang=en"
  #
  # See URI.encode_www_form_component, URI.decode_www_form
  def self.encode_www_form(enum)
    enum.map do |k,v|
      if v.nil?
        encode_www_form_component(k)
      elsif v.respond_to?(:to_ary)
        v.to_ary.map do |w|
          str = encode_www_form_component(k)
          unless w.nil?
            str << '='
            str << encode_www_form_component(w)
          end
        end.join('&')
      else
        str = encode_www_form_component(k)
        str << '='
        str << encode_www_form_component(v)
      end
    end.join('&')
  end
end
