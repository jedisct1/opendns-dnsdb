OpenDNS-DNSDB-Ruby
==================

Ruby client library for the OpenDNS DNS database ("Security Graph").

The OpenDNS DNS database keeps track of DNS records observed by
OpenDNS public resolvers over a 90 days period.

It also computes extra features based on these log files, suitable for
building classifiers and reputation systems.

Installation
------------

    bundle && rake install

Example
-------

```ruby
# Setup
db = OpenDNS::DNSDB.new(sslcert: 'client.p12', sslcertpasswd: 'opendns')

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
```

Getting started
---------------

```ruby
require 'opendns-dnsdb'
db = OpenDNS::DNSDB.new(sslcert: 'client.p12', sslcertpasswd: 'opendns')
```

Supported options:
- `timeout`: timeout for each query, in seconds (default: 15 seconds)
- `sslcert`: path to the SSL certificate
- `sslcerttype`: SSL certificate type, defaults to `p12`
- `sslcertpasswd`: SSL certificate password
- `maxconnects`: max number of parallel operations (default: 10)

Parallel requests
-----------------

This client library transparently supports parallel requests.

Most operations can be given either a single name or single IP, as well
as a list of names or IPs. The library will transparently paralellize
operations in order for bulk queries to complete as fast as possible.

Bulk operations can be performed on arbitrary large sets of names or
IP addresses.

Getting the nameserver IP addresses for a name
----------------------------------------------

    db.nameservers_ips_by_name('github.com')
    
This returns an `Array` of IP addresses seen for this name for the past 3
months, or an empty list if none have been seen.

```
[
    [0] "204.13.250.16",
    [1] "204.13.251.16",
    [2] "208.78.70.16",
    [3] "208.78.71.16"
]
```

Getting the nameserver IPs for a set of names
---------------------------------------------

    db.nameservers_ips_by_name(['github.com', 'github.io'])
    
This returns a `Hash`:

```
{
    "github.com" => [
        [0] "204.13.250.16",
        [1] "204.13.251.16",
        [2] "208.78.70.16",
        [3] "208.78.71.16"
    ],
     "github.io" => [
        [0] "204.13.250.16",
        [1] "204.13.251.16",
        [2] "208.78.70.16",
        [3] "208.78.71.16"
    ]
}
```

Getting a list of distinct name servers for a set of names
----------------------------------------------------------

A very common need is to retrieve the list of IP unique addresses seen
for a set of domain names over the past 3 months.
This can be achieved as follows:

    db.distinct_nameservers_ips_by_name(['github.com', 'github.io'])

Returns an `Array`:
```
[
    [0] "204.13.250.16",
    [1] "204.13.251.16",
    [2] "208.78.70.16",
    [3] "208.78.71.16"
]
```

The output is always an `Array` of distinct IP addresses.
This method also works with a single domain name, and is an alias for
`nameservers_ips_by_name` in that case.

Getting the list of IP addresses for a name
-------------------------------------------

This returns the list of IP addresses seen over the past 3 months for
a name:

    db.ips_by_name('github.com')

Returns an `Array`"
```
[
    [0] "192.30.252.129",
    [1] "192.30.252.130",
    [2] "192.30.252.131",
    [3] "192.30.252.128",
    [4] "204.232.175.90",
    [5] "207.97.227.239"
]
```

Getting the list of IP addresses for a set of names
---------------------------------------------------

Bulk lookups can be achieved by providing a list instead of a string:

    db.ips_by_name(['github.com', 'github.io'])

Returns a `Hash`:
```
{
    "github.com" => [
        [0] "192.30.252.129",
        [1] "192.30.252.130",
        [2] "192.30.252.131",
        [3] "192.30.252.128",
        [4] "204.232.175.90",
        [5] "207.97.227.239"
    ],
     "github.io" => [
        [0] "204.232.175.78"
    ]
}
```

Getting the list of unique IP addresses for a set of names
----------------------------------------------------------

    db.distinct_ips_by_name(['github.com', 'github.io'])

Returns an `Array`:
```
[
    [0] "192.30.252.129",
    [1] "192.30.252.130",
    [2] "192.30.252.131",
    [3] "192.30.252.128",
    [4] "204.232.175.90",
    [5] "207.97.227.239",
    [6] "204.232.175.78"
]
```

Getting the list of mail exchangers for a name
----------------------------------------------

    db.mxs_by_name('github.com')

Returns an `Array`:
```
[
    [0] "alt1.aspmx.l.google.com.",
    [1] "alt2.aspmx.l.google.com.",
    [2] "aspmx.l.google.com.",
    [3] "aspmx2.googlemail.com.",
    [4] "aspmx3.googlemail.com."
]
```

Getting the list of mail exchangers for a set of names
------------------------------------------------------

    db.mxs_by_name(['github.com', 'github.io'])

Returns a `Hash`:
```
{
    "github.com" => [
        [0] "alt1.aspmx.l.google.com.",
        [1] "alt2.aspmx.l.google.com.",
        [2] "aspmx.l.google.com.",
        [3] "aspmx2.googlemail.com.",
        [4] "aspmx3.googlemail.com."
    ],
     "github.io" => []
}
```

Getting the list of unique mail exchangers for a set of names
-------------------------------------------------------------

    db.distinct_mxs_by_name(['github.com', 'github.io'])

Returns an `Array` of unique mail exchangers:
```
[
    [0] "alt1.aspmx.l.google.com.",
    [1] "alt2.aspmx.l.google.com.",
    [2] "aspmx.l.google.com.",
    [3] "aspmx2.googlemail.com.",
    [4] "aspmx3.googlemail.com."
]
```

Getting the list of CNAMEs for a name
-------------------------------------

    db.cnames_by_name('www.skyrock.com')

Returns an `Array` of CNAME records seen over the past 3 months for
this name:
```
[
    [0] "skyrockv4.gslb.skyrock.net."
]
```

Getting the list of CNAMEs for a set of names
---------------------------------------------

    db.cnames_by_name(['www.skyrock.com', 'www.apple.com'])

Returns a `Hash`:
```
{
    "www.skyrock.com" => [
        [0] "skyrockv4.gslb.skyrock.net."
    ],
      "www.apple.com" => [
        [0] "www.isg-apple.com.akadns.net."
    ]
}
```

Getting the list of unique CNAMEs seen for a list of names
----------------------------------------------------------

    db.distinct_cnames_by_name(['www.skyrock.com', 'www.apple.com'])

Returns an `Array`:
```
[
    [0] "skyrockv4.gslb.skyrock.net.",
    [1] "www.isg-apple.com.akadns.net."
]
```

Getting the list of names served by a name server
-------------------------------------------------

This returns the list of names that have been served by an
authoritative name server:

    db.names_by_nameserver_ip('199.185.137.3')

Returns an `Array`:
```
[
    [ 0] "openbsd.com.",
    [ 1] "openssh.com.",
    [ 2] "yycix.ca.",
    [ 3] "caisnet.com.",
    [ 4] "cdnpowerpac.com.",
    [ 5] "miarch.com.",
    [ 6] "openbsd.org.",
    [ 7] "theos.com.",
    [ 8] "enhanced-business.com.",
    [ 9] "onpa.ca.",
    [10] "openbsdfoundation.org.",
    [11] "eton-west.com.",
    [12] "barr-ryder.com.",
    [13] "chemco-elec.com.",
    [14] "rakeng.com.",
    [15] "yycix.com.",
    [16] "elementsustainable.com.",
    [17] "hartwigarchitecture.com.",
    [18] "pentagonstructures.com.",
    [19] "freezemaxwell.com.",
    [20] "workungarrick.com.",
    [21] "alpineheating.com.",
    [22] "caisnet.ca.",
    [23] "watertech.ca.",
    [24] "desco.cc.",
    [25] "openbsd.net.",
    [26] "krawford.com.",
    [27] "protostatix.com.",
    [28] "rms-group.ca.",
    [29] "cmroofing.ca.",
    [30] "hoeng.com.",
    [31] "openssh.net.",
    [32] "cuthbertsmith.com.",
    [33] "alta-tech.ca.",
    [34] "bockroofing.com."
]
```

Getting the list of names that a set of name servers have been serving
----------------------------------------------------------------------

This returns the list of names that have been served by a set of name
servers:

    db.names_by_nameserver_ip(['199.185.137.3', '65.19.167.109'])

Returns a `Hash`:
```
{
    "199.185.137.3" => [
        [ 0] "openbsd.com.",
        [ 1] "openssh.com.",
        [ 2] "yycix.ca.",
        [ 3] "caisnet.com.",
        [ 4] "cdnpowerpac.com.",
        [ 5] "miarch.com.",
        [ 6] "openbsd.org.",
        [ 7] "theos.com.",
        [ 8] "enhanced-business.com.",
        [ 9] "onpa.ca.",
        [10] "openbsdfoundation.org.",
        [11] "eton-west.com.",
        [12] "barr-ryder.com.",
        [13] "chemco-elec.com.",
        [14] "rakeng.com.",
        [15] "yycix.com.",
        [16] "elementsustainable.com.",
        [17] "hartwigarchitecture.com.",
        [18] "pentagonstructures.com.",
        [19] "freezemaxwell.com.",
        [20] "workungarrick.com.",
        [21] "alpineheating.com.",
        [22] "caisnet.ca.",
        [23] "watertech.ca.",
        [24] "desco.cc.",
        [25] "openbsd.net.",
        [26] "krawford.com.",
        [27] "protostatix.com.",
        [28] "rms-group.ca.",
        [29] "cmroofing.ca.",
        [30] "hoeng.com.",
        [31] "openssh.net.",
        [32] "cuthbertsmith.com.",
        [33] "alta-tech.ca.",
        [34] "bockroofing.com."
    ],
    "65.19.167.109" => [
        [0] "backplane.com.",
        [1] "dragonflybsd.org."
    ]
}
```

Getting the list of unique names served by a set of name servers
----------------------------------------------------------------

This returns an `Array` of unique names served by a set of name servers:

    db.distinct_names_by_nameserver_ip(['199.185.137.3', '65.19.167.109'])

Returns am `Array`:
```
[
    [ 0] "openbsd.com.",
    [ 1] "openssh.com.",
    [ 2] "yycix.ca.",
    [ 3] "caisnet.com.",
    [ 4] "cdnpowerpac.com.",
    [ 5] "miarch.com.",
    [ 6] "openbsd.org.",
    [ 7] "theos.com.",
    [ 8] "enhanced-business.com.",
    [ 9] "onpa.ca.",
    [10] "openbsdfoundation.org.",
    [11] "eton-west.com.",
    [12] "barr-ryder.com.",
    [13] "chemco-elec.com.",
    [14] "rakeng.com.",
    [15] "yycix.com.",
    [16] "elementsustainable.com.",
    [17] "hartwigarchitecture.com.",
    [18] "pentagonstructures.com.",
    [19] "freezemaxwell.com.",
    [20] "workungarrick.com.",
    [21] "alpineheating.com.",
    [22] "caisnet.ca.",
    [23] "watertech.ca.",
    [24] "desco.cc.",
    [25] "openbsd.net.",
    [26] "krawford.com.",
    [27] "protostatix.com.",
    [28] "rms-group.ca.",
    [29] "cmroofing.ca.",
    [30] "hoeng.com.",
    [31] "openssh.net.",
    [32] "cuthbertsmith.com.",
    [33] "alta-tech.ca.",
    [34] "bockroofing.com.",
    [35] "backplane.com.",
    [36] "dragonflybsd.org."
]
```

Getting the list of all names that resolved to an IP
----------------------------------------------------

This returns all the names that an IP has been seen for, for the past
3 months:

    db.names_by_ip('192.30.252.131')

Returns an `Array`:
```
[
    [0] "github.com.",
    [1] "ip1d-lb3-prd.iad.github.com."
]
```

Getting the list of all names that resolved to a set of IPs
-----------------------------------------------------------

A bulk operation to retrieve the list of names having mapped to a set
of IPs:

    db.names_by_ip(['192.30.252.131', '199.233.90.68'])

Returns a `Hash`:
```
{
    "192.30.252.131" => [
        [0] "github.com.",
        [1] "ip1d-lb3-prd.iad.github.com."
    ],
     "199.233.90.68" => [
        [0] "leaf.dragonflybsd.org."
    ]
}
```

Getting the list of unique names for a set of IPs
-------------------------------------------------

This method returns a list of distinct names seen for a set of IP
addresses:

    db.distinct_names_by_ip(['192.30.252.131', '199.233.90.68'])

Returns an `Array`:
```
[
    [0] "github.com.",
    [1] "ip1d-lb3-prd.iad.github.com.",
    [2] "leaf.dragonflybsd.org."
]
```
