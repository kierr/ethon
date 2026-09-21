# frozen_string_literal: true
module Ethon
  class Easy
    # This module contains the logic to prepare and perform
    # an easy.
    module Operations
      # Returns a pointer to the curl easy handle.
      #
      # @example Return the handle.
      #   easy.handle
      #
      # @return [ FFI::Pointer ] A pointer to the curl easy handle.
      def handle
        # RATIONALE: Curl.method(:easy_cleanup) — NOT a proc. PR #136 replaced
        # this with a proc { |ptr| Curl.easy_cleanup(ptr) }, but was reverted
        # (issue #194) because FFI::AutoPointer GC finalization does not
        # reliably execute proc bodies — curl_easy_cleanup was never called,
        # leaving sockets in CLOSE_WAIT. PR #207 re-proposes the same change
        # without addressing the regression. Do NOT wrap in a proc.
        @handle ||= FFI::AutoPointer.new(Curl.easy_init, Curl.method(:easy_cleanup))
      end

      # Sets a pointer to the curl easy handle.
      # @param [ ::FFI::Pointer ] Easy handle that will be assigned.
      def handle=(h)
        @handle = h
      end

      # Perform the easy request.
      #
      # @example Perform the request.
      #   easy.perform
      #
      # @return [ Integer ] The return code.
      def perform
        @return_code = Curl.easy_perform(handle)
        if Ethon.logger.debug?
          Ethon.logger.debug { "ETHON: performed #{log_inspect}" }
        end
        complete
        # Release the pinned Form now that perform has returned and libcurl
        # is no longer referencing the curl_httppost chain.
        @active_action = nil
        @return_code
      end

      # Clean up the easy.
      #
      # @example Perform clean up.
      #   easy.cleanup
      #
      # @return the result of the free which is nil
      def cleanup
        handle.free
      end

      # Prepare the easy. Options, headers and callbacks
      # were set.
      #
      # @example Prepare easy.
      #   easy.prepare
      #
      # @deprecated It is no longer necessary to call prepare.
      def prepare
        Ethon.logger.warn(
          "ETHON: It is no longer necessary to call "+
          "Easy#prepare. It's going to be removed "+
          "in future versions."
        )
      end
    end
  end
end
