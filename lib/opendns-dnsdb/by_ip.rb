
require_relative 'rrutils'

module OpenDNS
  class DNSDB
    include OpenDNS::RRUtils

    def rr_only_for_ips(responses)
      responses_is_hash = responses.kind_of?(Hash)
      responses = { a: responses } unless responses_is_hash
      responses.each_pair do |key, history|
        responses[key] = history.collect do |rr|
          rr.rr
        end.flatten.uniq
      end
      responses = responses.values.first unless responses_is_hash
      responses
    end

    def history_by_ip(ips, type)
      ips_is_array = ips.kind_of?(Enumerable)
      ips = [ ips ] unless ips_is_array
      multi = Ethon::Multi.new
      queries = { }
      ips.each do |ip|
        next if queries[ip]
        url = "/dnsdb/ip/#{type}/#{ip}.json"
        query = query_handler(url)
        multi.add(query)
        queries[ip] = query
      end
      multi.perform
      responses = { }
      queries.each_pair do |ip, query|
        obj = MultiJson.load(query.response_body)
        responses[ip] = Response.new(obj).rrs
      end
      responses = responses.values.first unless ips_is_array
      responses
    end

    def names_history_by_nameserver_ip(ips)
      history_by_ip(ips, 'ns')
    end

    def names_by_nameserver_ip(ips)
      rr_only_for_ips(names_history_by_nameserver_ip(ips))
    end

    def distinct_names_by_nameserver_ip(ips)
      distinct_rrs(names_by_nameserver_ip(ips))
    end

    def names_history_by_ip(ips)
      history_by_ip(ips, 'a')
    end

    def names_by_ip(ips)
      rr_only_for_ips(names_history_by_ip(ips))
    end

    def distinct_names_by_ip(ips)
      distinct_rrs(names_by_ip(ips))
    end
  end
end
