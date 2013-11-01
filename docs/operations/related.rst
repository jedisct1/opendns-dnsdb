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

The maximum number of results can be specified:

.. code-block:: ruby

    db.related_names('www.skyrock.com', max_names: 50)

An optional block can also be given.

This block is a filter: it will be given each (name, score) as an
argument, and only names for which the return value of this block is
not ``false``/``nil`` will ke kept.

For example, this only retrieves names matching a given regular
expression:

.. code-block:: ruby

    db.related_names('www.skyrock.com') { |name| name.match /^miss-/ }
    
And this only retrieves names whose score is more than 0.1:

.. code-block:: ruby

    db.related_names('www.skyrock.com') { |name, score| score > 0.1 }

Getting the list of related names, with scores
----------------------------------------------

In addition to a list of names, a "score" can be returned for each
name found. This score is in the [0.0, 1.0] range, 1.0 meaning that a
name is likely to be closely related to the reference name, 0.0
meaning that these have not been observed together very frequently.

Related names for a single name can be looked up, as well as for
a vector of names:

.. code-block:: ruby

    db.related_names_with_score('www.github.com')
    db.relates_names_with_score(['www.github.com', 'www.mozilla.org')

These functions return a ``Response::HashByName``.

An optional filter can be provided:

.. code-block:: ruby

    db.related_names_with_score('www.skyrock.com') do |name|
      name.match /^miss-/
    end

Getting a set of distinct related names for a list of names
-----------------------------------------------------------

Given a list of names, this returns a set of names related to these.

.. code-block:: ruby

    db.distinct_related_names(['www.github.com', 'www.github.io'])

This returns a ``Result::Distinct`` object.

The maximum number of results can be specified:

.. code-block:: ruby

    db.distinct_related_names(['www.github.com', 'www.github.io'],
                              max_results: 250)

By default, only direct neighbors of the given names are returned, but
deep traversal is also fully supported.

This will return a list of names related to those provided in the
vector, but also names related to these newly found names, names
related to these related names:

.. code-block:: ruby

    db.distinct_related_names(['www.github.com', 'www.github.io'],
                              max_results: 250,
                              max_depth: 3)

Since a deep traversal can return a lot of results, some not being of
interest, a filter can be provided. This filter will be automatically applied
after each iteration:

.. code-block:: ruby

    db.distinct_related_names(['www.github.com', 'www.github.io'],
                              max_results: 250,
                              max_depth: 3) do |name, score|
      name.match(/^com-/) && score > 0.1
    end

A single name can also be given instead of a vector. This is
equivalent to ``related_names`` when a deep traversal is not performed.

This function returns a ``Response::Distinct`` object.
