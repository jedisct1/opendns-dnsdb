Getting informations out of a name
==================================

Getting the nameserver IP addresses for a name
----------------------------------------------

.. code-block:: ruby

  db.nameservers_ips_by_name('github.com')
    
This returns an ``Array`` of IP addresses seen for this name for the past 3
months, or an empty list if none have been seen.

.. code-block:: ruby

  [
      [0] "204.13.250.16",
      [1] "204.13.251.16",
      [2] "208.78.70.16",
      [3] "208.78.71.16"
  ]
