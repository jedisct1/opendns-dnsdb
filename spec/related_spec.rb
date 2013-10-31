
require 'spec_helper'

describe "related" do
  subject do
    OpenDNS::DNSDB::new(sslcert: CERT_FILE, sslcertpasswd: CERT_PASSWD)
  end
  
  it "returns weighted related domains for www.github.com" do
    s = subject.related_names_with_score('www.github.com')
    expect(s).to be_a_kind_of(Hash)    
    expect(s).not_to be_empty
    expect(s.include?('www.github.com')).to be_false
  end

  it "returns weighted related domains for www.github.com and mozilla.org" do
    s = subject.related_names_with_score(['www.github.com', 'mozilla.org'])
    expect(s).to be_a_kind_of(Hash)
    expect(s['www.github.com']).to be_a_kind_of(Hash)
    expect(s['mozilla.org']).to be_a_kind_of(Hash)    
    expect(s).not_to be_empty
    expect(s['www.github.com'].include?('www.github.com')).to be_false
    expect(s['mozilla.org'].include?('mozilla.org')).to be_false    
  end

  it "returns related domains for www.github.com" do
    s = subject.related_names('www.github.com')
    expect(s).to be_a_kind_of(Enumerable)
    expect(s).not_to be_empty
    expect(s.include?('www.github.com')).to be_false
  end

  it "returns related domains for www.github.com and mozilla.org" do
    s = subject.related_names(['www.github.com', 'mozilla.org'])
    expect(s).to be_a_kind_of(Hash)
    expect(s).not_to be_empty
    expect(s['www.github.com']).to be_a_kind_of(Enumerable)
    expect(s['mozilla.org']).to be_a_kind_of(Enumerable)
    expect(s['www.github.com'].include?('www.github.com')).to be_false
    expect(s['mozilla.org'].include?('mozilla.org')).to be_false    
  end
  
  it "returns related domains with a maximum number of names" do
    s = subject.related_names(['www.github.com', 'mozilla.org'], max_names: 1)
    expect(s).to be_a_kind_of(Hash)
    expect(s).not_to be_empty
    expect(s['www.github.com']).to be_a_kind_of(Enumerable)
    expect(s['mozilla.org']).to be_a_kind_of(Enumerable)
    expect(s['www.github.com'].size).to be 1
    expect(s['mozilla.org'].size).to be 1
  end
  
  it "returns distinct related names for www.github.com and mozilla.org" do
    s = subject.distinct_related_names(['www.github.com', 'mozilla.org'])
    expect(s).to be_a_kind_of(Enumerable)
    expect(s).not_to be_empty
  end

  it "returns distinct related names with a maximum number of names" do
    s = subject.distinct_related_names(['www.github.com', 'mozilla.org'],
      max_names: 1)
    expect(s).to be_a_kind_of(Enumerable)
    expect(s).not_to be_empty
    expect(s.size).to be 1
  end

  it "returns distinct related names, with a block" do
    s = subject.distinct_related_names(['www.github.com',
      'mozilla.org']) { |name| true }
    expect(s).to be_a_kind_of(Enumerable)
    expect(s).not_to be_empty

    s = subject.distinct_related_names(['www.github.com',
      'mozilla.org']) { |name| false }
    expect(s).to be_a_kind_of(Enumerable)
    expect(s).to be_empty
  end
  
  it "returns the result of a deep traversal on www.github.com" do
    s = subject.distinct_related_names('www.github.com',
      max_depth: 2, max_names: 1000)
    expect(s).to be_a_kind_of(Enumerable)
    expect(s).not_to be_empty
  end

  it "returns the result of a deep traversal on www.github.com with a filter" do
    s = subject.distinct_related_names('www.github.com',
      max_depth: 2, max_names: 1000) { |name| false }
    expect(s).to be_a_kind_of(Enumerable)
    expect(s).to be_empty
  end  
end
