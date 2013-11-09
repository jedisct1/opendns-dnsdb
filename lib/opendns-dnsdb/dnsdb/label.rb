
require_relative 'siphash'

module OpenDNS
  class DNSDB
    module Label
      CACHE_KEY = 'Umbrella/OpenDNS'      

      def distinct_labels(labels)
        return [ labels ] unless labels.kind_of?(Hash)
        Response::Distinct.new(labels.values.flatten.uniq)
      end     
      
      def labels_by_name(names)
        names_is_array = names.kind_of?(Enumerable)
        names = [ names ] unless names_is_array
        multi = Typhoeus::Hydra.hydra
        names_json = MultiJson.dump(names)
        cacheid = SipHash::digest(CACHE_KEY, names_json).to_s(16)
        url = "/infected/names/#{cacheid}.json"
        query = query_handler(url, :get, { body: names_json })
        multi.queue(query)
        multi.run
        responses = MultiJson.load(query.response.body)
        responses = responses['scores']
        responses.each_pair do |name, label|
          responses[name] = [:suspicious, :unknown, :benign][label + 1]
        end
        responses = Response::HashByName[responses]
        responses = responses.values.first unless names_is_array
        responses
      end
      
      def distinct_labels_by_name(names)
        distinct_labels(labels_by_name(names))
      end
      
      def include_suspicious?(names)
        distinct_labels_by_name(names).include?(:suspicious)
      end
      
      def is_suspicious?(name)
        include_suspicious?(name)
      end
      
      def include_benign?(names)
        distinct_labels_by_name(names).include?(:benign)
      end
      
      def is_benign?(name)
        include_benign?(name)
      end
      
      def include_unknown?(names)
        distinct_labels_by_name(names).include?(:unknown)
      end
      
      def is_unknown?(name)
        include_unknown?(name)
      end
      
      def suspicious_names(names)
        labels = labels_by_name(names)
        labels = [ labels ] unless labels.kind_of?(Enumerable)
        names = labels.select { |name, label| label == :suspicious }.keys
        Response::Distinct.new(names)
      end
      
      def not_suspicious_names(names)
        labels = labels_by_name(names)
        labels = [ labels ] unless labels.kind_of?(Enumerable)
        names = labels.select { |name, label| label != :suspicious }.keys
        Response::Distinct.new(names)
      end
      
      def unknown_names(names)
        labels = labels_by_name(names)
        labels = [ labels ] unless labels.kind_of?(Enumerable)
        names = labels.select { |name, label| label == :unknown }.keys        
        Response::Distinct.new(names)
      end
      
      def not_unknown_names(names)
        labels = labels_by_name(names)
        labels = [ labels ] unless labels.kind_of?(Enumerable)
        names = labels.select { |name, label| label != :unknown }.keys
        Response::Distinct.new(names)
      end
      
      def benign_names(names)
        labels = labels_by_name(names)
        labels = [ labels ] unless labels.kind_of?(Enumerable)
        names = labels.select { |name, label| label == :benign }.keys
        Response::Distinct.new(names)
      end
      
      def not_benign_names(names)
        labels = labels_by_name(names)
        labels = [ labels ] unless labels.kind_of?(Enumerable)
        names = labels.select { |name, label| label != :benign }.keys
        Response::Distinct.new(names)
      end            
    end
  end
end
