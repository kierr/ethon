# frozen_string_literal: true
module Ethon
  class Multi

    # This module contains the logic and knowledge about the
    # available options on multi.
    module Options

      # Multi option types that use :int coercion via value_for.
      INT_TYPES = [:int, :bool].freeze
      # Multi option types that are callback functionpointers.
      CALLBACK_TYPES = [:socket_callback, :timer_callback, :notify_callback].freeze
      # Multi option types that are data pointers (passed through as-is).
      DATA_TYPES = [:cbdata].freeze

      Curl.multi_options(nil).each do |opt, props|
        method_name = "#{opt}="
        next if method_defined? method_name

        if INT_TYPES.include?(props[:type])
          define_method(method_name) do |value|
            Curl.set_option(opt, value_for(value, :int), handle, :multi)
          end
        elsif CALLBACK_TYPES.include?(props[:type])
          define_method(method_name) do |value|
            Curl.set_option(opt, value_for(value, :string), handle, :multi)
          end
        elsif DATA_TYPES.include?(props[:type])
          define_method(method_name) do |value|
            Curl.set_option(opt, value_for(value, :string), handle, :multi)
          end
        end
        # :deprecated options are skipped — set_option raises DeprecatedOption.
      end

      private

      # Return the value to set to multi handle. It is converted with the help
      # of bool_options, enum_options and int_options.
      #
      # @example Return casted the value.
      #   multi.value_for(:verbose)
      #
      # @return [ Object ] The casted value.
      def value_for(value, type, option = nil)
        return nil if value.nil?

        if type == :bool
          value ? 1 : 0
        elsif type == :int
          value.to_i
        elsif value.is_a?(String)
          Ethon::Easy::Util.escape_zero_byte(value)
        else
          value
        end
      end
    end
  end
end
