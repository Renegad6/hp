Ttclcheck is stand alone syntax checker for tcl programming language which also checks types. It checks not only the right syntax of Tcl code but also knows all build in commands and can follow the types of variables and parameters.
It supports object oriented extension XOTcl, ITcl (also Tk). 
Additionally ttclcheck can produce whole html site from source code with advanced source code navigation and highlighting. 
ttclcheck is programmed in XOTcl and available as GPL software.

The program was written by Artur Trzewik (Copyright 2013 Artur Trzewik)
mail@xdobry.de

homepage: http://www.xdobry.de/ttclcheck

requirements:

You need tcl interpreter at least in version 8.5
http://www.tcl.tk
XOTcl object orientet Tcl extension
http://www.xotcl.org

installation:

The programm does not need to be compiled. You may setup the tclsh programm in first
line of ttclcheck.tcl and add the programm to your execution path

usage:

tclsh ttclcheck.tcl ?options file1 file2 ... file

Options:

-h : write help and exit
-scan directory : scan recursively directory for *.tcl, *.xotcl, *.itk, *.itcl files
-out file : write output to file
-w file : write signatures to file
-r file : read signatures from file and write to it at the end
-l directory : use directory as repository the package signatures
-req tclpackage : same like tcl code package require name (use to register Itcl or XOTcl)
-log (trace|debug|info|warn|error) : set log level
-encoding encoding : set file encoding
-i file : include repository
-log loglevel : (trace,debug,info,warn,error)

-notypes : supress type checking
-oldstringop : allow usage of == operator also for strings

-html : convert all sources to html site
(only if -html present)
-od : output dir for html site
-noerror : do not incluse errors in html site

example

tclsh ttclcheck.tcl -html -od htmloutput -scan myprojectdir -oldstringop -w signatures.repo

Check all Tcl files in directory "myprojectdir" recursively.
Generate HTML site in directory "htmloutput". 
Allow usage of "==" operator for string and write signatures file to "signatures.repo".
