
module OpenDNS
  class DNSDB
    module Traffic
      require 'cgi'
      require 'date'
      require 'descriptive_statistics'      
      
      DEFAULT_DAYS_BACK = 7

      def daily_traffic_by_name(names, options = { })
        names_is_array = names.kind_of?(Enumerable)
        names = [ names ] unless names_is_array
        multi = Typhoeus::Hydra.hydra
        date_end = options[:start] || Date.today
        date_end_s = CGI::escape("#{date_end.year}/#{date_end.month}/#{date_end.day}/23")
        days_back = options[:days_back] || DEFAULT_DAYS_BACK
        date_start = date_end - days_back
        date_start += 1 unless date_start == date_end
        date_start_s = CGI::escape("#{date_start.year}/#{date_start.month}/#{date_start.day}/00")
        date_end, date_start = date_start, date_end if date_start > date_end
        queries_traffic = { }
        names.each do |name|
          name0 = name.gsub(/^www[.]/, '')
          url_traffic = "/appserver/?v=1&function=domain2-system&domains=#{name0}" +
          "&locations=&start=#{date_start_s}&stop=#{date_end_s}"
          query_traffic = query_handler(url_traffic)
          multi.queue(query_traffic)
          queries_traffic[name] = query_traffic
        end
        multi.run
        responses = { }
        queries_traffic.each_pair do |name, query|
          obj = MultiJson.load(query.response.body)
          tc = obj['response']
          tc = tc.group_by { |x| x[0].split('/')[0...3].join('/') }
          tc.each_key do |date_s|
            tc[date_s] = tc[date_s].inject(0) { |a, x| a + x[1] }
          end
          responses[name] = tc.values
        end
        responses = Response::HashByName[responses]
        responses = responses.values.first unless names_is_array
        responses        
      end

      def relative_standard_deviation(names_ts)
        names_ts_is_hash = names_ts.kind_of?(Hash)
        names_ts = { x: names_ts } unless names_ts_is_hash
        responses = { }
        names_ts.each_pair do |name, ts|
          mean = ts.mean
          if mean <= 0.0
            responses[name] = 0.0
          else
            responses[name] = ts.standard_deviation / mean * 100.0
          end
        end
        responses = Response::HashByName[responses]
        responses = responses.values.first unless names_ts_is_hash
        responses
      end
      
      def high_pass_filter(names_ts, options)
        names_ts_is_hash = names_ts.kind_of?(Hash)
        names_ts = { x: names_ts } unless names_ts_is_hash
        responses = { }
        cutoff = options[:cutoff]
        names_ts.each_pair do |name, ts|
          responses[name] = ts.map { |x| x < cutoff ? 0.0 : x }
        end
        responses = Response::HashByName[responses]
        responses = responses.values.first unless names_ts_is_hash
        responses        
      end
    end
  end
end

      