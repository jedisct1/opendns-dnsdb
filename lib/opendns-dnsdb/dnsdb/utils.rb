
module OpenDNS
  class DNSDB
    module Utils
      def normalize_names!(names)
        names.map! { |name| name.strip.gsub(/\.$/, '').downcase }
      end
      
      def normalize_names(names)
        names.map { |name| name.strip.gsub(/\.$/, '').downcase }
      end
      
      def dotify_names!(names)
        names.map! { |name| name.strip.gsub(/([^.])$/, '\\1.').downcase }
      end
      
      def dotify_names(names)
        names.map { |name| name.strip.gsub(/([^.])$/, '\\1.').downcase }
      end      
    end
  end
end