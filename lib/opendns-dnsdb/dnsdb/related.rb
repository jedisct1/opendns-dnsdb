
require_relative 'rrutils'

module OpenDNS
  class DNSDB
    module Related
      include OpenDNS::DNSDB::RRUtils

      def related_names_with_score(names, &filter)
        names_is_array = names.kind_of?(Enumerable)
        names = [ names ] unless names_is_array
        multi = query_multi
        queries_links = { }
        queries_coocs = { }
        names.each do |name|
          url_links = "/links/name/#{name}.json"
          query_links = query_handler(url_links)
          multi.queue(query_links)
          queries_links[name] = query_links

          url_coocs = "/recommendations/name/#{name}.json"
          query_coocs = query_handler(url_coocs)
          multi.queue(query_coocs)
          queries_coocs[name] = query_coocs
        end
        multi.run
        responses = { }
        queries_coocs.each_pair do |name, query|
          if query.response.body.empty?
            responses[name] ||= { }
            next
          end
          obj = MultiJson.load(query.response.body)
          if pfs2 = Response::Raw.new(obj).pfs2
            responses[name] = Hash[*pfs2.flatten]
          else
            responses[name] = { }
          end
        end
        queries_links.each_pair do |name, query|
          responses[name] ||= { }          
          if query.response.body.empty?
            next
          end
          obj = MultiJson.load(query.response.body)          
          if tb1 = Response::Raw.new(obj).tb1          
            upper = [1.0, tb1.map { |x| x[1] }.max].max
            responses[name] = Hash[*tb1.map { |x| [x[0], x[1] / upper] }.flatten]
          end
        end
        responses = Response::HashByName[responses]
        if block_given?
          responses.each_key do |name|
            responses[name].select! do |related_name, score|
              filter.call(related_name, score)
            end
          end
        end
        responses = responses.values.first unless names_is_array
        responses
      end
      
      def related_names(names, options = { }, &filter)
        res = related_names_with_score(names, &filter) || { }
        if names.kind_of?(Enumerable)
          res.merge(res) do |name, v|
            res0 = v.keys
            res0 = res0[0...options[:max_names]] if options[:max_names]
            res0
          end          
        else          
          res0 = res.keys
          res0 = res[0...options[:max_names]] if options[:max_names]
          res0
        end
      end
      
      def distinct_related_names(names, options = { }, &filter)
        names = [ names ] unless names.kind_of?(Enumerable)
        res = Response::Distinct.new(distinct_rrs(related_names(names, &filter))) - names
        return res[0...options[:max_names]] if options[:max_names] && res.length >= options[:max_names]
        if (options[:max_depth] || 1) > 1
          options0 = options.clone
          options0[:max_depth] -= 1
          related = distinct_related_names(res, options0, &filter)
          res += related - names
          res.uniq!
          res = res[0...options[:max_names]] if options[:max_names]          
        end
        res
      end
    end
  end
end
