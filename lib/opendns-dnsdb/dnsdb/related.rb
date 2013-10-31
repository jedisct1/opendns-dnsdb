
require_relative 'rrutils'

module OpenDNS
  class DNSDB
    module Related
      include OpenDNS::DNSDB::RRUtils

      def related_names_with_score(names, &filter)
        names_is_array = names.kind_of?(Enumerable)
        names = [ names ] unless names_is_array
        multi = Ethon::Multi.new
        queries_links = { }
        queries_coocs = { }
        names.each do |name|
          url_links = "/links/name/#{name}.json"
          query_links = query_handler(url_links)
          multi.add(query_links)
          queries_links[name] = query_links

          url_coocs = "/recommendations/name/#{name}.json"
          query_coocs = query_handler(url_coocs)
          multi.add(query_coocs)
          queries_coocs[name] = query_coocs
        end
        multi.perform
        responses = { }
        queries_coocs.each_pair do |name, query|
          obj = MultiJson.load(query.response_body)
          responses[name] = Hash[*Response::Raw.new(obj).pfs2.flatten]
        end
        queries_links.each_pair do |name, query|
          obj = MultiJson.load(query.response_body)
          responses[name] ||= { }
          
          tb1 = Response::Raw.new(obj).tb1
          upper = [1.0, tb1.map { |x| x[1] }.max].max
          responses[name] = Hash[*tb1.map { |x| [x[0], x[1] / upper] }.flatten]
        end
        responses = Response::HashByName[responses]
        if block_given?
          responses.select! { |name, score| filter.call(name, score) }
        end
        responses = responses.values.first unless names_is_array
        responses
      end
      
      def related_names(names, &filter)
        related_names_with_score(names, &filter).keys
      end
      
      def distinct_related_names(names, &filter)
        Response::Distinct.new(distinct_rrs(related_names(names, &filter)))
      end
    end
  end
end
