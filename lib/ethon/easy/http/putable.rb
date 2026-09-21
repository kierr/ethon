# frozen_string_literal: true
module Ethon
  class Easy
    module Http

      # This module contains logic about setting up a PUT body.
      module Putable
        # Set things up when form is provided.
        # Deals with multipart forms.
        #
        # @example Setup.
        #   put.set_form(easy)
        #
        # @param [ Easy ] easy The easy to setup.
        def set_form(easy)
          easy.url ||= url
          form.params_encoding = params_encoding
          if form.multipart?
            # RATIONALE: multipart PUT (typhoeus/ethon#245) — upload/read_callback
            # cannot encode multipart boundaries. Use httppost (which sets
            # CURLOPT_HTTPPOST) and override the method back to PUT via
            # customrequest, mirroring Postable's multipart branch.
            setup_multipart(easy, form)
            easy.customrequest = 'PUT'
          else
            easy.upload = true
            form.escape = true
            body = form.to_s
            easy.infilesize = body.bytesize
            easy.set_read_callback(body)
          end
        end
      end
    end
  end
end
