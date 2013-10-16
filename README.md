OpenDNS-DNSDB-Ruby
==================

A Ruby client library for the OpenDNS DNS database ("Security Graph").

Getting started
---------------

    require 'opendns-dnsdb'

    db = OpenDNS::DNSDB::new(sslcert: 'client.p12',
                             sslcertpasswd: 'opendns')

Supported options:
- `timeout`: timeout for each query, in seconds
- `sslcert`: path to the SSL certificate
- `sslcerttype`: SSL certificate type, defaults to `p12`
- `sslcertpasswd`: SSL certificate password
- `maxconnects`: max number of parallel operations

Parallel requests
-----------------

This client library transparently supports parallel requests.

Most operations can be given either a single name or single IP, as well
as a list of names or IPs. The library will transparently paralellize
operations in order for bulk queries to complete as fast as possible.
