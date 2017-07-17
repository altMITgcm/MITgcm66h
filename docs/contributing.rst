.. _chap_contributing:

Contributing to the MITgcm
**************************

The MITgcm is an open source project that relies on the participation of its users, and we welcome  contributions. This chapter sets out how you can contribute to the MITgcm.


Bugs and feature requests
=========================

If you think you've found a bug, the best thing to check that you're using the latest version of the model. If the bug is still in the latest version, then think about how you might fix it and file a ticket in the GitHub issue tracker [url to be inserted once we have the proper repo]. Please include as much detail as possible. At a minimum your ticket should include:

 - what the bug does;
 - the location of the bug: file name and line number(s); and
 - any suggestions you have for how it might be fixed.

To request a new feature, or guidance on how to implement it yourself, please open a ticket with the following details:

 - a clear explanation of what the feature will do; and
 - a summary of the equations to be solved.



Contributing to the code
========================

To contribute to the source code of the model you will need to fork the repository and place a pull request on GitHub. The two following sections describe this process in different levels of detail. If you are unfamiliar with git, you may wish to skip the Quickstart guide and use the detailed instructions. All contributions are expected to conform with the :ref:`subsec_code_style_guide`.


Quickstart Guide
----------------
You will need a GitHub account, but that's pretty much it!

1: Fork the project and create a local clone (copy)

  You can fork by clicking the button, and create a clone either also by using the button, or in a terminal:
  ``git clone https://github.com/user_name/MITgcm66h.git``
  (substitute your own user name on github)

  move into the new directory:
  ``cd MITgcm66h``

  Finally, we need to set up a remote that points to the original project:
  ``git remote add upstream https://github.com/altMITgcm/MITgcm66h.git``

  This means that we have two "remotes" of the project, one pointing to your space (origin), and one pointing to the original (upstream). You can read and write into your "origin" version, but not into the "upstream" version. 

2: Doing stuff! This usually comes in two flavours; Fixing bugs or adding a feature. Here we will assume we are fixing a bug and branch from the master, but if adding a new feature branching from develop is usually the way it works.

  To fix this "bug" we check out the master branch, and make sure we're up to date.
  ``git checkout master``
  ``git pull upstream master && git push origin master``

  Next make a new branch. Naming it something useful helps. 
  ``git checkout -b bugfix/contributingHowTo``

  Do the work! Be sure to include useful and detailed commit messages.
  To do this you should:

    - edit the relevant file(s)
    - use ``git add FILENAME`` to stage the file(s) ready for a commit command
    - use ``git commit`` to commit the files
    - type a succint (<70 character) summary of what the commit did
    - leave a blank line and type a longer description of why the action in this commit was appropriate
    - it is good practice to link with issues using the syntax ``#ISSUE_NUMBER`` in one or both of the above.

3: Now we push our branch into the origin remote.

  ``git push -u origin bugfix/contributingHowTo``

4: Then create a pull request (PR). In a browser, go to the fork of the project that you made. There is a button for "Compare and Pull" in your recent branches. Click the button! Now you can add a nice and succinct description of what you've done and flag up any issues.


5: Review by the maintainers! 



To sum up from https://akrabat.com/the-beginners-guide-to-contributing-to-a-github-project/ 

The fundamentals are:

  #.  Fork the project & clone locally.
  #.  Create an upstream remote and sync your local copy before you branch.
  #.  Branch for each separate piece of work.
  #.  Do the work, write good commit messages, and read the guidelines in the manual.
  #.  Push to your origin repository.
  #.  Create a new PR in GitHub.
  #.  Respond to any code review feedback.



Detailed guide
--------------

To be completed.


 .. figure:: figs/git_setup.*
    :width: 70%
    :align: center
    :alt: Conceptual model of GitHub
    :name: fig_48tile

    A conceptual map of the GitHub setup. Text in serif font are labels or concepts, text in sans serif represent commands.



.. _subsec_code_style_guide:

Style guide
-----------


Automatic testing with Travis-CI
--------------------------------

The MITgcm uses the continuous integration service Travis-CI to test code before it is accepted into the repository. When you submit a pull request your contributions will be automatically tested. However, it is a good idea to test before submitting a pull request, so that you have time to fix any issues that are identified. To do this, you will need to activate Travis-CI for your fork of the repository.

**Detailed instructions or link to be added.**



Contributing to the manual
==========================

Whether you are correcting typos or describing currently undocumented packages, we welcome all contributions to the manual. The following information will help you make sure that your contribution is consistent with the style of the MITgcm documentation. (We know that not all of the current documentation follows these guidelines - we're working on it)

Once you've made your changes to the manual, you should build it locally to verify that it works as expected. To do this you will need a working python installation with the following modules installed (use :code:`pip install MODULE` in the terminal):

 - sphinx
 - sphinxcontrib-bibtex
 - sphinx_rtd_theme

Then, run :code:`make html` in the :code:`docs` directory.


Section headings
----------------

- Chapter headings - these are the main headings with integer numbers - underlined with ``****``
- section headings - headings with number format X.Y - underlined with ``====``
- Subsection headings - headings with number format X.Y.Z - underlined with ``---``
- Subsubsection headings - headings with number format X.Y.Z.A - underlined with ``+++``
- Paragraph headings - headings with no numbers - underlined with ``###``

N.B. all underlinings should be the same length as the heading. If they are too short an error will be produced.


Cross referencing
-----------------

Labels go above the section they refer to, with the format ``.. _LABELNAME:``. The leading underscore is important.

To reference sections/figures/tables/equations by number use this format for the reference: ``:numref:`sec_eg_baro```

To reference sections by name use this format: ``:ref:`sec_eg_baro```


Maths
-----

Inline maths is done with ``:math:`LATEX_HERE```

Separate equations, which will be typeset on their own lines, are produced with::

  .. math::
      :label: eqn_label_here

      LATEX_HERE


.. _subsec_manual_style_guide:


Units
-----

Units should be typeset in normal text, and exponents added with the ``:sup:`` command. 

::

  100 N m\ :sup:`--2`

If the exponent is negative use two dashes ``--`` to make the minus sign long enough. The backslash removes the space between the unit and the exponent.




Describing subroutine inputs and outputs
----------------------------------------

This information should go in an 'adominition' block. The source code to achieve this is:

::

  .. admonition:: Subroutine
    :class: note

    S/R GMREDI_CALC_TENSOR (*pkg/gmredi/gmredi_calc_tensor.F*)

    :math:`\sigma_x`: **SlopeX** (argument on entry)

    :math:`\sigma_y`: **SlopeY** (argument on entry)

    :math:`\sigma_z`: **SlopeY** (argument)

    :math:`S_x`: **SlopeX** (argument on exit)

    :math:`S_y`: **SlopeY** (argument on exit)



Reviewing pull requests
=======================

The only people with write access to the main repository are a small number of core MITgcm developers. They are the people that will eventually merge your pull requests. However, before your PR gets merged, it will undergo the automated testing on Travis-CI, and it will be assessed by the MITgcm community.

**Everyone can review and comment on pull requests.** Even if you are not one of the core developers you can still comment on a pull request.

To test pull requests locally you should:

 - add the repository of the user proposing the pull request as a remote, :code:`git remote add USERNAME https://github.com/USERNAME/MITgcm66h.git` where USERNAME is replaced by the user name of the person who has made the pull request;

 - download a local version of the branch from the pull request, :code:`git fetch USERNAME` followed by :code:`git checkout --track USERNAME/foo`;

 - run tests locally; and

 - possibly push fixes or changes directly to the pull request.

None of these steps, apart from the final one, require write access to the main repository. This means that anyone can review pull requests. However, unless you are one of the core developers you won't be able to directly push changes. You will instead have to make a comment describing any problems you find.
