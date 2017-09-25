.. _chap_contributing:

Contributing to the MITgcm
**************************

The MITgcm is an open source project that relies on the participation of its users, and we welcome contributions. This chapter sets out how you can contribute to the MITgcm.


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

To contribute to the source code of the model you will need to fork the repository and place a pull request on GitHub. The two following sections describe this process in different levels of detail. If you are unfamiliar with git, you may wish to skip the quickstart guide and use the detailed instructions. All contributions are expected to conform with the :ref:`subsec_code_style_guide`.


Quickstart Guide
----------------

1. Fork the project on GitHub (using the fork button) and create a local clone, if you haven’t already:

  ``git clone https://github.com/user_name/MITgcm66h.git``

2. Move into your local clone directory (cd MITgcm66h) and and set up a remote that points to the original:

  ``git remote add upstream https://github.com/altMITgcm/MITgcm66h.git``

3. This step is optional, but highly recommended. It will ensure that your GitHub repo stays up to date with the main repository. Checkout the master branch and sync everywhere:

|  ``git checkout master``
|  ``git pull upstream master``
|  ``git push origin master``
|  


4. Make a new branch from `upstream/master` (name it something appropriate, here we assume it is a bugfix) and make edits on this branch:

| ``git fetch upstream``
| ``git checkout -b bugfix upstream/master``
|

5. When edits are done, do all git add’s and git commit’s. In the commit, make a succinct (<70 char) summary, followed by a blank line and a longer description. Reference any outstanding issues addressed using the syntax ``#ISSUE_NUMBER``.

|  

6. Push the edited branch to the origin remote (i.e. your fork) on GitHub:

  ``git push -u origin bugfix``

7. On GitHub, go to your fork and hit the pull request (PR) button, and wait for the MITgcm head developers to review your proposed changes. You may get additional questions or requests before your changes are accepted into the primary MITgcm source code.


Detailed guide for those less familiar with Git and GitHub
----------------------------------------------------------

What is Git? Git is a version control software tool used to help coordinate work among the many MITgcm model contributors. Version control is a management system to track changes in code over time, not only facilitating ongoing changes to code, but also as a means to check differences and/or obtain code from any past time in the project history. Without such a tool, keeping track of bug fixes and new features submitted by the global network of MITgcm contributors would be virtually impossible. If you are familiar with the older form of version control used by the MITgcm (CVS), there are many similarities, but we now take advantage of the modern capabilities offered by Git.  

Git itself is open source linux software (typically included with any new linux installation, check with your sys-admin if it seems to be missing) that is necessary for tracking changes in files, etc. through your local computer’s terminal session. All Git-related terminal commands are of the form ``git <arguments>``.  Important functions include syncing or updating your code library, adding files to a collection of files with edits, and commands to “finalize” these changes for sending back to the MITgcm maintainers. There are numerous other Git command-line tools to help along the way (see man pages via ``man git``).

The most common git commands are:

 - ``git clone`` download (clone) a repository to your local machine
 - ``git status`` obtain information about the local git repository
 - ``git diff`` highlight differences between the current version of a file and the version from the most recent commit
 - ``git add`` stage a file, or changes to a file, so that they are ready for ``git commit``
 - ``git commit`` create a commit. A commit is a snapshot of the repository with an associated message that describes the changes.

What is GitHub then? GitHub is a website that has three major purposes: 1) Code Viewer: through your browser, you can view all source code and all changes to such over time; 2) “Pull Requests”: facilitates the process whereby code developers submit changes to the primary MITgcm maintainers; 3) the “Cloud”: GitHub functions as a cloud server to store different copies of the code. The utility of #1 is fairly obvious. For #2 and #3, without GitHub, one might envision making a big tarball of edited files and emailing the maintainers for inclusion in the main repository. Instead, GitHub effectively does something like this for you in a much more elegant way.  Note unlike using (linux terminal command) git, GitHub commands are NOT typed in a terminal, but are typically invoked by hitting a button on the web interface, or clicking on a webpage link etc. To contribute edits to MITgcm, you need to obtain a github account. It’s free; do this first if you don’t have one already. 

There are many online tutorials to using Git and GitHub (see for example https://akrabat.com/the-beginners-guide-to-contributing-to-a-github-project ); here, we are just communicating the basics necessary to submit code changes to the MITgcm. Spending some time learning the more advanced features of Git will likely pay off in the long run, and not just for MITgcm contributions, as you are likely to encounter it in all sorts of different projects.

To better understand this process, :numref:`git_setup` shows a conceptual map of the Git setup. Note three copies of the code: the main MITgcm repository sourcecode “upstream” (i.e., owned by the MITgcm maintainers) in the GitHub cloud, a copy of the repository “origin” owned by you, also residing in the GitHub cloud, and a local copy on your personal computer or compute cluster (where you intend to compile and run). The Git and GitHub commands to create this setup are explained more fully below.


 .. figure:: figs/git_setup.*
    :width: 80%
    :align: center
    :alt: Conceptual model of GitHub
    :name: git_setup

    A conceptual map of the GitHub setup. Git terminal commands are shown in red, GitHub commands are shown in green.

One other aspect of Git that requires some explanation to the uninitiated: your local linux copy of the code repository can contain different “branches”, each branch being a different copy of the code repository (this can occur in all git-aware directories). When you switch branches, basic unix commands such as ``ls`` or ``cat`` will show a different set of files specific to current branch. In other words, Git interacts with your local file system so that edits or newly created files only appear in the current branch, i.e., such changes do not appear in any other branches. So if you swore you made some changes to a particular file, and now it appears those changes have vanished, first check which branch you are on (``git status`` is a useful command here), all is probably not lost.


A detailed explanation of steps for contributing MITgcm code edits:

1. On GitHub, create a local clone (copy) of the repository in your GitHub cloud user space. From the main repository (https://github.com/altMITgcm/MITgcm) hit the **Fork** button. You now need to download the code onto your local computer using the git clone command. If you previously downloaded the code through a tarball or some other means, you will need to obtain a new, local, git-aware version via

  ``git clone https://github.com/user_name/MITgcm66h.git``

  from your terminal (technically, here you are copying the forked “origin” version from the cloud, not the “upstream” version, but these will be identical at this point).

2. Move into the local clone directory on your computer:

  ``cd MITgcm66h``

  Finally, we need to set up a remote that points to the main repository:

  ``git remote add upstream https://github.com/altMITgcm/MITgcm66h.git``

  This means that we now have two "remotes" of the project (a “remote” is just a pointer to a repository not on your computer, i.e. in the GitHub cloud), one pointing to your GitHub user space (“origin”), and this new remote pointing to the original (“upstream”). You can read and write into your "origin" version (since it belongs to you, in the cloud), but not into the "upstream" version. This command just sets up this remote, which is needed in step 3 -- no actual file manipulation is done.


3. Switch to the master branch, and make sure we're up to date. 
  ``git checkout master``

  Git checkout is the command to switch branches; this puts you on master branch, in the event you were sufficiently git-savy already to have created different branches in your git-cloned local repository. (It won’t hurt to type this if you are already on the master branch)

  ``git pull upstream master``
   
  This command will synchronize your local master branch with the main MITgcm repository master branch (i.e. “pull” any new changes that might have occurred in the upstream repository into your local clone). Note if you have made changes to files in the master branch, git will complain (files you created will not cause complaints, however) -- this is why we recommend doing other general MITgcm work (editing and running) on a separate branch and thus not working on the master branch. This command is necessary so that you use the most recently available code to begin your edits.

  ``git push origin master``
  
  The “push” command does the opposite of “pull”, so here you are synchronizing your GitHub cloud copy master branch to your local master branch (which you just updated). If you had performed step #1 above in the last few minutes, this step is not going to do anything (since you had just forked the “origin” from the “upstream” in step #1), but if any time elapsed, it will be necessary (the current version of the MITgcm source code is updated regularly).

4.  Next make a new branch.
  
| ``git fetch upstream``
| ``git checkout -b bugfix_thebug upstream/master``
|

  You will make edits on this new branch, to keep these new edits separate from any other changes to the repository in the course of your work (say through normal running of the model or any other separate research and/or modifications to repository files). Note that this command above not only creates the new branch ‘bugfix_thebug’ from the `upstream/master` branch, it switches you onto this newly created branch.  Naming the branch something descriptive helps. 

5. Doing stuff! This usually comes in two flavors, fixing bugs or adding a feature. To do this you should:

    - edit the relevant file(s) and/or create new files. Refer to :ref:`subsec_code_style_guide` for details on expected documentation standards and code style requirements. Of course, changes should be thoroughly tested to ensure they compile and run successfully!
    - type ``git add <FILENAME1> <FILENAME2> ...`` to stage the file(s) ready for a commit command (note both existing and brand new files need to be added). “Stage” effectively means to notify Git of the the list of files you plan to “commit” for changes into the version tracking system. Note you can change other files and NOT have them sent to model developers; only staged files will be sent. You can repeat this ``git add`` command as many times as you like and it will continue to augment the list of files.  ``git diff`` and ``git status`` are useful commands to see what you have done so far.
    - use ``git commit`` to commit the files. This is the first step in bundling a collection of files together to be sent off to the MITgcm maintainers. When you enter this command, an editor window will pop up. On the top line, type a succinct (<70 character) summary of what these changes accomplished. Then, leave a blank line and type a longer description of why the action in this commit was appropriate. It is good practice to link with known issues using the syntax ``#ISSUE_NUMBER`` in either the summary line or detailed comment. Note that all the changes do not have to be handled in a single commit (i.e. you can git add some files, do a commit, than continue anew by adding different files, do another commit etc.); git commit does not submit anything to maintainers.  
    - if you are fixing a more involved bug or adding a new feature, such that many changes are required, it is preferable to break your contribution into multiple commits (each documented separately) rather than submitting one massive commit; each commit should encompass a single conceptual change to the code base, regardless of how many files it touches. This will allow the MITgcm maintainers to more easily understand your proposed changes and will expedite the review process.

6. Now we “push” our modified branch with committed changes onto the origin remote in the GitHub cloud. This effectively updates your GitHub cloud copy of the MITgcm repo to reflect the wonderful changes you are contributing.
  ``git push -u origin bugfix``

7. Finally create a “pull request” (a.k.a. “PR”; in other words, you are requesting that the maintainers pull your changes into the main code repository). In GitHub, go to the fork of the project that you made (https://github.com/user_name/MITgcm66h.git). There is a button for "Compare and Pull" in your newly created branch. Click the button! Now you can add a final succinct summary description of what you've done in your commit(s), and flag up any issues. At last the maintainers will be notified and be able to peruse your changes! While the PR remains open, you can go back to step #5 and make additional edits, git adds, git commits, and then redo step #6; such changes will be added to the PR (and maintainers re-notified). The pull request remains open until either the maintainers fully accept and merge your code changes into the main repository, or decide to reject your changes. But much more likely than the latter, you will instead be asked to respond to feedback, modify your code changes in some way, and/or clean up your code to better satisfy our style requirements, etc., and the pull request will remain open instead of outright rejection.


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
