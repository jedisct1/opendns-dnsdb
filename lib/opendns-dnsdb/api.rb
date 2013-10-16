
require 'date'
require 'ethon'
require 'hashie'
require 'multi_json'

require_relative 'dnsdb/by_ip'
require_relative 'dnsdb/by_name'

module OpenDNS
  class Response < Hashie::Mash
    def initialize(source_hash = nil, default = nil, &blk)
      if source_hash
        if source_hash[:first_seen]
          source_hash[:first_seen] = Date.parse(source_hash[:first_seen])
        end
        if source_hash[:last_seen]
          source_hash[:last_seen] = Date.parse(source_hash[:last_seen])
        end
      end
      super(source_hash, default, &blk)
    end
  end

  class DNSDB
    include OpenDNS::DNSDB::ByIP
    include OpenDNS::DNSDB::ByName    
    
    DEFAULT_TIMEOUT = 15
    DEFAULT_MAXCONNECTS = 10
    SGRAPH_API_BASE_URL = 'https://sgraph.umbrella.com'

    attr_reader :timeout
    attr_reader :sslcert
    attr_reader :sslcerttype
    attr_reader :sslcertpasswd
    attr_reader :maxconnects

    def initialize(params = { })
      raise UsageError, 'Missing certificate file' unless params[:sslcert]
      @sslcert = params[:sslcert]
      @timeout = DEFAULT_TIMEOUT
      @timeout = params[:timeout].to_f if params[:timeout]
      @maxconnects = DEFAULT_MAXCONNECTS
      @maxconnects = params[:maxconnects].to_i if params[:maxconnects]
      @sslcerttype = params[:sslcerttype] || 'p12'
      @sslcertpasswd = params[:sslcertpasswd] || ''
      @options = {
        followlocation: true,
        timeout: @timeout,
        sslcert: @sslcert,
        sslcerttype: @sslcerttype,
        sslcertpasswd: @sslcertpasswd
      }
    end

    def query_handler(endpoint)
      url = SGRAPH_API_BASE_URL + endpoint
      Ethon::Easy.new(@options.merge(url: url))
    end
  end
end
