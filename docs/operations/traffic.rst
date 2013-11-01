DNS traffic
===========

The number of DNS queries observed for a name over a time period can
be retrieved.

This is especially useful to see if a domain is popular, and to spot
anomalies in its traffic.

Getting the number of queries observed for a name
-------------------------------------------------

The ``daily_traffic_by_name`` method returns a vector with the number
of queries observed for each day, within a time period.

By default, the time period starts 7 days before the current day, and
ends at the current day, a day starting at 00:00 UTC.

.. code-block:: ruby

    db.daily_traffic_by_name('www.github.com')

The output is a ``Result::TimeSeries`` object:

..

    [
        [0] 6152525,
        [1] 4756714,
        [2] 4670300,
        [3] 5954983,
        [4] 6140915,
        [5] 6040669,
        [6] 5529869
    ]
    
This method accepts several options:

- ``start``: a ``Date`` object representing the lower bound of the time interval
- ``end``: a ``Date`` object representing the higher bound of the time interval
- ``days_back``: if ``start`` is not provided, this represents the number of days to go back in time.

Here are some examples featuring these options:

.. code-block:: ruby

    db.daily_traffic_by_name('www.github.com', end: Date.today - 2, days_back: 10)
    
    db.daily_traffic_by_name('www.github.com', start: Date.today - 10)

The traffic for multiple domains can be looked up, provided that a
vector is given instead of a single name. In that case, the output is
a ``Result::HashByName`` object.

.. code-block:: ruby

    db.daily_traffic_by_name(['www.github.com', 'www.github.io'])

For example, the following snippet compares the median number of
queries for a set of domains:

.. code-block:: ruby

    ts = db.daily_traffic_by_name(['www.github.com', 'www.github.io'])
    ts.merge(ts) { |name, ts| ts.median.to_i }
    
..

    {
        "www.github.com" => 5954983,
         "www.github.io" => 528002
    }
