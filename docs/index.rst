=============================
OpenDNS Security Graph client
=============================

.. _installation:

Installation
============

.. code-block:: bash

  $ gem install opendns-dnsdb

Example
=======

.. code-block:: ruby

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

Parallel requests
=================

This client library transparently supports parallel requests.

Most operations can be given either a single name or single IP, as well
as a list of names or IPs. The library will transparently paralellize
operations in order for bulk queries to complete as fast as possible.

Bulk operations can be performed on arbitrary large sets of names or
IP addresses.

Setup
=====

.. code-block:: ruby

  require 'opendns-dnsdb'
  db = OpenDNS::DNSDB.new(sslcert: 'client.pem', sslcertpasswd: 'opendns')

Supported options:

* ``timeout``: timeout for each query, in seconds (default: 15 seconds)
* ``sslcert``: path to the SSL certificate
* ``sslcerttype``: SSL certificate type, defaults to ``pem``.
* ``sslcertpasswd``: SSL certificate password
* ``maxconnects``: max number of parallel operations (default: 10)

Note on certificates format
===========================

The curl library currently has some major issues dealing with
certificates stored in the PKCS12 format.

If the certificate you have been given is in PKCS12 format (`.p12`
file extension), just convert it to a `.pem` certificate file:

.. code-block:: bash

    openssl pkcs12 -in client.p12 -out client.pem -clcerts

And supply the path to the ``.pem`` file to the library.

Operations
==========

.. toctree::
  :maxdepth: 1

  operations/by_name
  operations/by_ip
  operations/label
  operations/related
  operations/traffic  
