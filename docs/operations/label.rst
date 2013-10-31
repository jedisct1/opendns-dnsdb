Getting labels
==============

Getting the label for a name
----------------------------

| Domain names can be either benign (part of a whitelist), suspicious
| (flagged by the OpenDNS security team) or uncategorized.

| This method returns the label for a given domain, which can be either
| ``:suspicious``, ``:benign`` or ``:unknown``.

.. code-block:: ruby

    db.label_by_name('github.com')

Returns a ``Symbol``:

::

    :benign

Getting the labels for a set of names
-------------------------------------

| Domain names can be either benign (part of a whitelist), suspicious
| (flagged by the OpenDNS security team) or uncategorized.

| This method returns the labels for a set of names, which can be either
| ``:suspicious``, ``:benign`` or ``:unknown``.

.. code-block:: ruby

    db.labels_by_name(['github.com', 'skyrock.com'])

The labels for up to 42,000 names can be queried at once.

Returns a ``Response::HashByName``:

::

    {
         "github.com" => :benign
        "skyrock.com" => :benign
    }

Testing whether a set of names contains suspicious names
--------------------------------------------------------

.. code-block:: ruby

    db.include_suspicious?(['github.com', 'skyrock.com'])

Returns ``true`` or ``false``:

::

    false

Testing whether a set of names contains benign names
----------------------------------------------------

.. code-block:: ruby

    db.include_benign?(['github.com', 'skyrock.com'])

Returns ``true`` or ``false``:

::

    true

Testing whether a set of names contains unknown names
-----------------------------------------------------

.. code-block:: ruby

    db.include_unknown?(['github.com', 'skyrock.com'])

Returns ``true`` or ``false``:

::

    false

Testing whether a domain is suspicious
--------------------------------------

.. code-block:: ruby

    db.is_suspicious?('github.com')

Returns ``true`` or ``false``:

::

    false

Testing whether a domain is benign
----------------------------------

.. code-block:: ruby

    db.is_benign?('github.com')

Returns ``true`` or ``false``:

::

    true

Testing whether a domain is unknown
-----------------------------------

.. code-block:: ruby

    db.is_unknown?('github.com')

Returns ``true`` or ``false``:

::

    false

Extracting the subset of suspicious names
-----------------------------------------

Given a set of names, return a subset of names flagged as suspicious:

.. code-block:: ruby

    db.suspicious_names(['github.com', 'excue.ru'])

Returns a ``Response::Distinct``:

::

    ['excue.ru']

Extracting the subset of names not flagged as suspicious
--------------------------------------------------------

Given a set of names, return a subset of names not flagged as
suspicious:

.. code-block:: ruby

    db.not_suspicious_names(['github.com', 'excue.ru'])

Returns a ``Response::Distinct``:

::

    ['github.com']

Extracting the subset of benign names
-------------------------------------

Given a set of names, return a subset of names flagged as benign:

.. code-block:: ruby

    db.benign_names(['github.com', 'excue.ru'])

Returns a ``Response::Distinct``:

::

    ['github.com']

Extracting the subset of names not flagged as benign
----------------------------------------------------

Given a set of names, return a subset of names not flagged as
benign:

.. code-block:: ruby

    db.not_benign_names(['github.com', 'excue.ru'])

Returns a ``Response::Distinct``:

::

    ['excue.ru']

Extracting the subset of unknown names
--------------------------------------

Given a set of names, return a subset of names flagged as unknown:

.. code-block:: ruby

    db.unknown_names(['github.com', 'exue.ru'])

Returns a ``Response::Distinct``:

::

    ['exue.ru']

Extracting the subset of names flagged as benign or suspicious
---------------------------------------------------------------

Given a set of names, return a subset of names flagged as benign or
suspicious:

.. code-block:: ruby

    db.not_unknown_names(['github.com', 'excue.ru'])

Returns a ``Response::Distinct``:

::

    ['github.com', 'excue.ru']

