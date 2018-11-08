##############################################################################
# apply.tcl - procedures for displaying callbacks tied to a particular widget.
#
# Copyright (C) 2018 Donald Rozenberg
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

##############################################################################

# This module implements the stash and apply function.
proc vTcl:stash_config {} {
    # Arrived here from the widget context menu.
    # We read, store, and display the configuration of the selected
    # widget.
    vTclWindow.vTcl.apply
}

proc vTcl:apply_config {} {
}


proc vTclWindow.vTcl.apply {args} {
    global vTcl
    set base .vTcl.apply
    set top $base
    if { [winfo exists $base] } {
        wm deiconify $base; return }
    toplevel $base -class vTcl
    wm transient $base .vTcl
    wm withdraw $base
    wm focusmodel $base passive
    wm geometry $base 350x200+100+200
    #wm maxsize $base 1137 870
    wm minsize $base 200 100
    wm resizable $base 1 1
    wm overrideredirect $base 0
    wm title $base "Widget Configuration"
    wm protocol $base WM_DELETE_WINDOW {vTcl:callback:show 0}

    # Create a frame for buttons,
    set f [frame $top.buttons -bd 4]
    button $f.quit -text Dismiss -command "destroy $base"
    button $f.stash -text Stash -command vTcl:stash
    button $f.apply -text Apply -command vTcl:apply
    pack $f.quit $f.stash $f.apply -side right
    pack $f -side top -fill x

    # Create a scrolling canvas
    frame $top.c
    canvas $top.c.canvas -width 10 -height 10 \
        -yscrollcommand [list $top.c.yscroll set]
    scrollbar $top.c.yscroll -orient vertical \
        -command [list $top.c.canvas yview]
    pack $top.c.yscroll -side right -fill y
    pack $top.c.canvas -side left -fill both -expand true
    pack $top.c -side top -fill both -expand true

    catch {wm geometry $vTcl(gui,apply) $vTcl(geometry,$vTcl(gui,apply))}

    bind $top.c.canvas <Enter> \
        {vTcl:bind_mousewheel  $::vTcl(gui,apply).c.canvas}
    bind $top.c.canvas <Leave> \
        {vTcl:unbind_mousewheel $::vTcl(gui,apply).c.canvas}

    vTcl:setup_vTcl:bind $base      ;# Allows <Control-Q> to exit PAGE
    update idletasks
    wm deiconify $vTcl(gui,apply)

    Scrolled_EntrySet $top.c.canvas
}

proc Scrolled_EntrySet { canvas } {
    # Create one frame to hold everything
    # and position it on the canvas
    global vTcl
    set f [frame $canvas.f -bd 0]
    $canvas create window 0 0 -anchor nw -window $f
    # Create and grid the labeled entries
# dmsg returning
# return
    set i 0
    set widget $vTcl(w,widget)
    if {$widget == ""} {
        return
    } ;# end if
    set opt [$widget configure]
    foreach op $opt {
        foreach {o x y d v} $op {}
        set v [string trim $v]
        if {$d == $v} {
            continue   ;# If value == default value bail.
        }
        label $f.label$i -text $o
        label $f.value$i -text $v
        checkbutton $f.check$i -pady 0 -variable ck$i

        grid $f.label$i $f.value$i $f.check$i
        grid $f.label$i -sticky w
        grid $f.value$i -sticky we
        grid $f.check$i -sticky news

        incr i
    }

    set child $f.value0

    # Wait for the window to become visible and then
    # set up the scroll region based on
    # the requested size of the frame, and set
    # the scroll increment based on the
    # requested height of the widgets
    tkwait visibility $child
    set bbox [grid bbox $f 0 0]
    set incr [lindex $bbox 3]
    set width [winfo reqwidth $f]
    set height [winfo reqheight $f]
    $canvas config -scrollregion "0 0 $width $height"
    $canvas config -yscrollincrement $incr
    set max [llength $opt]
    if {$max > 10} {
        set max 10
    }
    set height [expr $incr * $max]
    $canvas config -width $width -height $height
}



proc shiftwheelEvent { x y delta canvas {os ""}} {
    set act 0
    # Make sure we've got a vertical scrollbar for this widget
    if {[catch "$canvas cget -yscrollcommand" cmd]} return
    if {$canvas == ""} return
    if {$os == "MS"} {
        # I am assuming that we are running under MS Windows.
        # if {$cmd != ""} {
        #     # Find out the scrollbar widget we're using
        #     set scroller [lindex $cmd 0]

        #     # Make sure we act
        #     set act 1
        # }

        # Now we know we have to process the wheel mouse event
        set xy [$canvas xview]
        set factor [expr [lindex $xy 1]-[lindex $xy 0]]
        # Make sure we activate the scrollbar's command
        set cmd "$canvas xview scroll [expr -int($delta/(120*$factor))] units"
    } else {
        # we are on Linux
        set cmd "$canvas xview scroll $delta units"

    }
    eval $cmd
}

proc wheelEvent { x y delta canvas {os ""}} {
    set act 0
    # Make sure we've got a vertical scrollbar for this widget
    if {[catch "$canvas cget -yscrollcommand" cmd]} return
    if {$canvas == ""} return
    if {$os == "MS"} {
        # I am assuming that we are running under MS Windows.
        # if {$cmd != ""} {
        #     # Find out the scrollbar widget we're using
        #     set scroller [lindex $cmd 0]

        #     # Make sure we act
        #     set act 1
        # }

        # Now we know we have to process the wheel mouse event
        set xy [$canvas xview]
        set factor [expr [lindex $xy 1]-[lindex $xy 0]]
        # Make sure we activate the scrollbar's command
        set cmd "$canvas yview scroll [expr -int($delta/(120*$factor))] units"
    } else {
        # we are on Linux
        set cmd "$canvas yview scroll $delta units"

    }
    eval $cmd
}

proc vTcl:bind_mousewheel {widget} {
    bind all <MouseWheel> "+wheelEvent %X %Y %D $widget MS"
    bind all <Button-4> "+wheelEvent %X %Y -1 $widget"
    bind all <Button-5> "+wheelEvent %X %Y 1 $widget"

    bind all <Shift-MouseWheel> "+shiftwheelEvent %X %Y %D $widget MS"
    bind all <Shift-Button-4> "+shiftwheelEvent %X %Y -1 $widget"
    bind all <Shift-Button-5> "+shiftwheelEvent %X %Y 1 $widget"
}


proc vTcl:unbind_mousewheel {widget} {
    bind all <MouseWheel> { }
    bind all <Button-4> { }
    bind all <Button-5> { }

    bind all <Shift-MouseWheel> { }
    bind all <Shift-Button-4> { }
    bind all <Shift-Button-5> { }
}

