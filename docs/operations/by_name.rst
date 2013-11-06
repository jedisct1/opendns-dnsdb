Getting information out of a name
=================================

Getting the nameserver IP addresses for a name
----------------------------------------------

.. code-block:: ruby

    db.nameservers_ips_by_name('github.com')

| This returns a ``Response::Distinct`` of IP addresses seen for this name for the past 3
| months, or an empty list if none have been seen.

::

    [
        [0] "204.13.250.16",
        [1] "204.13.251.16",
        [2] "208.78.70.16",
        [3] "208.78.71.16"
    ]

Getting the nameserver IPs for a set of names
---------------------------------------------

.. code-block:: ruby

    db.nameservers_ips_by_name(['github.com', 'github.io'])

This returns a ``Response::HashByName``:

::

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

Getting a list of distinct name servers for a set of names
----------------------------------------------------------

| A very common need is to retrieve the list of IP unique addresses seen
| for a set of domain names over the past 3 months.
| This can be achieved as follows:

.. code-block:: ruby

    db.distinct_nameservers_ips_by_name(['github.com', 'github.io'])

Returns a ``Response::Distinct``:

::

    [
        [0] "204.13.250.16",
        [1] "204.13.251.16",
        [2] "208.78.70.16",
        [3] "208.78.71.16"
    ]

| The output is always a ``Response::Distinct`` of distinct IP addresses.
| This method also works with a single domain name, and is an alias for
| ``nameservers_ips_by_name`` in that case.

Getting the list of IP addresses for a name
-------------------------------------------

| This returns the list of IP addresses seen over the past 3 months for
| a name:

.. code-block:: ruby

    db.ips_by_name('github.com')

Returns a ``Response::Distinct``"

::

    [
        [0] "192.30.252.129",
        [1] "192.30.252.130",
        [2] "192.30.252.131",
        [3] "192.30.252.128",
        [4] "204.232.175.90",
        [5] "207.97.227.239"
    ]

Getting the list of IP addresses for a set of names
---------------------------------------------------

Bulk lookups can be achieved by providing a list instead of a string:

.. code-block:: ruby

    db.ips_by_name(['github.com', 'github.io'])

Returns a ``Response::HashByName``:

::

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

Getting the list of unique IP addresses for a set of names
----------------------------------------------------------

.. code-block:: ruby

    db.distinct_ips_by_name(['github.com', 'github.io'])

Returns a ``Response::Distinct``:

::

    [
        [0] "192.30.252.129",
        [1] "192.30.252.130",
        [2] "192.30.252.131",
        [3] "192.30.252.128",
        [4] "204.232.175.90",
        [5] "207.97.227.239",
        [6] "204.232.175.78"
    ]

Getting the list of mail exchangers for a name
----------------------------------------------

.. code-block:: ruby

    db.mxs_by_name('github.com')

Returns a ``Response::Distinct``:

::

    [
        [0] "alt1.aspmx.l.google.com.",
        [1] "alt2.aspmx.l.google.com.",
        [2] "aspmx.l.google.com.",
        [3] "aspmx2.googlemail.com.",
        [4] "aspmx3.googlemail.com."
    ]

Getting the list of mail exchangers for a set of names
------------------------------------------------------

.. code-block:: ruby

    db.mxs_by_name(['github.com', 'github.io'])

Returns a ``Response::HashByName``:

::

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

Getting the list of unique mail exchangers for a set of names
-------------------------------------------------------------

.. code-block:: ruby

    db.distinct_mxs_by_name(['github.com', 'github.io'])

Returns a ``Response::Distinct`` of unique mail exchangers:

::

    [
        [0] "alt1.aspmx.l.google.com.",
        [1] "alt2.aspmx.l.google.com.",
        [2] "aspmx.l.google.com.",
        [3] "aspmx2.googlemail.com.",
        [4] "aspmx3.googlemail.com."
    ]

Getting the list of CNAMEs for a name
-------------------------------------

.. code-block:: ruby

    db.cnames_by_name('www.skyrock.com')

| Returns a ``Response::Distinct`` of CNAME records seen over the past 3 months for
| this name:

::

    [
        [0] "skyrockv4.gslb.skyrock.net."
    ]

Getting the list of CNAMEs for a set of names
---------------------------------------------

.. code-block:: ruby

    db.cnames_by_name(['www.skyrock.com', 'www.apple.com'])

Returns a ``Response::HashByName``:

::

    {
        "www.skyrock.com" => [
            [0] "skyrockv4.gslb.skyrock.net."
        ],
          "www.apple.com" => [
            [0] "www.isg-apple.com.akadns.net."
        ]
    }

Getting the list of unique CNAMEs seen for a list of names
----------------------------------------------------------

.. code-block:: ruby

    db.distinct_cnames_by_name(['www.skyrock.com', 'www.apple.com'])

Returns a ``Response::Distinct``:

::

    [
        [0] "skyrockv4.gslb.skyrock.net.",
        [1] "www.isg-apple.com.akadns.net."
    ]
