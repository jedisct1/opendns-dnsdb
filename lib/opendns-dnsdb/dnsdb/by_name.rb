
require_relative 'rrutils'

module OpenDNS
  class DNSDB
    module ByName
      include OpenDNS::DNSDB::RRUtils
      
      def rr_only_for_names(responses)
        responses_is_hash = responses.kind_of?(Hash)
        responses = { a: responses } unless responses_is_hash
        responses.each_pair do |key, history|
          responses[key] = Response::Distinct.new(history.collect do |hrecord|
            hrecord.rrs.collect { |rr| rr.rr }
          end.flatten.uniq)
        end
        responses = responses.values.first unless responses_is_hash
        responses
      end
      
      def history_by_name(names, type)
        names_is_array = names.kind_of?(Enumerable)
        names = [ names ] unless names_is_array
        multi = query_multi
        queries = { }
        names.each do |name|
          next if queries[name]
          url = "/dnsdb/name/#{type}/#{name}.json"
          query = query_handler(url)
          multi.queue(query)
          queries[name] = query
        end
        multi.run
        responses = { }
        queries.each_pair do |name, query|
          obj = MultiJson.load(query.response.body)
          responses[name] = Response::Raw.new(obj).rrs_tf
        end
        responses = Response::HashByName[responses]
        responses = responses.values.first unless names_is_array
        responses
      end
      
      def nameservers_ips_history_by_name(names)
        history_by_name(names, 'ns')
      end
      
      def nameservers_ips_by_name(names)
        rr_only_for_names(nameservers_ips_history_by_name(names))
      end
      
      def distinct_nameservers_ips_by_name(names)
        Response::Distinct.new(distinct_rrs(nameservers_ips_by_name(names)))
      end
      
      def ips_history_by_name(names)
        history_by_name(names, 'a')
      end
      
      def ips_by_name(names)
        rr_only_for_names(ips_history_by_name(names))
      end
      
      def distinct_ips_by_name(names)
        distinct_rrs(ips_by_name(names))
      end
      
      def mxs_history_by_name(names)
        history_by_name(names, 'mx')
      end
      
      def mxs_by_name(names)
        rr_only_for_names(mxs_history_by_name(names))
      end
      
      def distinct_mxs_by_name(names)
        distinct_rrs(mxs_by_name(names))
      end
      
      def cnames_history_by_name(names)
        history_by_name(names, 'cname')
      end
      
      def cnames_by_name(names)
        rr_only_for_names(cnames_history_by_name(names))
      end
      
      def distinct_cnames_by_name(names)
        distinct_rrs(cnames_by_name(names))
      end
    end
  end
end
