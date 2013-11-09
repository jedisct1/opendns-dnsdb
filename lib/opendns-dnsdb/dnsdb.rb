
require 'date'
require 'typhoeus'
require 'hashie'
require 'multi_json'

require_relative 'dnsdb/response'
require_relative 'dnsdb/by_ip'
require_relative 'dnsdb/by_name'
require_relative 'dnsdb/label'
require_relative 'dnsdb/related'
require_relative 'dnsdb/traffic'

module OpenDNS
  class DNSDB
    include OpenDNS::DNSDB::Response
    include OpenDNS::DNSDB::ByIP
    include OpenDNS::DNSDB::ByName
    include OpenDNS::DNSDB::Label
    include OpenDNS::DNSDB::Related
    include OpenDNS::DNSDB::Traffic
    
    DEFAULT_TIMEOUT = 15
    DEFAULT_MAX_CONCURRENCY = 10
    SGRAPH_API_BASE_URL = 'https://sgraph.umbrella.com'

    attr_reader :timeout
    attr_reader :sslcert
    attr_reader :sslcerttype
    attr_reader :sslcertpasswd
    attr_reader :max_concurrency

    def initialize(params = { })
      raise UsageError, 'Missing certificate file' unless params[:sslcert]
      @sslcert = params[:sslcert]
      @timeout = DEFAULT_TIMEOUT
      @timeout = params[:timeout].to_f if params[:timeout]
      @max_concurrency = DEFAULT_MAX_CONCURRENCY
      @max_concurrency = params[:max_concurrency].to_i if params[:max_concurrency]
      @sslcerttype = params[:sslcerttype] || 'pem'
      @sslcertpasswd = params[:sslcertpasswd] || 'opendns'
      @options = {
        followlocation: true,
        timeout: @timeout,
        sslcert: @sslcert,
        sslcerttype: @sslcerttype,
        sslcertpasswd: @sslcertpasswd
      }
      Typhoeus::Config.memoize = TRUE
    end

    def query_multi
      Typhoeus::Hydra.new(max_concurrency: @max_concurrency)
    end
    
    def query_handler(endpoint, method = :get, options = { })
      url = SGRAPH_API_BASE_URL + endpoint
      options = options.merge(@options)
      options.merge!(method: method)
      query = Typhoeus::Request.new(url,
        @options.merge(options).merge(method: method))
      query
    end
  end
end
