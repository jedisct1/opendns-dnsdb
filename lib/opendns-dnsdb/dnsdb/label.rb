
require_relative 'siphash'

module OpenDNS
  class DNSDB
    module Label
      CACHE_KEY = 'Umbrella/OpenDNS'      

      def distinct_labels(labels)
        return [ labels ] unless labels.kind_of?(Hash)
        labels.values.flatten.uniq
      end     
      
      def labels_by_name(names)
        names_is_array = names.kind_of?(Enumerable)
        names = [ names ] unless names_is_array
        multi = Ethon::Multi.new
        names_json = MultiJson.dump(names)
        cacheid = SipHash::digest(CACHE_KEY, names_json).to_s(16)
        url = "/infected/names/#{cacheid}.json"
        query = query_handler(url, :get, { body: names_json })
        multi.add(query)
        multi.perform
        responses = MultiJson.load(query.response_body)
        responses = responses['scores']
        responses.each_pair do |name, label|
          responses[name] = [:suspicious, :unknown, :benign][label + 1]
        end
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
      
      def suspicious_domains(names)
        labels = labels_by_name(names)
        labels = [ labels ] unless labels.kind_of?(Enumerable)
        labels.select { |name, label| label == :suspicious }.keys
      end
      
      def not_suspicious_domains(names)
        labels = labels_by_name(names)
        labels = [ labels ] unless labels.kind_of?(Enumerable)
        labels.select { |name, label| label != :suspicious }.keys
      end
      
      def unknown_domains(names)
        labels = labels_by_name(names)
        labels = [ labels ] unless labels.kind_of?(Enumerable)
        labels.select { |name, label| label == :unknown }.keys
      end
      
      def not_unknown_domains(names)
        labels = labels_by_name(names)
        labels = [ labels ] unless labels.kind_of?(Enumerable)
        labels.select { |name, label| label != :unknown }.keys
      end
      
      def benign_domains(names)
        labels = labels_by_name(names)
        labels = [ labels ] unless labels.kind_of?(Enumerable)
        labels.select { |name, label| label == :benign }.keys
      end
      
      def not_benign_domains(names)
        labels = labels_by_name(names)
        labels = [ labels ] unless labels.kind_of?(Enumerable)
        labels.select { |name, label| label != :benign }.keys
      end            
    end
  end
end
