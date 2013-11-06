Getting information out of an IP address
========================================

Getting the list of names served by a name server
-------------------------------------------------

| This returns the list of names that have been served by an
| authoritative name server:

.. code-block:: ruby

    db.names_by_nameserver_ip('199.185.137.3')

Returns a ``Response::Distinct``:

::

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

Getting the list of names that a set of name servers have been serving
----------------------------------------------------------------------

| This returns the list of names that have been served by a set of name
| servers:

.. code-block:: ruby

    db.names_by_nameserver_ip(['199.185.137.3', '65.19.167.109'])

Returns a ``Response::HashByIP``:

::

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

Getting the list of unique names served by a set of name servers
----------------------------------------------------------------

This returns a ``Response::Distinct`` of unique names served by a set of name
servers:

.. code-block:: ruby

    db.distinct_names_by_nameserver_ip(['199.185.137.3', '65.19.167.109'])

Returns a ``Response::Distinct``:

::

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

Getting the list of all names that resolved to an IP
----------------------------------------------------

| This returns all the names that have been seen for an IP over the past
| 3 months:

.. code-block:: ruby

    db.names_by_ip('192.30.252.131')

Returns a ``Response::Distinct``:

::

    [
        [0] "github.com.",
        [1] "ip1d-lb3-prd.iad.github.com."
    ]

Getting the list of all names that resolved to a set of IPs
-----------------------------------------------------------

| A bulk operation to retrieve the list of names having mapped to a set
| of IPs:

.. code-block:: ruby

    db.names_by_ip(['192.30.252.131', '199.233.90.68'])

Returns a ``Response::HashByIP``:

::

    {
        "192.30.252.131" => [
            [0] "github.com.",
            [1] "ip1d-lb3-prd.iad.github.com."
        ],
         "199.233.90.68" => [
            [0] "leaf.dragonflybsd.org."
        ]
    }

Getting the list of unique names for a set of IPs
-------------------------------------------------

| This method returns a list of distinct names seen for a set of IP
| addresses:

.. code-block:: ruby

    db.distinct_names_by_ip(['192.30.252.131', '199.233.90.68'])

Returns a ``Response::Distinct``:

::

    [
        [0] "github.com.",
        [1] "ip1d-lb3-prd.iad.github.com.",
        [2] "leaf.dragonflybsd.org."
    ]
