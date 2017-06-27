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



Detailed guide
--------------


.. _subsec_code_style_guide:

Style guide
-----------



Contributing to the manual
==========================


Section headings
++++++++++++++++

Chapter headings - these are the main headings with integer numbers - underlined with ``****``

section headings - headings with number format X.Y - underlined with ``====``

subsection headings - headings with number format X.Y.Z - underlined with ``---``

subsubsection headings - headings with number format X.Y.Z.A - underlined with ``+++``

paragraph headings - headings with no numbers - underlined with ``###``

N.B. all underlinings should be the same length as the heading


Cross referencing
+++++++++++++++++

Labels go above the section they refer to, with the format ``.. _LABELNAME:``. The leading underscore is important.

To reference sections by number use this format for the reference: ``section :numref:`sec_eg_baro```

To reference sections by name use this format: ``:ref:`sec_eg_baro```


Maths
+++++

Inline maths is done with ``:math:`LATEX_HERE```

Separate equations, which will be typeset on their own lines, are produced with::

  .. math::
      :label: eqn_label_here

      LATEX_HERE


.. _subsec_manual_style_guide:

Style guide
----------------------
