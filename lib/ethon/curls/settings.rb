# frozen_string_literal: true
module Ethon
  module Curl
    callback :callback, [:pointer, :size_t, :size_t, :pointer], :size_t
    callback :socket_callback, [:pointer, :int, :poll_action, :pointer, :pointer], :multi_code
    callback :timer_callback, [:pointer, :long, :pointer], :multi_code
    callback :debug_callback, [:pointer, :debug_info_type, :pointer, :size_t, :pointer], :int
    callback :progress_callback, [:pointer, :long_long, :long_long, :long_long, :long_long], :int
    callback :notify_callback, [:pointer, :int, :pointer], :multi_code
    ffi_lib_flags :now, :global
    # Homebrew paths tried first (macOS ARM, then Intel); fall through to
    # system libcurl and Linux .so.4. Override entirely with ETHON_CURL_LIBS.
    ffi_lib ENV.fetch('ETHON_CURL_LIBS',
      '/opt/homebrew/opt/curl/lib/libcurl.dylib,' \
      '/usr/local/opt/curl/lib/libcurl.dylib,' \
      'libcurl,libcurl.so.4').split(',')
  end
end
