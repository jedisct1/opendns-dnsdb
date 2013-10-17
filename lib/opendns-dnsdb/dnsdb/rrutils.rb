
module OpenDNS
  class DNSDB
    module RRUtils
      def distinct_rrs(rrs)
        return rrs unless rrs.kind_of?(Hash)
        Response::Distinct.new(rrs.values.flatten.uniq)
      end
    end
  end
end
