require 'rack_oauth2/auth/abstract/request'
require 'rack_oauth2/auth/digest/params'
require 'rack_oauth2/auth/digest/nonce'

module RackOauth2
  module Auth
    module Digest
      class Request < Auth::AbstractRequest

        def method
          @env['rack.methodoverride.original_method'] || @env['REQUEST_METHOD']
        end

        def digest?
          :digest == scheme
        end

        def correct_uri?
          (@env['SCRIPT_NAME'].to_s + @env['PATH_INFO'].to_s) == uri
        end

        def nonce
          @nonce ||= Nonce.parse(params['nonce'])
        end

        def params
          @params ||= Params.parse(parts.last)
        end

        def method_missing(sym)
          if params.has_key? key = sym.to_s
            return params[key]
          end
          super
        end

      end
    end
  end
end
