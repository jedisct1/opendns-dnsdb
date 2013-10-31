
require 'spec_helper'

describe "traffic" do
  subject do
    OpenDNS::DNSDB::new(sslcert: CERT_FILE, sslcertpasswd: CERT_PASSWD)
  end
  
  it "returns the daily traffic for the past 5 days" do
    s = subject.daily_traffic_by_name('www.github.com', days_back: 5)
    expect(s).to be_a_kind_of(Enumerable)
    expect(s.size).to be 5
    expect(s.first).to be > 0    
  end

  it "returns the daily traffic for the past 5 days for a vector" do
    s = subject.daily_traffic_by_name(['www.github.com', 'github.com'], days_back: 5)
    expect(s).to be_a_kind_of(Hash)
    expect(s['www.github.com'].size).to be 5
    expect(s['www.github.com'].first).to be > 0
    expect(s['github.com'] == s['www.github.com'])
  end
end
