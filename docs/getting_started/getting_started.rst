.. _chap_getting_started:

Getting Started with MITgcm
****************************

This chapter is divided into two main parts. The first part, which is
covered in sections \ref{sec:whereToFindInfo} through
\ref{sec:testing}, contains information about how to run experiments
using MITgcm. The second part, covered in sections
\ref{sec:eg-baro} through \ref{sec:eg-offline}, contains a set of
step-by-step tutorials for running specific pre-configured atmospheric
and oceanic experiments.

We believe the best way to familiarize yourself with the
model is to run the case study examples provided with the base
version. Information on how to obtain, compile, and run the code is
found here as well as a brief description of the model structure
directory and the case study examples. Information is also provided
here on how to customize the code when you are ready to try implementing 
the configuration you have in mind.  The code and algorithm
are described more fully in chapters \ref{chap:discretization} and 
\ref{chap:sarch}. 

.. _sec_whereToFindInfo:

Where to find information
=========================


There is a web-archived support mailing list for the model that
you can email at \texttt{MITgcm-support@mitgcm.org} or browse at:
\begin{rawhtml} <A href=http://mitgcm.org/mailman/listinfo/mitgcm-support/ target="idontexist"> \end{rawhtml}
\begin{verbatim}
http://mitgcm.org/mailman/listinfo/mitgcm-support/
http://mitgcm.org/pipermail/mitgcm-support/
\end{verbatim}
\begin{rawhtml} </A> \end{rawhtml}

\section{Obtaining the code}
\label{sec:obtainingCode}
\begin{rawhtml}
<!-- CMIREDIR:obtainingCode: -->
\end{rawhtml}

MITgcm can be downloaded from our system by following
the instructions below. As a courtesy we ask that you send e-mail to us at
\begin{rawhtml} <A href=mailto:MITgcm-support@mitgcm.org> \end{rawhtml}
MITgcm-support@mitgcm.org
\begin{rawhtml} </A> \end{rawhtml}
to enable us to keep track of who's using the model and in what application.
You can download the model two ways:

\begin{enumerate}
\item Using CVS software. CVS is a freely available source code management
tool. To use CVS you need to have the software installed. Many systems
come with CVS pre-installed, otherwise good places to look for
the software for a particular platform are
\begin{rawhtml} <A href=http://www.cvshome.org/ target="idontexist"> \end{rawhtml}
cvshome.org
\begin{rawhtml} </A> \end{rawhtml}
and
\begin{rawhtml} <A href=http://www.wincvs.org/ target="idontexist"> \end{rawhtml}
wincvs.org
\begin{rawhtml} </A> \end{rawhtml}
.

\item Using a tar file. This method is simple and does not
require any special software. However, this method does not
provide easy support for maintenance updates.

\end{enumerate}

\subsection{Method 1 - Checkout from CVS}
\label{sec:cvs_checkout}

If CVS is available on your system, we strongly encourage you to use it. CVS
provides an efficient and elegant way of organizing your code and keeping
track of your changes. If CVS is not available on your machine, you can also
download a tar file.

Before you can use CVS, the following environment variable(s) should
be set within your shell.  For a csh or tcsh shell, put the following 
\begin{verbatim}
% setenv CVSROOT :pserver:cvsanon@mitgcm.org:/u/gcmpack
\end{verbatim}
in your \texttt{.cshrc} or \texttt{.tcshrc} file.  For bash or sh
shells, put:
\begin{verbatim}
% export CVSROOT=':pserver:cvsanon@mitgcm.org:/u/gcmpack'
\end{verbatim}
in your \texttt{.profile} or \texttt{.bashrc} file.


To get MITgcm through CVS, first register with the MITgcm CVS server
using command:
\begin{verbatim}
% cvs login ( CVS password: cvsanon )
\end{verbatim}
You only need to do a ``cvs login'' once.

To obtain the latest sources type:
\begin{verbatim}
% cvs co -P MITgcm
\end{verbatim}
or to get a specific release type:
\begin{verbatim}
% cvs co -P -r checkpoint52i_post MITgcm
\end{verbatim}
The CVS command ``\texttt{cvs co}'' is the abreviation of the full-name
``\texttt{cvs checkout}'' command and using the option ``-P'' (\texttt{cvs co -P})
will prevent to download unnecessary empty directories.

The MITgcm web site contains further directions concerning the source
code and CVS.  It also contains a web interface to our CVS archive so
that one may easily view the state of files, revisions, and other
development milestones:
\begin{rawhtml} <A href="http://mitgcm.org/viewvc/MITgcm/MITgcm/" target="idontexist"> \end{rawhtml}
\begin{verbatim}
http://mitgcm.org/viewvc/MITgcm/MITgcm/
\end{verbatim}
\begin{rawhtml} </A> \end{rawhtml}

As a convenience, the MITgcm CVS server contains aliases which are
named subsets of the codebase.  These aliases can be especially
helpful when used over slow internet connections or on machines with
restricted storage space.  Table \ref{tab:cvsModules} contains a list
of CVS aliases
\begin{table}[htb]
  \centering
  \begin{tabular}[htb]{|lp{3.25in}|}\hline
    \textbf{Alias Name}    &  \textbf{Information (directories) Contained}  \\\hline
    \texttt{MITgcm\_code}  &  Only the source code -- none of the verification examples.  \\
    \texttt{MITgcm\_verif\_basic}
    &  Source code plus a small set of the verification examples 
    (\texttt{global\_ocean.90x40x15}, \texttt{aim.5l\_cs}, \texttt{hs94.128x64x5}, 
    \texttt{front\_relax}, and \texttt{plume\_on\_slope}).  \\
    \texttt{MITgcm\_verif\_atmos}  &  Source code plus all of the atmospheric examples.  \\
    \texttt{MITgcm\_verif\_ocean}  &  Source code plus all of the oceanic examples.  \\
    \texttt{MITgcm\_verif\_all}    &  Source code plus all of the
    verification examples. \\\hline
  \end{tabular}
  \caption{MITgcm CVS Modules}
  \label{tab:cvsModules}
\end{table}

The checkout process creates a directory called \texttt{MITgcm}. If
the directory \texttt{MITgcm} exists this command updates your code
based on the repository. Each directory in the source tree contains a
directory \texttt{CVS}. This information is required by CVS to keep
track of your file versions with respect to the repository. Don't edit
the files in \texttt{CVS}!  You can also use CVS to download code
updates.  More extensive information on using CVS for maintaining
MITgcm code can be found
\begin{rawhtml} <A href="http://mitgcm.org/public/using_cvs.html" target="idontexist"> \end{rawhtml}
here
\begin{rawhtml} </A> \end{rawhtml}.
It is important to note that the CVS aliases in Table
\ref{tab:cvsModules} cannot be used in conjunction with the CVS
\texttt{-d DIRNAME} option.  However, the \texttt{MITgcm} directories
they create can be changed to a different name following the check-out:
\begin{verbatim}
   %  cvs co -P MITgcm_verif_basic
   %  mv MITgcm MITgcm_verif_basic
\end{verbatim}

Note that it is possible to checkout code without ``cvs login'' and without
setting any shell environment variables by specifying the pserver name and
password in one line, for example:
\begin{verbatim}
   %  cvs -d :pserver:cvsanon:cvsanon@mitgcm.org:/u/gcmpack co -P MITgcm
\end{verbatim}

\subsubsection{Upgrading from an earlier version}

If you already have an earlier version of the code you can ``upgrade''
your copy instead of downloading the entire repository again. First,
``cd'' (change directory) to the top of your working copy:
\begin{verbatim}
% cd MITgcm
\end{verbatim}
and then issue the cvs update command such as:
\begin{verbatim}
% cvs -q update -d -P -r checkpoint52i_post
\end{verbatim}
This will update the ``tag'' to ``checkpoint52i\_post'', add any new
directories (-d) and remove any empty directories (-P). The -q option
means be quiet which will reduce the number of messages you'll see in
the terminal. If you have modified the code prior to upgrading, CVS
will try to merge your changes with the upgrades. If there is a
conflict between your modifications and the upgrade, it will report
that file with a ``C'' in front, e.g.:
\begin{verbatim}
C model/src/ini_parms.F
\end{verbatim}
If the list of conflicts scrolled off the screen, you can re-issue the
cvs update command and it will report the conflicts. Conflicts are
indicated in the code by the delimites ``$<<<<<<<$'', ``======='' and
``$>>>>>>>$''. For example,
{\small
\begin{verbatim}
<<<<<<< ini_parms.F
     & bottomDragLinear,myOwnBottomDragCoefficient,
=======
     & bottomDragLinear,bottomDragQuadratic,
>>>>>>> 1.18
\end{verbatim}
}
means that you added ``myOwnBottomDragCoefficient'' to a namelist at
the same time and place that we added ``bottomDragQuadratic''. You
need to resolve this conflict and in this case the line should be
changed to:
{\small
\begin{verbatim}
     & bottomDragLinear,bottomDragQuadratic,myOwnBottomDragCoefficient,
\end{verbatim}
}
and the lines with the delimiters ($<<<<<<$,======,$>>>>>>$) be deleted.
Unless you are making modifications which exactly parallel
developments we make, these types of conflicts should be rare.

\paragraph*{Upgrading to the current pre-release version}

We don't make a ``release'' for every little patch and bug fix in
order to keep the frequency of upgrades to a minimum. However, if you
have run into a problem for which ``we have already fixed in the
latest code'' and we haven't made a ``tag'' or ``release'' since that
patch then you'll need to get the latest code:
\begin{verbatim}
% cvs -q update -d -P -A
\end{verbatim}
Unlike, the ``check-out'' and ``update'' procedures above, there is no
``tag'' or release name. The -A tells CVS to upgrade to the
very latest version. As a rule, we don't recommend this since you
might upgrade while we are in the processes of checking in the code so
that you may only have part of a patch. Using this method of updating
also means we can't tell what version of the code you are working
with. So please be sure you understand what you're doing.

\subsection{Method 2 - Tar file download}
\label{sec:conventionalDownload}

If you do not have CVS on your system, you can download the model as a
tar file from the web site at:
\begin{rawhtml} <A href=http://mitgcm.org/download/ target="idontexist"> \end{rawhtml}
\begin{verbatim}
http://mitgcm.org/download/
\end{verbatim}
\begin{rawhtml} </A> \end{rawhtml}
The tar file still contains CVS information which we urge you not to
delete; even if you do not use CVS yourself the information can help
us if you should need to send us your copy of the code.  If a recent
tar file does not exist, then please contact the developers through
the 
\begin{rawhtml} <A href="mailto:MITgcm-support@mitgcm.org"> \end{rawhtml}
MITgcm-support@mitgcm.org
\begin{rawhtml} </A> \end{rawhtml}
mailing list.

\section{Model and directory structure}
\begin{rawhtml}
<!-- CMIREDIR:directory_structure: -->
\end{rawhtml}

The ``numerical'' model is contained within a execution environment
support wrapper. This wrapper is designed to provide a general
framework for grid-point models. MITgcmUV is a specific numerical
model that uses the framework. Under this structure the model is split
into execution environment support code and conventional numerical
model code. The execution environment support code is held under the
\texttt{eesupp} directory. The grid point model code is held under the
\texttt{model} directory. Code execution actually starts in the
\texttt{eesupp} routines and not in the \texttt{model} routines. For
this reason the top-level \texttt{MAIN.F} is in the
\texttt{eesupp/src} directory. In general, end-users should not need
to worry about this level. The top-level routine for the numerical
part of the code is in \texttt{model/src/THE\_MODEL\_MAIN.F}. Here is
a brief description of the directory structure of the model under the
root tree (a detailed description is given in section 3: Code
structure).

\begin{itemize}

\item \texttt{doc}: contains brief documentation notes.
  
\item \texttt{eesupp}: contains the execution environment source code.
  Also subdivided into two subdirectories \texttt{inc} and
  \texttt{src}.
  
\item \texttt{model}: this directory contains the main source code.
  Also subdivided into two subdirectories \texttt{inc} and
  \texttt{src}.
  
\item \texttt{pkg}: contains the source code for the packages. Each
  package corresponds to a subdirectory. For example, \texttt{gmredi}
  contains the code related to the Gent-McWilliams/Redi scheme,
  \texttt{aim} the code relative to the atmospheric intermediate
  physics. The packages are described in detail in chapter \ref{chap:packagesI}.
  
\item \texttt{tools}: this directory contains various useful tools.
  For example, \texttt{genmake2} is a script written in csh (C-shell)
  that should be used to generate your makefile. The directory
  \texttt{adjoint} contains the makefile specific to the Tangent
  linear and Adjoint Compiler (TAMC) that generates the adjoint code.
  The latter is described in detail in part \ref{chap.ecco}.
  This directory also contains the subdirectory build\_options, which
  contains the `optfiles' with the compiler options for the different
  compilers and machines that can run MITgcm.
  
\item \texttt{utils}: this directory contains various utilities. The
  subdirectory \texttt{knudsen2} contains code and a makefile that
  compute coefficients of the polynomial approximation to the knudsen
  formula for an ocean nonlinear equation of state. The
  \texttt{matlab} subdirectory contains matlab scripts for reading
  model output directly into matlab. \texttt{scripts} contains C-shell
  post-processing scripts for joining processor-based and tiled-based
  model output. The subdirectory exch2 contains the code needed for
  the exch2 package to work with different combinations of domain
  decompositions.
  
\item \texttt{verification}: this directory contains the model
  examples. See section \ref{sec:modelExamples}.

\item \texttt{jobs}: contains sample job scripts for running MITgcm.
  
\item \texttt{lsopt}: Line search code used for optimization.
  
\item \texttt{optim}: Interface between MITgcm and line search code.
  
\end{itemize}

\section[Building MITgcm]{Building the code}
\label{sec:buildingCode}
\begin{rawhtml}
<!-- CMIREDIR:buildingCode: -->
\end{rawhtml}

To compile the code, we use the \texttt{make} program. This uses a
file (\texttt{Makefile}) that allows us to pre-process source files,
specify compiler and optimization options and also figures out any
file dependencies. We supply a script (\texttt{genmake2}), described
in section \ref{sec:genmake}, that automatically creates the
\texttt{Makefile} for you. You then need to build the dependencies and
compile the code.

As an example, assume that you want to build and run experiment
\texttt{verification/exp2}. The are multiple ways and places to
actually do this but here let's build the code in
\texttt{verification/exp2/build}:
\begin{verbatim}
% cd verification/exp2/build
\end{verbatim}
First, build the \texttt{Makefile}:
\begin{verbatim}
% ../../../tools/genmake2 -mods=../code
\end{verbatim}
The command line option tells \texttt{genmake} to override model source
code with any files in the directory \texttt{../code/}.

On many systems, the \texttt{genmake2} program will be able to
automatically recognize the hardware, find compilers and other tools
within the user's path (``\texttt{echo \$PATH}''), and then choose an
appropriate set of options from the files (``optfiles'') contained in
the \texttt{tools/build\_options} directory.  Under some
circumstances, a user may have to create a new ``optfile'' in order to
specify the exact combination of compiler, compiler flags, libraries,
and other options necessary to build a particular configuration of
MITgcm.  In such cases, it is generally helpful to read the existing
``optfiles'' and mimic their syntax.

Through the MITgcm-support list, the MITgcm developers are willing to
provide help writing or modifing ``optfiles''.  And we encourage users
to post new ``optfiles'' (particularly ones for new machines or
architectures) to the 
\begin{rawhtml} <A href="mailto:MITgcm-support@mitgcm.org"> \end{rawhtml}
MITgcm-support@mitgcm.org
\begin{rawhtml} </A> \end{rawhtml}
list.

To specify an optfile to \texttt{genmake2}, the syntax is:
\begin{verbatim}
% ../../../tools/genmake2 -mods=../code -of /path/to/optfile
\end{verbatim}

Once a \texttt{Makefile} has been generated, we create the
dependencies with the command:
\begin{verbatim}
% make depend
\end{verbatim}
This modifies the \texttt{Makefile} by attaching a (usually, long)
list of files upon which other files depend. The purpose of this is to
reduce re-compilation if and when you start to modify the code. The
{\tt make depend} command also creates links from the model source to
this directory.  It is important to note that the {\tt make depend}
stage will occasionally produce warnings or errors since the
dependency parsing tool is unable to find all of the necessary header
files (\textit{eg.}  \texttt{netcdf.inc}).  In these circumstances, it
is usually OK to ignore the warnings/errors and proceed to the next
step.

Next one can compile the code using:
\begin{verbatim}
% make
\end{verbatim}
The {\tt make} command creates an executable called \texttt{mitgcmuv}.
Additional make ``targets'' are defined within the makefile to aid in
the production of adjoint and other versions of MITgcm.  On SMP
(shared multi-processor) systems, the build process can often be sped
up appreciably using the command:
\begin{verbatim}
% make -j 2
\end{verbatim}
where the ``2'' can be replaced with a number that corresponds to the
number of CPUs available.

Now you are ready to run the model. General instructions for doing so are
given in section \ref{sec:runModel}. Here, we can run the model by
first creating links to all the input files:
\begin{verbatim}
ln -s ../input/* .
\end{verbatim}
and then calling the executable with:
\begin{verbatim}
./mitgcmuv > output.txt
\end{verbatim}
where we are re-directing the stream of text output to the file
\texttt{output.txt}.

\subsection{Building/compiling the code elsewhere}

In the example above (section \ref{sec:buildingCode}) we built the
executable in the {\em input} directory of the experiment for
convenience. You can also configure and compile the code in other
locations, for example on a scratch disk with out having to copy the
entire source tree. The only requirement to do so is you have {\tt
  genmake2} in your path or you know the absolute path to {\tt
  genmake2}.

The following sections outline some possible methods of organizing
your source and data.

\subsubsection{Building from the {\em ../code directory}}

This is just as simple as building in the {\em input/} directory:
\begin{verbatim}
% cd verification/exp2/code
% ../../../tools/genmake2
% make depend
% make
\end{verbatim}
However, to run the model the executable ({\em mitgcmuv}) and input
files must be in the same place. If you only have one calculation to make:
\begin{verbatim}
% cd ../input
% cp ../code/mitgcmuv ./
% ./mitgcmuv > output.txt
\end{verbatim}
or if you will be making multiple runs with the same executable:
\begin{verbatim}
% cd ../
% cp -r input run1
% cp code/mitgcmuv run1
% cd run1
% ./mitgcmuv > output.txt
\end{verbatim}

\subsubsection{Building from a new directory}

Since the {\em input} directory contains input files it is often more
useful to keep {\em input} pristine and build in a new directory
within {\em verification/exp2/}:
\begin{verbatim}
% cd verification/exp2
% mkdir build
% cd build
% ../../../tools/genmake2 -mods=../code
% make depend
% make
\end{verbatim}
This builds the code exactly as before but this time you need to copy
either the executable or the input files or both in order to run the
model. For example,
\begin{verbatim}
% cp ../input/* ./
% ./mitgcmuv > output.txt
\end{verbatim}
or if you tend to make multiple runs with the same executable then
running in a new directory each time might be more appropriate:
\begin{verbatim}
% cd ../
% mkdir run1
% cp build/mitgcmuv run1/
% cp input/* run1/
% cd run1
% ./mitgcmuv > output.txt
\end{verbatim}

\subsubsection{Building on a scratch disk}

Model object files and output data can use up large amounts of disk
space so it is often the case that you will be operating on a large
scratch disk. Assuming the model source is in {\em ~/MITgcm} then the
following commands will build the model in {\em /scratch/exp2-run1}:
\begin{verbatim}
% cd /scratch/exp2-run1
% ~/MITgcm/tools/genmake2 -rootdir=~/MITgcm \
  -mods=~/MITgcm/verification/exp2/code
% make depend
% make
\end{verbatim}
To run the model here, you'll need the input files:
\begin{verbatim}
% cp ~/MITgcm/verification/exp2/input/* ./
% ./mitgcmuv > output.txt
\end{verbatim}

As before, you could build in one directory and make multiple runs of
the one experiment:
\begin{verbatim}
% cd /scratch/exp2
% mkdir build
% cd build
% ~/MITgcm/tools/genmake2 -rootdir=~/MITgcm \
  -mods=~/MITgcm/verification/exp2/code
% make depend
% make
% cd ../
% cp -r ~/MITgcm/verification/exp2/input run2
% cd run2
% ./mitgcmuv > output.txt
\end{verbatim}


\subsection{Using \texttt{genmake2}}
\label{sec:genmake}

To compile the code, first use the program \texttt{genmake2} (located
in the \texttt{tools} directory) to generate a Makefile.
\texttt{genmake2} is a shell script written to work with all
``sh''--compatible shells including bash v1, bash v2, and Bourne.
%Internally, \texttt{genmake2} determines the locations of needed
%files, the compiler, compiler options, libraries, and Unix tools.  It
%relies upon a number of ``optfiles'' located in the
%\texttt{tools/build\_options} directory.
\texttt{genmake2} parses information from the following sources:
\begin{description}
\item[-] a {\em gemake\_local} file if one is found in the current 
  directory
\item[-] command-line options
\item[-] an "options file" as specified by the command-line option
  \texttt{--optfile=/PATH/FILENAME}
\item[-] a {\em packages.conf} file (if one is found) with the 
  specific list of packages to compile. The search path for 
  file {\em packages.conf} is, first, the current directory and
  then each of the "MODS" directories in the given order (see below).
\end{description}

\subsubsection{Optfiles in \texttt{tools/build\_options} directory:}

The purpose of the optfiles is to provide all the compilation options
for particular ``platforms'' (where ``platform'' roughly means the
combination of the hardware and the compiler) and code configurations.
Given the combinations of possible compilers and library dependencies
({\it eg.}  MPI and NetCDF) there may be numerous optfiles available
for a single machine.  The naming scheme for the majority of the
optfiles shipped with the code is
\begin{center}
  {\bf OS\_HARDWARE\_COMPILER }
\end{center}
where
\begin{description}
\item[OS] is the name of the operating system (generally the
  lower-case output of the {\tt 'uname'} command)
\item[HARDWARE] is a string that describes the CPU type and
  corresponds to output from the  {\tt 'uname -m'} command:
  \begin{description}
  \item[ia32] is for ``x86'' machines such as i386, i486, i586, i686,
    and athlon
  \item[ia64] is for Intel IA64 systems (eg. Itanium, Itanium2)
  \item[amd64] is AMD x86\_64 systems
  \item[ppc] is for Mac PowerPC systems
  \end{description}
\item[COMPILER] is the compiler name (generally, the name of the
  FORTRAN executable)
\end{description}

In many cases, the default optfiles are sufficient and will result in
usable Makefiles.  However, for some machines or code configurations,
new ``optfiles'' must be written. To create a new optfile, it is
generally best to start with one of the defaults and modify it to suit
your needs.  Like \texttt{genmake2}, the optfiles are all written
using a simple ``sh''--compatible syntax.  While nearly all variables
used within \texttt{genmake2} may be specified in the optfiles, the
critical ones that should be defined are:

\begin{description}
\item[FC] the FORTRAN compiler (executable) to use
\item[DEFINES] the command-line DEFINE options passed to the compiler
\item[CPP] the C pre-processor to use
\item[NOOPTFLAGS] options flags for special files that should not be
  optimized
\end{description}

For example, the optfile for a typical Red Hat Linux machine (``ia32''
architecture) using the GCC (g77) compiler is
\begin{verbatim}
FC=g77
DEFINES='-D_BYTESWAPIO -DWORDLENGTH=4'
CPP='cpp  -traditional -P'
NOOPTFLAGS='-O0'
#  For IEEE, use the "-ffloat-store" option
if test "x$IEEE" = x ; then
    FFLAGS='-Wimplicit -Wunused -Wuninitialized'
    FOPTIM='-O3 -malign-double -funroll-loops'
else
    FFLAGS='-Wimplicit -Wunused -ffloat-store'
    FOPTIM='-O0 -malign-double'
fi
\end{verbatim}

If you write an optfile for an unrepresented machine or compiler, you
are strongly encouraged to submit the optfile to the MITgcm project
for inclusion.  Please send the file to the
\begin{rawhtml} <A href="mail-to:MITgcm-support@mitgcm.org"> \end{rawhtml}
\begin{center}
  MITgcm-support@mitgcm.org
\end{center}
\begin{rawhtml} </A> \end{rawhtml}
mailing list.

\subsubsection{Command-line options:}

In addition to the optfiles, \texttt{genmake2} supports a number of
helpful command-line options.  A complete list of these options can be
obtained from:
\begin{verbatim}
% genmake2 -h
\end{verbatim}

The most important command-line options are:
\begin{description}
  
\item[\texttt{--optfile=/PATH/FILENAME}] specifies the optfile that
  should be used for a particular build.
  
  If no "optfile" is specified (either through the command line or the
  MITGCM\_OPTFILE environment variable), genmake2 will try to make a
  reasonable guess from the list provided in {\em
    tools/build\_options}.  The method used for making this guess is
  to first determine the combination of operating system and hardware
  (eg. "linux\_ia32") and then find a working FORTRAN compiler within
  the user's path.  When these three items have been identified,
  genmake2 will try to find an optfile that has a matching name.
  
\item[\texttt{--mods='DIR1 DIR2 DIR3 ...'}] specifies a list of
  directories containing ``modifications''.  These directories contain
  files with names that may (or may not) exist in the main MITgcm
  source tree but will be overridden by any identically-named sources
  within the ``MODS'' directories.
  
  The order of precedence for this "name-hiding" is as follows:
  \begin{itemize}
  \item ``MODS'' directories (in the order given)
  \item Packages either explicitly specified or provided by default
    (in the order given)
  \item Packages included due to package dependencies (in the order
    that that package dependencies are parsed)
  \item The "standard dirs" (which may have been specified by the
    ``-standarddirs'' option)
  \end{itemize}
  
\item[\texttt{--pgroups=/PATH/FILENAME}] specifies the file
  where package groups are defined. If not set, the package-groups 
  definition will be read from {\em pkg/pkg\_groups}.
  It also contains the default list of packages (defined
  as the group ``{\it default\_pkg\_list}'' which is used
  when no specific package list ({\em packages.conf})
  is found in current directory or in any "MODS" directory.

\item[\texttt{--pdepend=/PATH/FILENAME}] specifies the dependency file
  used for packages.
  
  If not specified, the default dependency file {\em pkg/pkg\_depend}
  is used.  The syntax for this file is parsed on a line-by-line basis
  where each line containes either a comment ("\#") or a simple
  "PKGNAME1 (+|-)PKGNAME2" pairwise rule where the "+" or "-" symbol
  specifies a "must be used with" or a "must not be used with"
  relationship, respectively.  If no rule is specified, then it is
  assumed that the two packages are compatible and will function
  either with or without each other.
  
\item[\texttt{--adof=/path/to/file}] specifies the "adjoint" or
  automatic differentiation options file to be used.  The file is
  analogous to the ``optfile'' defined above but it specifies
  information for the AD build process.
  
  The default file is located in {\em
    tools/adjoint\_options/adjoint\_default} and it defines the "TAF"
  and "TAMC" compilers.  An alternate version is also available at
  {\em tools/adjoint\_options/adjoint\_staf} that selects the newer
  "STAF" compiler.  As with any compilers, it is helpful to have their
  directories listed in your {\tt \$PATH} environment variable.
  
\item[\texttt{--mpi}] This option enables certain MPI features (using
  CPP \texttt{\#define}s) within the code and is necessary for MPI
  builds (see Section \ref{sec:mpi-build}).
  
\item[\texttt{--make=/path/to/gmake}] Due to the poor handling of
  soft-links and other bugs common with the \texttt{make} versions
  provided by commercial Unix vendors, GNU \texttt{make} (sometimes
  called \texttt{gmake}) should be preferred.  This option provides a
  means for specifying the make executable to be used.
  
\item[\texttt{--bash=/path/to/sh}] On some (usually older UNIX)
  machines, the ``bash'' shell is unavailable.  To run on these
  systems, \texttt{genmake2} can be invoked using an ``sh'' (that is,
  a Bourne, POSIX, or compatible) shell.  The syntax in these
  circumstances is:
  \begin{center}
    \texttt{\%  /bin/sh genmake2 -bash=/bin/sh [...options...]}
  \end{center}
  where \texttt{/bin/sh} can be replaced with the full path and name
  of the desired shell.

\end{description}


\subsection{Building with MPI}
\label{sec:mpi-build}

Building MITgcm to use MPI libraries can be complicated due to the
variety of different MPI implementations available, their dependencies
or interactions with different compilers, and their often ad-hoc
locations within file systems.  For these reasons, its generally a
good idea to start by finding and reading the documentation for your
machine(s) and, if necessary, seeking help from your local systems
administrator.

The steps for building MITgcm with MPI support are:
\begin{enumerate}
  
\item Determine the locations of your MPI-enabled compiler and/or MPI
  libraries and put them into an options file as described in Section
  \ref{sec:genmake}.  One can start with one of the examples in:
  \begin{rawhtml} <A
    href="http://mitgcm.org/viewvc/MITgcm/MITgcm/tools/build_options/">
  \end{rawhtml}
  \begin{center}
    \texttt{MITgcm/tools/build\_options/}
  \end{center}
  \begin{rawhtml} </A> \end{rawhtml}
  such as \texttt{linux\_ia32\_g77+mpi\_cg01} or
  \texttt{linux\_ia64\_efc+mpi} and then edit it to suit the machine at
  hand.  You may need help from your user guide or local systems
  administrator to determine the exact location of the MPI libraries.
  If libraries are not installed, MPI implementations and related
  tools are available including:
  \begin{itemize}
  \item \begin{rawhtml} <A
      href="http://www-unix.mcs.anl.gov/mpi/mpich/">
    \end{rawhtml}
    MPICH
    \begin{rawhtml} </A> \end{rawhtml}

  \item \begin{rawhtml} <A
      href="http://www.lam-mpi.org/">
    \end{rawhtml}
    LAM/MPI
    \begin{rawhtml} </A> \end{rawhtml}

  \item \begin{rawhtml} <A
      href="http://www.osc.edu/~pw/mpiexec/">
    \end{rawhtml}
    MPIexec
    \begin{rawhtml} </A> \end{rawhtml}
  \end{itemize}
  
\item Build the code with the \texttt{genmake2} \texttt{-mpi} option
  (see Section \ref{sec:genmake}) using commands such as:
{\footnotesize \begin{verbatim}
  %  ../../../tools/genmake2 -mods=../code -mpi -of=YOUR_OPTFILE
  %  make depend
  %  make
\end{verbatim} }
  
\item Run the code with the appropriate MPI ``run'' or ``exec''
  program provided with your particular implementation of MPI.
  Typical MPI packages such as MPICH will use something like:
\begin{verbatim}
  %  mpirun -np 4 -machinefile mf ./mitgcmuv
\end{verbatim}
  Sightly more complicated scripts may be needed for many machines
  since execution of the code may be controlled by both the MPI
  library and a job scheduling and queueing system such as PBS,
  LoadLeveller, Condor, or any of a number of similar tools.  A few
  example scripts (those used for our \begin{rawhtml} <A
    href="http://mitgcm.org/public/testing.html"> \end{rawhtml}regular
  verification runs\begin{rawhtml} </A> \end{rawhtml}) are available
  at:
  \begin{rawhtml} <A
    href="http://mitgcm.org/viewvc/MITgcm/MITgcm/tools/example_scripts/">
  \end{rawhtml}
  {\footnotesize \tt
    http://mitgcm.org/viewvc/MITgcm/MITgcm/tools/example\_scripts/ }
  \begin{rawhtml} </A> \end{rawhtml}
  or at:
  \begin{rawhtml} <A
    href="http://mitgcm.org/viewvc/MITgcm/MITgcm_contrib/test_scripts/">
  \end{rawhtml}
  {\footnotesize \tt
    http://mitgcm.org/viewvc/MITgcm/MITgcm\_contrib/test\_scripts/ }
  \begin{rawhtml} </A> \end{rawhtml}

\end{enumerate}

An example of the above process on the MITgcm cluster (``cg01'') using
the GNU g77 compiler and the mpich MPI library is:

{\footnotesize \begin{verbatim}
  %  cd MITgcm/verification/exp5
  %  mkdir build
  %  cd build
  %  ../../../tools/genmake2 -mpi -mods=../code \
       -of=../../../tools/build_options/linux_ia32_g77+mpi_cg01
  %  make depend
  %  make
  %  cd ../input
  %  /usr/local/pkg/mpi/mpi-1.2.4..8a-gm-1.5/g77/bin/mpirun.ch_gm \
       -machinefile mf --gm-kill 5 -v -np 2  ../build/mitgcmuv
\end{verbatim} }

\section[Running MITgcm]{Running the model in prognostic mode}
\label{sec:runModel}
\begin{rawhtml}
<!-- CMIREDIR:runModel: -->
\end{rawhtml}

If compilation finished succesfully (section \ref{sec:buildingCode})
then an executable called \texttt{mitgcmuv} will now exist in the
local directory.

To run the model as a single process (\textit{ie.} not in parallel)
simply type:
\begin{verbatim}
% ./mitgcmuv
\end{verbatim}
The ``./'' is a safe-guard to make sure you use the local executable
in case you have others that exist in your path (surely odd if you
do!). The above command will spew out many lines of text output to
your screen.  This output contains details such as parameter values as
well as diagnostics such as mean Kinetic energy, largest CFL number,
etc. It is worth keeping this text output with the binary output so we
normally re-direct the \texttt{stdout} stream as follows:
\begin{verbatim}
% ./mitgcmuv > output.txt
\end{verbatim}
In the event that the model encounters an error and stops, it is very
helpful to include the last few line of this \texttt{output.txt} file
along with the (\texttt{stderr}) error message within any bug reports.

For the example experiments in \texttt{verification}, an example of the
output is kept in \texttt{results/output.txt} for comparison. You can
compare your \texttt{output.txt} with the corresponding one for that
experiment to check that the set-up works.



\subsection{Output files}

The model produces various output files and, when using \texttt{mnc},
sometimes even directories.  Depending upon the I/O package(s)
selected at compile time (either \texttt{mdsio} or \texttt{mnc} or
both as determined by \texttt{code/packages.conf}) and the run-time
flags set (in \texttt{input/data.pkg}), the following output may
appear.


\subsubsection{MDSIO output files}

The ``traditional'' output files are generated by the \texttt{mdsio}
package.  At a minimum, the instantaneous ``state'' of the model is
written out, which is made of the following files:

\begin{itemize}
\item \texttt{U.00000nIter} - zonal component of velocity field (m/s
  and positive eastward).

\item \texttt{V.00000nIter} - meridional component of velocity field
  (m/s and positive northward).

\item \texttt{W.00000nIter} - vertical component of velocity field
  (ocean: m/s and positive upward, atmosphere: Pa/s and positive
  towards increasing pressure i.e. downward).

\item \texttt{T.00000nIter} - potential temperature (ocean:
  $^{\circ}\mathrm{C}$, atmosphere: $^{\circ}\mathrm{K}$).

\item \texttt{S.00000nIter} - ocean: salinity (psu), atmosphere: water
  vapor (g/kg).

\item \texttt{Eta.00000nIter} - ocean: surface elevation (m),
  atmosphere: surface pressure anomaly (Pa).
\end{itemize}

The chain \texttt{00000nIter} consists of ten figures that specify the
iteration number at which the output is written out. For example,
\texttt{U.0000000300} is the zonal velocity at iteration 300.

In addition, a ``pickup'' or ``checkpoint'' file called:

\begin{itemize}
\item \texttt{pickup.00000nIter}
\end{itemize}

is written out. This file represents the state of the model in a condensed
form and is used for restarting the integration. If the C-D scheme is used,
there is an additional ``pickup'' file:

\begin{itemize}
\item \texttt{pickup\_cd.00000nIter}
\end{itemize}

containing the D-grid velocity data and that has to be written out as well
in order to restart the integration. Rolling checkpoint files are the same
as the pickup files but are named differently. Their name contain the chain 
\texttt{ckptA} or \texttt{ckptB} instead of \texttt{00000nIter}. They can be
used to restart the model but are overwritten every other time they are
output to save disk space during long integrations.

\subsubsection{MNC output files}

Unlike the \texttt{mdsio} output, the \texttt{mnc}--generated output
is usually (though not necessarily) placed within a subdirectory with
a name such as \texttt{mnc\_test\_\${DATE}\_\${SEQ}}.  

\subsection{Looking at the output}

The ``traditional'' or mdsio model data are written according to a
``meta/data'' file format.  Each variable is associated with two files
with suffix names \texttt{.data} and \texttt{.meta}. The
\texttt{.data} file contains the data written in binary form
(big\_endian by default). The \texttt{.meta} file is a ``header'' file
that contains information about the size and the structure of the
\texttt{.data} file. This way of organizing the output is particularly
useful when running multi-processors calculations. The base version of
the model includes a few matlab utilities to read output files written
in this format. The matlab scripts are located in the directory
\texttt{utils/matlab} under the root tree. The script \texttt{rdmds.m}
reads the data. Look at the comments inside the script to see how to
use it.

Some examples of reading and visualizing some output in {\em Matlab}:
\begin{verbatim}
% matlab
>> H=rdmds('Depth');
>> contourf(H');colorbar;
>> title('Depth of fluid as used by model');

>> eta=rdmds('Eta',10);
>> imagesc(eta');axis ij;colorbar;
>> title('Surface height at iter=10');

>> eta=rdmds('Eta',[0:10:100]);
>> for n=1:11; imagesc(eta(:,:,n)');axis ij;colorbar;pause(.5);end
\end{verbatim}

Similar scripts for netCDF output (\texttt{rdmnc.m}) are available and
they are described in Section \ref{sec:pkg:mnc}.

The MNC output files are all in the ``self-describing'' netCDF
format and can thus be browsed and/or plotted using tools such as:
\begin{itemize}
\item \texttt{ncdump} is a utility which is typically included
  with every netCDF install:
  \begin{rawhtml} <A href="http://www.unidata.ucar.edu/packages/netcdf/"> \end{rawhtml}
\begin{verbatim}
http://www.unidata.ucar.edu/packages/netcdf/
\end{verbatim}
  \begin{rawhtml} </A> \end{rawhtml} and it converts the netCDF
  binaries into formatted ASCII text files.

\item \texttt{ncview} utility is a very convenient and quick way
  to plot netCDF data and it runs on most OSes:
  \begin{rawhtml} <A href="http://meteora.ucsd.edu/~pierce/ncview_home_page.html"> \end{rawhtml}
\begin{verbatim}
http://meteora.ucsd.edu/~pierce/ncview_home_page.html
\end{verbatim}
  \begin{rawhtml} </A> \end{rawhtml}
  
\item MatLAB(c) and other common post-processing environments provide
  various netCDF interfaces including:
  \begin{rawhtml} <A href="http://mexcdf.sourceforge.net/"> \end{rawhtml}
\begin{verbatim}
http://mexcdf.sourceforge.net/
\end{verbatim}
  \begin{rawhtml} </A> \end{rawhtml}
  \begin{rawhtml} <A href="http://woodshole.er.usgs.gov/staffpages/cdenham/public_html/MexCDF/nc4ml5.html"> \end{rawhtml}
\begin{verbatim}
http://woodshole.er.usgs.gov/staffpages/cdenham/public_html/MexCDF/nc4ml5.html
\end{verbatim}
  \begin{rawhtml} </A> \end{rawhtml}
\end{itemize}

