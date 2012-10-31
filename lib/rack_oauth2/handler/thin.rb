require "thin"
require "rack_oauth2/content_length"
require "rack_oauth2/chunked"

module RackOauth2
  module Handler
    class Thin
      def self.run(app, options={})
        app = RackOauth2::Chunked.new(RackOauth2::ContentLength.new(app))
        server = ::Thin::Server.new(options[:Host] || '0.0.0.0',
                                    options[:Port] || 8080,
                                    app)
        yield server if block_given?
        server.start
      end
    end
  end
end
