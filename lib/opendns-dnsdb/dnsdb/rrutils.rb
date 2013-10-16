
module OpenDNS
  module RRUtils
    def distinct_rrs(rrs)
      return rrs unless rrs.kind_of?(Hash)
      rrs.values.flatten.uniq
    end
  end
end
