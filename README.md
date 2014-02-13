OpenDNS Security Graph Client
=============================

Client library for the OpenDNS DNS database (aka "Security Graph").

The OpenDNS DNS database keeps track of DNS records observed by
OpenDNS public resolvers over a 90 days period.

It also computes extra features based on these log files, suitable for
building classifiers and reputation systems.

EOL for external researchers
============================

Access to the Security Graph API for researchers will be restricted to
OpenDNS employees starting February 19th.

Researchers with a client certificate can ask for an account for the
public version of the Security Graph.

The client library will remain available for reference, but the public
version of the Security Graph API will not be supported.

Documentation
-------------

[Click here to read the full documentation of the Security Graph library](http://opendns-dnsdb-client-for-ruby.readthedocs.org/en/latest/).

Example
-------

```ruby
# Setup
db = OpenDNS::DNSDB.new(sslcert: 'client.pem',
                        sslcerttype: 'pem', sslcertpasswd: 'opendns')

# A short list of known spam domains using a fast-flux infrastructure
spam_names = ['com-garciniac.net', 'bbc-global.co.uk', 'com-october.net']

# Retrieve all the IP addresses these morons have been using
ips = db.distinct_ips_by_name(spam_names)

# Discover new domains mapping to the IP addresses we just found
all_spam_names = db.distinct_names_by_ip(ips)

# Find all the name servers used by these new domains
all_spam_names_ns = db.distinct_nameservers_ips_by_name(all_spam_names)

# Find all the domains served by these name servers
maybe_more_spam = db.distinct_names_by_nameserver_ip(all_spam_names_ns)

# Return the subset of names not flagged as malware by OpenDNS yet
not_blocked_yet = db.not_suspicious_names(maybe_more_spam)

# Does this list of domains include domains used by malware?
is_malware = db.include_suspicious?(['wh4u6igxiglekn.su', 'excue.ru'])

# Specifically, is excue.ru suspicious?
is_suspicious = db.is_suspicious?('excue.ru')

# Find all .ru names frequently observed with wh4u6igxiglekn.su and excue.ru:
rel_ru = db.distinct_related_names(['wh4u6igxiglekn.su', 'excue.ru'],
                                    max_names: 500,
                                    max_depth: 4) { |n| n.end_with? '.ru.' }

# Get the number of daily requests for the past 10 days, for
# github.com and github.io:
traffic = db.daily_traffic_by_name(['www.github.com', 'www.github.io'],
                                   days_back: 10)

# Cut the noise from this traffic - Days with less than 10 queries
traffic = db.high_pass_filter(traffic, cutoff: 10)

# Check if the traffic for github.io is suspiciously spiky:
traffic_is_suspicious =
  db.relative_standard_deviation(traffic['www.github.io']) > 90
```

Note on certificates format
---------------------------

The curl library currently has some major issues dealing with
certificates stored in the PKCS12 format.

If the certificate you have been given is in PKCS12 format (`.p12`
file extension), just convert it to a `.pem` certificate file:

    openssl pkcs12 -in client.p12 -out client.pem -clcerts

And supply the path to the `.pem` file to the library.

Also make sure that the version of the curl library you are using is
up-to-date. Old versions had major bugs with concurrent queries.
