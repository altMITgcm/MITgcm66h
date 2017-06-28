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


.. _subsec_code_style_guide:

Style guide
-----------



Contributing to the manual
==========================


Section headings
----------------

Chapter headings - these are the main headings with integer numbers - underlined with ``****``

section headings - headings with number format X.Y - underlined with ``====``

subsection headings - headings with number format X.Y.Z - underlined with ``---``

subsubsection headings - headings with number format X.Y.Z.A - underlined with ``+++``

paragraph headings - headings with no numbers - underlined with ``###``

N.B. all underlinings should be the same length as the heading


Cross referencing
-----------------

Labels go above the section they refer to, with the format ``.. _LABELNAME:``. The leading underscore is important.

To reference sections by number use this format for the reference: ``section :numref:`sec_eg_baro```

To reference sections by name use this format: ``:ref:`sec_eg_baro```


Maths
-----

Inline maths is done with ``:math:`LATEX_HERE```

Separate equations, which will be typeset on their own lines, are produced with::

  .. math::
      :label: eqn_label_here

      LATEX_HERE


.. _subsec_manual_style_guide:

Style guide
----------------------
