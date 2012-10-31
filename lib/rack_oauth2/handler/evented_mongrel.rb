require 'swiftcore/evented_mongrel'

module RackOauth2
  module Handler
    class EventedMongrel < Handler::Mongrel
    end
  end
end
