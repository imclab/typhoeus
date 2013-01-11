require 'rack/typhoeus/middleware/params_decoder/helper'

module Rack
  module Typhoeus
    module Middleware
      class ParamsDecoder
        include ParamsDecoder::Helper

        def initialize(app)
          @app = app
        end

        def call(env)
          req = Rack::Request.new(env)
          deep_decode(req.params).each_pair { |k, v| update_params req, k, v }
          @app.call(env)
        end

        private

        # Persist params change in environment. Extracted from:
        # https://github.com/rack/rack/blob/master/lib/rack/request.rb#L233
        def update_params(req, k, v)
          found = false
          if req.GET.has_key?(k)
            found = true
            req.GET[k] = v
          end
          if req.POST.has_key?(k)
            found = true
            req.POST[k] = v
          end
          unless found
            req.GET[k] = v
          end
        end
      end
    end
  end
end