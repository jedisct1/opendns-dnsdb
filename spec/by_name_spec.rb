
require 'spec_helper'

describe "by_name" do
  subject do
    OpenDNS::DNSDB::new(sslcert: CERT_FILE, sslcertpasswd: CERT_PASSWD)
  end

  it "returns nameservers ips for a name" do
    s = subject.nameservers_ips_by_name('github.com')
    expect(s).to be_a_kind_of(Enumerable)
    expect(s).not_to be_empty
  end

  it "returns nameservers ips for multiple names" do
    s = subject.nameservers_ips_by_name(['github.com', 'github.io'])
    expect(s).to be_a_kind_of(Hash)
    expect(s).not_to be_empty
    s.each do |t|
      expect(t).to be_a_kind_of(Enumerable)
      expect(t).not_to be_empty
    end
  end

  it "returns distinct nameservers ips for multiple names" do
    s = subject.distinct_nameservers_ips_by_name(['github.com', 'github.io'])
    expect(s).to be_a_kind_of(Enumerable)
    expect(s).not_to be_empty
    expect(s.uniq - s).to be_empty
  end

  it "returns ips for a name" do
    s = subject.ips_by_name('github.com')
    expect(s).to be_a_kind_of(Enumerable)
    expect(s).not_to be_empty
  end

  it "returns ips for multiple names" do
    s = subject.ips_by_name(['github.com', 'github.io'])
    expect(s).to be_a_kind_of(Hash)
    expect(s).not_to be_empty
    s.each do |t|
      expect(t).to be_a_kind_of(Enumerable)
      expect(t).not_to be_empty
    end
  end

  it "returns distinct ips for multiple names" do
    s = subject.distinct_ips_by_name(['github.com', 'github.io'])
    expect(s).to be_a_kind_of(Enumerable)
    expect(s).not_to be_empty
    expect(s.uniq - s).to be_empty
  end

  it "returns mxs for multiple names" do
    s = subject.mxs_by_name(['github.com', 'github.io'])
    expect(s).to be_a_kind_of(Hash)
    expect(s).not_to be_empty
    s.each do |t|
      expect(t).to be_a_kind_of(Enumerable)
      expect(t).not_to be_empty
    end
  end

  it "returns distinct mxs for multiple names" do
    s = subject.distinct_mxs_by_name(['github.com', 'github.io'])
    expect(s).to be_a_kind_of(Enumerable)
    expect(s).not_to be_empty
    expect(s.uniq - s).to be_empty
  end

  it "returns cnames for multiple names" do
    s = subject.cnames_by_name(['www.skyrock.com', 'apple.com'])
    expect(s).to be_a_kind_of(Hash)
    expect(s).not_to be_empty
    s.each do |t|
      expect(t).to be_a_kind_of(Enumerable)
      expect(t).not_to be_empty
    end
  end

  it "returns distinct cnames for multiple names" do
    s = subject.distinct_cnames_by_name(['www.skyrock.com', 'apple.com'])
    expect(s).to be_a_kind_of(Enumerable)
    expect(s).not_to be_empty
    expect(s.uniq - s).to be_empty
  end
end
