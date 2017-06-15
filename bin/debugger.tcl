# debug.tcl --
#    Script providing basic debugging facilities
#

global go
global breakpoints {}
global dcmd
global dname
global silent 0

# dbg_enter --
#    Callback for enterstep event
#
# Arguments:
#    cmd        Expanded command line
#    op         Operation
# Result:
#    None
# Side effect:
#    Sets dname
#
#
proc ::Tracedebug::dbg_enter {cmd op} {
    global dname
    global silent
    global breakpoints
    if { [lsearch $breakpoints [lindex $cmd 0]] >= 0 } {
       set silent 0
    }
    if { ! $silent } {
       puts "Next: $cmd"
       set dname [lindex $cmd 0]
       dbg
    }
}

# dbg_leave --
#    Callback for leavestep event
#
# Arguments:
#    cmd        Expanded command line
#    code       Return code
#    result     Result of the command
#    op         Operation
# Result:
#    None
#
#
proc ::Tracedebug::dbg_leave {cmd code result op} {
    global dname
    global silent
    if { ! $silent } {
       set dname [lindex $cmd 0]
       if { $code == 1 } {
          puts "ERROR: $result"
       } else {
          puts "Result: $result"
       }
    }
}

# printHelp --
#    Print short help information
#
# Arguments:
#    None
# Result:
#    None
# Side effect:
#    Prints help
#
proc ::Tracedebug::printHelp {} {
    puts "Tcl debugger:
    ?/h     - print help information
    b name  - set a breakpoint in procedure name
    c       - continue
    db ?name? - remove the (current) breakpoint
    e       - print error information
    l       - list the body of the current procedure
    lb      - list current breakpoints
    n       - next step (or return)
    p name  - print a global
    t       - print a stack trace
    v name ?cond? - set a trace on the global (possibly with a
              particular condition)"
}

# printStack --
#    Print the stack
#
# Arguments:
#    None
# Result:
#    None
# Side effect:
#    Prints stack
#
proc ::Tracedebug::printStack {} {
    set nolevels [info level]
    set level    [expr {$nolevels-3}]

    set number 1
    while { $level > 0 } {
       puts "$number: [info level $level]"
       incr number
       incr level  -1
    }
    puts "(global level)"
}

# printBody --
#    Print the body of the current routine
#
# Arguments:
#    None
# Result:
#    None
# Side effect:
#    Prints body
#
proc ::Tracedebug::printBody {} {
    set nolevels [info level]
    set level    [expr {$nolevels-3}]
    set procname [lindex [info level $level] 0]

    set number 1
    foreach line [split [info body $procname] "\n"] {
       puts "[format "%3d" $number]: $line"
       incr number
    }
}

# setBreak --
#    Set a breakpoint in the given routine
#
# Arguments:
#    None
# Result:
#    None
# Side effect:
#    Prints help
#
proc ::Tracedebug::setBreak {} {
    global breakpoints
    global dcmd

    if { [llength $dcmd] == 2 } {
       lappend breakpoints [lindex $dcmd 1]
    } else {
       lappend breakpoints [lindex [info level 3] 1]
    }
}

# readCmd --
#    Read the user's command
#
# Arguments:
#    None
# Result:
#    None
# Side effect:
#    Sets dcmd
#
proc ::Tracedebug::readCmd {} {
    global dcmd

    puts -nonewline ">> "
    flush stdout
    set dcmd [gets stdin]
}

# guiReadCmd --
#    Read the user's command via a simple GUI
#
# Arguments:
#    None
# Result:
#    None
# Side effect:
#    Sets go and dcmd
#
proc ::Tracedebug::guiReadCmd {} {
    global go
    global dcmd

    vwait ::Tracedebug::go
    puts ">> $dcmd"
    update
}

# createCmdWindow --
#    Create a toplevel window to enter commands
#
# Arguments:
#    None
# Result:
#    None
# Side effect:
#    Toplevel window created
#
proc ::Tracedebug::createCmdWindow {} {
    global go
    global dcmd

    toplevel .debug
    wm title .debug "Debug"

    label  .debug.label -text         "Debug:"
    entry  .debug.entry -textglobal ::Tracedebug::dcmd -width 15
    button .debug.go    -text "Go" -width 10 \
       -command {set ::Tracedebug::go   1}
    button .debug.next  -text "Next" -width 10 \
       -command {set ::Tracedebug::dcmd "n"
                 set ::Tracedebug::go   1}
    button .debug.cont  -text "Continue" -width 10 \
       -command {set ::Tracedebug::dcmd "c"
                 set ::Tracedebug::go   1}
    button .debug.quit  -text "Quit" -width 10 \
       -command {set ::Tracedebug::dcmd "q"
                 set ::Tracedebug::go   1}

    grid .debug.label .debug.entry - .debug.go   -sticky news
    grid .debug.next  .debug.cont  .debug.quit
}

# dbg --
#    Handle the user input in debug mode
#
# Arguments:
#    None
# Result:
#    None
# Side effect:
#    Whatever the user does
#
proc ::Tracedebug::dbg {} {
    global go
    global dcmd
    global dname
    global silent

    while {1} {
       #
       # Wait for the user to enter a command
       #
       readCmd

       #
       # Handle the command:
       # ?/h     - print help information
       # b name  - set breakpoint
       # c       - continue (remove this breakpoint)
       # e       - print error information
       # l       - list the body of the current procedure
       # n       - next step
       # p name  - print a global
       # t       - print a stack trace
       # v name ?cond? - set a trace on the variable (possibly with a
       #           particular condition)
       #
       switch -- [lindex $dcmd 0] {
       "?" -
       "h" {printHelp}
       "b" {setBreak }
       "c" {

           #trace remove execution $dname enterstep ::Tracedebug::dbg_enter
           #trace remove execution $dname leavestep ::Tracedebug::dbg_leave
           set silent 1 ;# Much TODO
           break
       }
       "e" {
            puts "Errorinfo: $::errorInfo"
            puts "Errorcode: $::errorCode"
       }
       "l" {printBody}
       ""  -
       "n" {
           break
       }
       "p" {
           catch {
              uplevel 2 "puts \$[lindex $dcmd 1]"
           }
       }
       "q" -
       "quit" {exit}
       "t" {printStack}
       "v" {traceVar}
       default {
           # Ignore for the moment
           puts "Unknown debug command: $dcmd"
       }
       }
    }
}

# main --
#    Get the thing going
#
trace add execution source enterstep ::Tracedebug::dbg_enter
trace add execution source leavestep ::Tracedebug::dbg_leave

#
# Create a console - if necessary
#
catch {
#console show
    rename ::Tracedebug::readCmd    {}
    rename ::Tracedebug::guiReadCmd ::Tracedebug::readCmd
#    ::Tracedebug::createCmdWindow
} msg
puts $msg

puts [trace info execution source]

puts $::argv
set argv0 [lindex $::argv 0]
set argv  [lrange $::argv 1 end]
source $argv0
