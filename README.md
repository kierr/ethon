# Ethon — kierr fork

> **Upstream:** [typhoeus/ethon](https://github.com/typhoeus/ethon)
>
> This fork tracks upstream and rebases regularly. It is maintained for production use.

## Additions

This fork extends upstream ethon with features needed for high-throughput production HTTP workloads:

- **Used by [kierr/typhoeus](https://github.com/kierr/typhoeus)** — the companion fork that layers parallel-request semantics, multi handle pooling, and transfer metrics on top of Ethon's Easy/Multi interfaces.

- **Configurable FFI library** — Set `ETHON_CURL_LIBS` to point to a custom libcurl build (e.g., curl-impersonate). Defaults to Homebrew libcurl, then system libcurl.
- **HTTP/2 `max_concurrent_streams`** — New `CURLMOPT_MAX_CONCURRENT_STREAMS` multi option for controlling HTTP/2 multiplexing depth.
- **Corrected enum offsets** — Fixed `CURLINFO` and `CURLOPT` enum values and `off_t` base type that diverged from current libcurl headers.
- **CURLMOPT modernization** — Added modern multi options (`CURLMOPT_MAX_HOST_CONNECTIONS`, `CURLMOPT_MAX_TOTAL_CONNECTIONS`, `CURLMOPT_MAXCONNECTS`, etc.) with version gating.
- **Multipart PUT** — `Putable` module detects multipart form data and uses `httppost` + `customrequest='PUT'` instead of upload/read_callback ([upstream PR #245](https://github.com/typhoeus/ethon/pull/245)).
- **Pinned form actions during perform** — Pins multipart Form actions via `@active_action` during `Easy#perform` to prevent GC use-after-free ([upstream PR #272](https://github.com/typhoeus/ethon/pull/272)).
- **FFI::AutoPointer GC safety** — Retained `Curl.method(:easy_cleanup)` as a direct method reference (NOT a proc). Wrapping in a proc causes CLOSE_WAIT socket leaks ([issue #194](https://github.com/typhoeus/ethon/issues/194), [PR #136](https://github.com/typhoeus/ethon/pull/136) regression).
- **Header callback abort** — Header write callback now respects abort, matching body callback behavior.
- **Replaced pending/skipped tests** — All previously skipped specs now run.
- **Stale URL fixes** — Updated deprecated curl documentation URLs ([upstream PR #237](https://github.com/typhoeus/ethon/pull/237)).
- **Sinatra ~> 4.0 pin** — Pinned test server dependency for Rack 3 compatibility.

## Installation

This fork is not published to Rubygems. Install from GitHub:

```ruby
gem "ethon", github: "kierr/ethon"
```

**Ruby compatibility:** Tested with Ruby 3.2+. Requires libcurl 7.62.0+ (recommended: latest curl).

---


#  Ethon

In Greek mythology, Ethon, the son of Typhoeus and Echidna, is a gigantic eagle. So much for the history.
In the modern world, Ethon is a very basic libcurl wrapper using ffi.

* [Documentation](http://rubydoc.info/github/typhoeus/ethon/frames/Ethon)
* [Website](http://typhoeus.github.com/)
* [Mailing list](http://groups.google.com/group/typhoeus)

## Installation

With bundler:

    gem "ethon"

With rubygems:

    gem install ethon

## Usage

Making the first request is simple:

```ruby
easy = Ethon::Easy.new(url: "www.example.com")
easy.perform
#=> :ok
```

You have access to various options, such as following redirects:

```ruby
easy = Ethon::Easy.new(url: "www.example.com", followlocation: true)
easy.perform
#=> :ok
```

Once you're done you can inspect the response code and body:

```ruby
easy = Ethon::Easy.new(url: "www.example.com", followlocation: true)
easy.perform
easy.response_code
#=> 200
easy.response_body
#=> "<!doctype html><html ..."
```

## Http

In order to make life easier, there are some helpers for making HTTP requests:

```ruby
easy = Ethon::Easy.new
easy.http_request("www.example.com", :get, { params: {a: 1} })
easy.perform
#=> :ok
```

```ruby
easy = Ethon::Easy.new
easy.http_request("www.example.com", :post, { params: { a: 1 }, body: { b: 2 } })
easy.perform
#=> :ok
```

This is really handy when making requests since you don't have to care about setting
everything up correctly.

## Http2
Standard http2 servers require the client to connect once and create a session (multi) and then add simple requests to the multi handler.
The `perform` method then takes all the requests in the multi handler and sends them to the server.

See the following example
```ruby
multi = Ethon::Multi.new
easy = Ethon::Easy.new

easy.http_request("www.example.com/get", :get, { http_version: :httpv2_0 })

# Sending a request with http version 2 will send an Upgrade header to the server, which many older servers will not support
# See below for more info: https://everything.curl.dev/http/http2
# If this is a problem, send the below:
easy.http_request("www.example.com/get", :get, { http_version: :httpv2_prior_knowledge })

# To set the server to use http2 with https and http1 with http, send the following:
easy.http_request("www.example.com/get", :get, { http_version: :httpv2_tls })

multi.add(easy)
multi.perform
```

##  LICENSE

(The MIT License)

Copyright © 2012-2016 [Hans Hasselberg](http://www.hans.io)

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without
limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons
to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
