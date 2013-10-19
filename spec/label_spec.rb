
require 'spec_helper'

describe "label" do
  subject do
    OpenDNS::DNSDB::new(sslcert: CERT_FILE, sslcertpasswd: CERT_PASSWD)
  end

  it "returns the label for github.com" do
    s = subject.labels_by_name('github.com')
    expect(s).to eq(:benign)
  end
  
  it "returns the labels for github.com and skyrock.com" do
    s = subject.labels_by_name(['github.com', 'skyrock.com'])
    expect(s).to be_a_kind_of(Hash)
    expect(s).not_to be_empty
    expect(s['github.com']).to eq(:benign)
    expect(s['skyrock.com']).to eq(:benign)    
  end
  
  it "returns distinct labels for a set of names" do
    s = subject.distinct_labels_by_name(['github.com', 'skyrock.com'])
    expect(s).to be_a_kind_of(Enumerable)
    expect(s).to eq([:benign])
  end
  
  it "returns whether a set of names contain suspicious ones" do
    s = subject.include_suspicious?(['github.com', 'skyrock.com'])
    expect(s).to be_false
  end
  
  it "returns whether github.com is suspicious" do
    s = subject.is_suspicious?('github.com')
    expect(s).to be_false
  end
  
  it "returns whether a set of names contain benign ones" do
    s = subject.include_benign?(['github.com', 'skyrock.com'])
    expect(s).to be_true
  end
  
  it "returns whether github.com is benign" do
    s = subject.is_benign?('github.com')
    expect(s).to be_true
  end  

  it "returns whether example.com.x is unknown" do
    s = subject.is_unknown?('example.com.x')
    expect(s).to be_true
  end  

  it "returns the subset of names, flagged as suspicious" do
    s = subject.suspicious_names(['excue.ru', 'github.com'])
    expect(s).to include('excue.ru')
    expect(s).not_to include('github.com')
  end

  it "returns the subset of names, not flagged as suspicious" do
    s = subject.not_suspicious_names(['excue.ru', 'github.com'])
    expect(s).not_to include('excue.ru')
    expect(s).to include('github.com')
  end

  it "returns the subset of names, flagged as benign" do
    s = subject.benign_names(['excue.ru', 'github.com'])
    expect(s).not_to include('excue.ru')
    expect(s).to include('github.com')
  end

  it "returns the subset of names, not flagged as benign" do
    s = subject.not_benign_names(['excue.ru', 'github.com'])
    expect(s).to include('excue.ru')
    expect(s).not_to include('github.com')
  end

  it "returns the subset of names, flagged as unknown" do
    s = subject.unknown_names(['excue.ru.z', 'github.com'])
    expect(s).to include('excue.ru.z')
    expect(s).not_to include('github.com')
  end

  it "returns the subset of names, not flagged as unknown" do
    s = subject.not_unknown_names(['excue.ru', 'github.com'])
    expect(s).not_to include('excue.ru.z')
    expect(s).to include('github.com')
  end
end
