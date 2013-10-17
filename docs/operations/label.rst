Getting labels
==============

Getting the label for a domain
------------------------------

| Domain names can be either benign (part of a whitelist), suspicious
| (flagged by the OpenDNS security team) or uncategorized.

| This method returns the label for a given domain, which can be either
| ``:suspicious``, ``:bad`` or ``:unknown``.

::

    db.label_by_name('github.com')

Returns a ``Symbol``:

::

    :benign

Getting the labels for a set of domains
---------------------------------------

| Domain names can be either benign (part of a whitelist), suspicious
| (flagged by the OpenDNS security team) or uncategorized.

| This method returns the labels for a set of domains, which can be either
| ``:suspicious``, ``:benign`` or ``:unknown``.

::

    db.labels_by_name(['github.com', 'skyrock.com'])

The labels for up to 42,000 domains can be queried at once.

Returns a ``Hash``:

::

    {
         "github.com" => :benign
        "skyrock.com" => :benign
    }

Testing whether a set of domains contains suspicious domains
------------------------------------------------------------

::

    db.include_suspicious?(['github.com', 'skyrock.com'])

Returns ``true`` or ``false``:

::

    false

Testing whether a set of domains contains benign domains
--------------------------------------------------------

::

    db.include_benign?(['github.com', 'skyrock.com'])

Returns ``true`` or ``false``:

::

    true

Testing whether a domain is suspicious
--------------------------------------

::

    db.is_suspicious?('github.com')

Returns ``true`` or ``false``:

::

    false

Testing whether a domain is benign
----------------------------------

::

    db.is_benign?('github.com')

Returns ``true`` or ``false``:

::

    true

Extracting the subset of suspicious names
-----------------------------------------

Given a set of names, return a subset of names flagged as suspicious:

::

    db.suspicious_names(['github.com', 'excue.ru'])

Returns an ``Array``:

::

    ['excue.ru']

Extracting the subset of names not flagged as suspicious
--------------------------------------------------------

Given a set of names, return a subset of names not flagged as
suspicious:

::

    db.suspicious_names(['github.com', 'excue.ru'])

Returns an ``Array``:

::

    ['github.com']

