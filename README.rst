Trac Wiki to reST
=================

This is a *very* rough start of a script to help convert Trac wiki syntax to reStructuredText friendly syntax.

Requirements
------------

- ruby

How to install
--------------

First, install the `pandoc <http://johnmacfarlane.net/pandoc/>`_, it may take 15min or more.

::

  sudo yum install cabal-install
  sudo cabal update
  sudo cabal install cabal-install
  sudo cabal install json-0.4.4
  sudo cabal install pandoc

Then, install other required libralies to run convert.rb.

::

  sudo yum -y install sqlite-devel
  gem install bundler
  bundle install

How to use
----------

- Copy your *trac.db* file into the same directory as the *convert.rb* script.
- Create a *wiki* directory to hold the output files.
- *./convert.rb*

Caveats
-------

You still need to look over the markup and fix any mistakes. It isn't perfect by any means, but it will save some time.

Acknowledgements
================

Thanks to

- https://github.com/ataka/trac_wiki_to_textile
- https://github.com/seven1m/trac_wiki_to_github


