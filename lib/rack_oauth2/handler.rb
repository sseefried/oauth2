module RackOauth2
  # *Handlers* connect web servers with Rack.
  #
  # Rack includes Handlers for Mongrel, WEBrick, FastCGI, CGI, SCGI
  # and LiteSpeed.
  #
  # Handlers usually are activated by calling <tt>MyHandler.run(myapp)</tt>.
  # A second optional hash can be passed to include server-specific
  # configuration.
  module Handler
    def self.get(server)
      return unless server
      server = server.to_s

      if klass = @handlers[server]
        obj = Object
        klass.split("::").each { |x| obj = obj.const_get(x) }
        obj
      else
        try_require('rack_oauth2/handler', server)
        const_get(server)
      end
    end

    def self.default(options = {})
      # Guess.
      if ENV.include?("PHP_FCGI_CHILDREN")
        # We already speak FastCGI
        options.delete :File
        options.delete :Port

        RackOauth2::Handler::FastCGI
      elsif ENV.include?("REQUEST_METHOD")
        RackOauth2::Handler::CGI
      else
        begin
          RackOauth2::Handler::Mongrel
        rescue LoadError => e
          RackOauth2::Handler::WEBrick
        end
      end
    end

    # Transforms server-name constants to their canonical form as filenames,
    # then tries to require them but silences the LoadError if not found
    #
    # Naming convention:
    #
    #   Foo # => 'foo'
    #   FooBar # => 'foo_bar.rb'
    #   FooBAR # => 'foobar.rb'
    #   FOObar # => 'foobar.rb'
    #   FOOBAR # => 'foobar.rb'
    #   FooBarBaz # => 'foo_bar_baz.rb'
    def self.try_require(prefix, const_name)
      file = const_name.gsub(/^[A-Z]+/) { |pre| pre.downcase }.
        gsub(/[A-Z]+[^A-Z]/, '_\&').downcase

      require(::File.join(prefix, file))
    rescue LoadError
    end

    def self.register(server, klass)
      @handlers ||= {}
      @handlers[server] = klass
    end

    autoload :CGI, "rack_oauth2/handler/cgi"
    autoload :FastCGI, "rack_oauth2/handler/fastcgi"
    autoload :Mongrel, "rack_oauth2/handler/mongrel"
    autoload :EventedMongrel, "rack_oauth2/handler/evented_mongrel"
    autoload :SwiftipliedMongrel, "rack_oauth2/handler/swiftiplied_mongrel"
    autoload :WEBrick, "rack_oauth2/handler/webrick"
    autoload :LSWS, "rack_oauth2/handler/lsws"
    autoload :SCGI, "rack_oauth2/handler/scgi"
    autoload :Thin, "rack_oauth2/handler/thin"

    register 'cgi', 'RackOauth2::Handler::CGI'
    register 'fastcgi', 'RackOauth2::Handler::FastCGI'
    register 'mongrel', 'RackOauth2::Handler::Mongrel'
    register 'emongrel', 'RackOauth2::Handler::EventedMongrel'
    register 'smongrel', 'RackOauth2::Handler::SwiftipliedMongrel'
    register 'webrick', 'RackOauth2::Handler::WEBrick'
    register 'lsws', 'RackOauth2::Handler::LSWS'
    register 'scgi', 'RackOauth2::Handler::SCGI'
    register 'thin', 'RackOauth2::Handler::Thin'
  end
end
