
require 'spec_helper'

describe "name" do
  subject do
    OpenDNS::DNSDB::new(sslcert: CERT_FILE, sslcertpasswd: CERT_PASSWD)
  end
  
  it "returns the subdomains for github.com" do
    s = subject.names_for_postfix('github.com')
    expect(s.size).to be > 1
  end

  it "returns distinct subdomains for github.com" do
    s = subject.distinct_names_for_postfix(['github.com', 'opendns.com'])
    expect(s.size).to be > 2
  end
end
