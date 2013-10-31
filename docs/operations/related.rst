Related domain
Related names
=============

Related names are names that have been frequently observed shortly
before or after a reference name.

This has proven to be very useful to discover C2 domains used by
malware when only a few of them were previously known. This is also
useful to investigate an infection chain.

Internally, multiple complementary matching algorithms are used. But the
library takes care of aggregating and normalizing the results.

Getting the list of related names
---------------------------------

Related names for a single name can be looked up, as well as for
a vector of names:

.. code-block:: ruby

    db.related_names('www.github.com')
    db.relates_names(['www.github.com', 'www.mozilla.org')

These functions return a ``Response::Distinct`` object, if a single
name was used as a starting point, or a ``Response::HashByName`` if a
vector was provided.

An optional block can be given. This block is a filter: it will be given each
name as an argument, and only names for which the return value of this
block is not ``false``/``nil`` will ke kept.

For example, this only retrieves names matching a given regular
expression:

.. code-block:: ruby

    db.related_names('www.skyrock.com') { |name| name.match /^miss-/ }

