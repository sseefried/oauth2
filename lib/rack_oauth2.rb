# Copyright (C) 2007, 2008, 2009, 2010 Christian Neukirchen <purl.org/net/chneukirchen>
#
# Rack is freely distributable under the terms of an MIT-style license.
# See COPYING or http://www.opensource.org/licenses/mit-license.php.

# The Rack main module, serving as a namespace for all core Rack
# modules and classes.
#
# All modules meant for use in your application are <tt>autoload</tt>ed here,
# so it should be enough just to <tt>require rack.rb</tt> in your code.

module RackOauth2
  # The Rack protocol version number implemented.
  VERSION = [1,1]

  # Return the Rack protocol version as a dotted string.
  def self.version
    VERSION.join(".")
  end

  # Return the Rack release as a dotted string.
  def self.release
    "1.2"
  end

  autoload :Builder, "rack_oauth2/builder"
  autoload :Cascade, "rack_oauth2/cascade"
  autoload :Chunked, "rack_oauth2/chunked"
  autoload :CommonLogger, "rack_oauth2/commonlogger"
  autoload :ConditionalGet, "rack_oauth2/conditionalget"
  autoload :Config, "rack_oauth2/config"
  autoload :ContentLength, "rack_oauth2/content_length"
  autoload :ContentType, "rack_oauth2/content_type"
  autoload :ETag, "rack_oauth2/etag"
  autoload :File, "rack_oauth2/file"
  autoload :Deflater, "rack_oauth2/deflater"
  autoload :Directory, "rack_oauth2/directory"
  autoload :ForwardRequest, "rack_oauth2/recursive"
  autoload :Handler, "rack_oauth2/handler"
  autoload :Head, "rack_oauth2/head"
  autoload :Lint, "rack_oauth2/lint"
  autoload :Lock, "rack_oauth2/lock"
  autoload :Logger, "rack_oauth2/logger"
  autoload :MethodOverride, "rack_oauth2/methodoverride"
  autoload :Mime, "rack_oauth2/mime"
  autoload :NullLogger, "rack_oauth2/nulllogger"
  autoload :Recursive, "rack_oauth2/recursive"
  autoload :Reloader, "rack_oauth2/reloader"
  autoload :Runtime, "rack_oauth2/runtime"
  autoload :Sendfile, "rack_oauth2/sendfile"
  autoload :Server, "rack_oauth2/server"
  autoload :ShowExceptions, "rack_oauth2/showexceptions"
  autoload :ShowStatus, "rack_oauth2/showstatus"
  autoload :Static, "rack_oauth2/static"
  autoload :URLMap, "rack_oauth2/urlmap"
  autoload :Utils, "rack_oauth2/utils"

  autoload :MockRequest, "rack_oauth2/mock"
  autoload :MockResponse, "rack_oauth2/mock"

  autoload :Request, "rack_oauth2/request"
  autoload :Response, "rack_oauth2/response"

  module Auth
    autoload :Basic, "rack_oauth2/auth/basic"
    autoload :AbstractRequest, "rack_oauth2/auth/abstract/request"
    autoload :AbstractHandler, "rack_oauth2/auth/abstract/handler"
    module Digest
      autoload :MD5, "rack_oauth2/auth/digest/md5"
      autoload :Nonce, "rack_oauth2/auth/digest/nonce"
      autoload :Params, "rack_oauth2/auth/digest/params"
      autoload :Request, "rack_oauth2/auth/digest/request"
    end
  end

  module Session
    autoload :Cookie, "rack_oauth2/session/cookie"
    autoload :Pool, "rack_oauth2/session/pool"
    autoload :Memcache, "rack_oauth2/session/memcache"
  end
end
