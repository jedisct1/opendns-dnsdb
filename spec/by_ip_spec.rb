
require 'spec_helper'

describe "by_ip" do
  subject do
    OpenDNS::DNSDB::new(sslcert: CERT_FILE, sslcertpasswd: CERT_PASSWD)
  end

  it "returns nameservers for an ip" do
    s = subject.nameservers_by_ip('208.69.39.2')
    expect(s).to be_a_kind_of(Enumerable)
    expect(s).not_to be_empty
  end

  it "returns nameservers for multiple ips" do
    s = subject.nameservers_by_ip(['208.69.39.2', '208.69.39.3'])
    expect(s).to be_a_kind_of(Hash)
    expect(s).not_to be_empty
    s.each do |t|
      expect(t).to be_a_kind_of(Enumerable)
      expect(t).not_to be_empty
    end
  end

  it "returns distinct nameservers for multiple ips" do
    s = subject.distinct_nameservers_by_ip(['208.69.39.2', '208.69.39.3'])
    expect(s).to be_a_kind_of(Enumerable)
    expect(s).not_to be_empty
    expect(s.uniq - s).to be_empty
  end

  it "returns names for an ip" do
    s = subject.names_by_ip('192.30.252.131')
    expect(s).to be_a_kind_of(Enumerable)
    expect(s).not_to be_empty
  end

  it "returns names for multiple ips" do
    s = subject.names_by_ip(['192.30.252.131', '208.69.39.3'])
    expect(s).to be_a_kind_of(Hash)
    expect(s).not_to be_empty
    s.each do |t|
      expect(t).to be_a_kind_of(Enumerable)
      expect(t).not_to be_empty
    end
  end

  it "returns distinct names for multiple ips" do
    s = subject.distinct_names_by_ip(['208.69.39.2', '208.69.39.3'])
    expect(s).to be_a_kind_of(Enumerable)
    expect(s).not_to be_empty
    expect(s.uniq - s).to be_empty
  end
end
