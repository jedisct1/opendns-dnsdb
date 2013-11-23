
module OpenDNS
  class DNSDB
    module Name
      def distinct_names(names)
        return [ names ] unless names.kind_of?(Hash)
        Response::Distinct.new(names.values.flatten.uniq)
      end     
            
      def names_with_postfix(names)
        names_is_array = names.kind_of?(Enumerable)
        names = [ names ] unless names_is_array
        multi = query_multi
        queries = { }
        names.each do |name|
          next if queries[name]
          url = "/dnsdb/postfix/name/#{name}.json"
          query = query_handler(url)
          multi.queue(query)
          queries[name] = query
        end
        multi.run
        responses = { }
        queries.each_pair do |name, query|
          obj = MultiJson.load(query.response.body)
          responses[name] = Response::Distinct.new(obj)
        end
        responses = Response::HashByName[responses]
        responses = responses.values.first unless names_is_array        
        responses        
      end
    end
    def distinct_names_with_postfix(names)
      distinct_names(names_with_postfix(names))
    end
  end
end
