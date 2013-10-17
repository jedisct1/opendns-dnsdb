
module OpenDNS
  class DNSDB
    module Response
      class Raw < Hashie::Mash
        def initialize(source_hash = nil, default = nil, &blk)
          if source_hash
            if source_hash[:first_seen]
              source_hash[:first_seen] = Date.parse(source_hash[:first_seen])
            end
            if source_hash[:last_seen]
              source_hash[:last_seen] = Date.parse(source_hash[:last_seen])
            end
          end
          super(source_hash, default, &blk)
        end
      end
      
      class HashByName < Hash
      end
      
      class HashByIP < Hash
      end
      
      class Distinct < Array
      end      
    end
  end
end
