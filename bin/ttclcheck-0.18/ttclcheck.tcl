#!/usr/bin/tclsh
# ttclcheck - typed tcl checker (for tcl programmin language)
#
# this program was create by Artur Trzewik and is GPL Software
# see http://www.xdobry.de/ttclcheck
# Copyright 2012 Artur Trzewik
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#

package require XOTcl
namespace import ::xotcl::*

proc startTTclCheck {} {
set sname [info script]
    if {$sname eq ""} {
        # Run interactive for develop purposes
        set progdir .
    } else {
        file lstat $sname stats
        # follow sym links
        if {$stats(type) eq "link"} {
            set sname [file readlink $sname]
        }
        set progdir [file dirname $sname]
    }
    source [file join $progdir IDETclParser.xotcl]
    if {"-html" in $::argv} {
	    source [file join $progdir IDETclToHtml.xotcl]
    }
    PrsCheckerOptions set rootDir $progdir

    PrsFileContext startFromShell $::argv
}

startTTclCheck

