module RackOauth2
  # RackOauth2::Builder implements a small DSL to iteratively construct Rack
  # applications.
  #
  # Example:
  #
  #  app = RackOauth2::Builder.new {
  #    use RackOauth2::CommonLogger
  #    use RackOauth2::ShowExceptions
  #    map "/lobster" do
  #      use RackOauth2::Lint
  #      run RackOauth2::Lobster.new
  #    end
  #  }
  #
  # Or
  #
  #  app = RackOauth2::Builder.app do
  #    use RackOauth2::CommonLogger
  #    lambda { |env| [200, {'Content-Type' => 'text/plain'}, 'OK'] }
  #  end
  #
  # +use+ adds a middleware to the stack, +run+ dispatches to an application.
  # You can use +map+ to construct a RackOauth2::URLMap in a convenient way.

  class Builder
    def self.parse_file(config, opts = Server::Options.new)
      options = {}
      if config =~ /\.ru$/
        cfgfile = ::File.read(config)
        if cfgfile[/^#\\(.*)/] && opts
          options = opts.parse! $1.split(/\s+/)
        end
        cfgfile.sub!(/^__END__\n.*/, '')
        app = eval "RackOauth2::Builder.new {( " + cfgfile + "\n )}.to_app",
          TOPLEVEL_BINDING, config
      else
        require config
        app = Object.const_get(::File.basename(config, '.rb').capitalize)
      end
      return app, options
    end

    def initialize(&block)
      @ins = []
      instance_eval(&block) if block_given?
    end

    def self.app(&block)
      self.new(&block).to_app
    end

    def use(middleware, *args, &block)
      @ins << lambda { |app| middleware.new(app, *args, &block) }
    end

    def run(app)
      @ins << app #lambda { |nothing| app }
    end

    def map(path, &block)
      if @ins.last.kind_of? Hash
        @ins.last[path] = self.class.new(&block).to_app
      else
        @ins << {}
        map(path, &block)
      end
    end

    def to_app
      @ins[-1] = RackOauth2::URLMap.new(@ins.last)  if Hash === @ins.last
      inner_app = @ins.last
      @ins[0...-1].reverse.inject(inner_app) { |a, e| e.call(a) }
    end

    def call(env)
      to_app.call(env)
    end
  end
end
