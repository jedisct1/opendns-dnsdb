
require 'spec_helper'

describe "name" do
  subject do
    OpenDNS::DNSDB::new(sslcert: CERT_FILE, sslcertpasswd: CERT_PASSWD)
  end
  
  it "returns the subdomains for github.com" do
    s = subject.names_for_postfix('github.com')
    expect(s.size).to be > 1
  end
end
