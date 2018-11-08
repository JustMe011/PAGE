##############################################################################
# $Id: toolbar.tcl,v 1.17 2005/12/05 06:53:15 kenparkerjr Exp $
#
# toolbar.tcl - widget toolbar
#
# Copyright (C) 1996-1998 Stewart Allen
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
#
proc vTcl:toolbar_create {args} {
    global vTcl
    set base .vTcl.toolbar
    set top $base
    if {[winfo exists $base]} {return}
    vTcl:toplevel $base -width 237 -height 110 -class vTcl
    wm transient $base .vTcl
    wm withdraw $base
    wm title $base "Widget Toolbar"
    wm geometry $base 150x500+110+110
    # wm minsize $base 237 40
    wm minsize $base 150 40
    wm overrideredirect $base 0
    catch {wm geometry .vTcl.toolbar $vTcl(geometry,.vTcl.toolbar)}
    wm deiconify $base
    update
    wm protocol .vTcl.toolbar WM_DELETE_WINDOW {
        vTcl:error "You cannot remove the toolbar"
    }

    #set sbands [kpwidgets::SBands .vTcl.toolbar.sbands]

    # This stuff is for putting the pointer button in toolbar. Never
    # figured out what it is good for; so out. 11/14/17
    # frame $base.tframe -relief raise -bd 1

    # image create photo pointer \
    #     -file [file join $vTcl(VTCL_HOME) images icon_pointer.gif]
    # button $base.tframe.b -bd 1 -image pointer -relief sunken -command "
    #     $base.tframe.b configure -relief sunken
    #     vTcl:raise_last_button $base.tframe.b
    #     vTcl:rebind_button_1
    #     vTcl:status Status
    #     set vTcl(x,lastButton) $base.tframe.b
    # " -padx 0 -pady 0 -highlightthickness 0

    # pack $base.tframe -side top -fill x

    # lappend vTcl(tool,list) $base.tframe.b
    # set vTcl(x,lastButton) $base.tframe.b

    # pack $base.tframe.b -side left
    # label $base.tframe.l -text "Pointer"
    # pack $base.tframe.l -side left
    #pack $sbands -fill both -expand yes -side bottom

    # From Attribute Editor
    # Create a scrolling canvas
    frame $top.c
    canvas $top.c.canvas -width 10 -height 10 \
        -yscrollcommand [list $top.c.yscroll set]
    scrollbar $top.c.yscroll -orient vertical \
        -command [list $top.c.canvas yview]
    pack $top.c.yscroll -side right -fill y
    pack $top.c.canvas -side left -fill both -expand true
    pack $top.c -side top -fill both -expand true

    # I am setting this up to show ONLY three groups of widgets -
    # core, tk, and scrolled.
    set c $top.c.canvas
    set vTcl(gui,toolbar,canvas) $c

    set f1 $c.f1; frame $f1       ; # tk widgets
        $c create window 0 0 -window $f1 -anchor nw -tag tk
    # set f2 $c.f2; frame $f2       ; # ttk widgets            TUE AM
    #     $c create window 0 0 -window $f2 -anchor nw -tag ttk
    # set f3 $c.f3; frame $f3       ; # enhanced widgets
    #     $c create window 0 0 -window $f3 -anchor nw -tag scroll

    # label $f1.l -text "Tk Widgets"  -relief raised -bg #aaaaaa -bd 1 -width 30 \
    #     -anchor center  -fg black
    #     pack $f1.l -side top -fill x
    # label $f2.l -text "Ttk Widgets" -relief raised -bg #aaaaaa -bd 1 -width 30 \
    #     -anchor center  -fg black
    #     pack $f2.l -side top -fill x
    # label $f3.l -text "Enhanced widgets" -relief raised -bg #aaaaaa -bd 1 \
    #     -width 30 \
    #     -anchor center  -fg black
    #     pack $f3.l -side top -fill x

    # pack $f1 -side top -fill x    TUE AM
    # pack $f2 -side top -fill x
    # pack $f3 -side top -fill x

    #ttk::style configure PyConsole.TSizegrip \
        -background $vTcl(pr,bgcolor) ;# 11/22/12
    #pack [ttk::sizegrip $sbands.sz -style "PyConsole.TSizegrip"] \
        -side right -anchor se
    #place [ttk::sizegrip $base.sz -style PyConsole.TSizegrip] \
        -in $base -relx 1.0 -rely 1.0 -anchor se

    catch {wm geometry $base $vTcl(geometry,$base)}
    vTcl:tool:recalc_canvas


    bind $top.c.canvas <Enter> \
        {vTcl:bind_mousewheel  $::vTcl(gui,tool).c.canvas}
    bind $top.c.canvas <Leave> \
        {vTcl:unbind_mousewheel $::vTcl(gui,tool).c.canvas}

    wm deiconify $base
}

proc vTcl:tool:recalc_canvas {} {
    global vTcl
    update
    set toolbar .vTcl.toolbar
    set c  $vTcl(gui,toolbar,canvas)
    if {![winfo exists $toolbar]} { return }
    set f1 $c.f1                              ; # Tk Widget Frame
    set f2 $c.f2                              ; # Ttk Widget Frame
    set f3 $c.f3                              ; # Enhanced Widget Frame

    #tkwait visibility $c
    # $c coords attr 0 [winfo height $f1]                 TUE AM
    # $c coords geom 0 [expr [winfo height $f1] + [winfo height $f2]]
    # set w [winfo width $f3]
    # set h [expr [winfo height $f1] + \
    #             [winfo height $f2] + \
    #             [winfo height $f3] ]
    set w [winfo width $f1]
    set h [winfo height $f1]
    $c configure -scrollregion "0 0 $w $h"
    #$c configure -yscrollincrement 20

    set geom [wm geometry .vTcl.toolbar]
    set g_split [split $geom x]
    set new_geom ${w}x[lrange $g_split 1 1]
    catch {wm geometry .vTcl.toolbar $new_geom}

    #wm minsize .vTcl.ae $w 200

}

proc vTcl:toolbar_header {band label} {
    # We call this function three times once each from lib_core.tcl,
    # lib_ttk.tcl, and lib_custom.tcl.  The first time it's called it
    # creates the toolbar.
    # Put in a label which contain the header label.
    global vTcl
    if {![winfo exists $.vTcl.toolbar]} { vTcl:toolbar_create }
    set c  $vTcl(gui,toolbar,canvas)
    # switch $band {         TUE AM
    #     core {
    #         set frame $c.f1     ; # Tk Widget Frame
    #     }

    #     ttk {
    #         set frame $c.f2     ; # Ttk Widget Frame
    #     }
    #     scrolled {
    #         set frame $c.f3     ; # Enhanced Widget Frame
    #     }
    # }
    set frame $c.f1
    set base $frame

    set ll [vTcl:new_widget_name l $base]
    label $ll -text $label -background #aaaaaa
    pack $ll -fill x

}

proc vTcl:toolbar_add {band_name class name image cmd_add } {
    # Rozen, I decided to have the button include the descriptive text
    # rather than put it into an adjacent label.  This makes the
    # button a bigger target for the mounse and was really very easy
    # to do; just add three options to the button statement and remove
    # the label stuff.  Really got tired of the previous behavior.
    global vTcl
    if {![winfo exists .vTcl.toolbar]} { vTcl:toolbar_create }
    set c  $vTcl(gui,toolbar,canvas)
    # switch $band_name {            TUE AM
    #     core {
    #         set frame $c.f1     ; # Tk Widget Frame
    #     }

    #     ttk {
    #         set frame $c.f2     ; # Ttk Widget Frame
    #     }
    #     scrolled {
    #         set frame $c.f3     ; # Enhanced Widget Frame
    #     }
    # }
    set frame $c.f1
    set base $frame   ;# base is the frame containing all the buttons.
    set f [vTcl:new_widget_name tb $base]
    ensureImage $image
    frame $f
    pack $f -side top -fill x
    append tpart "  " $class "  "
    #set tk_strictMotif 0                 ;# Rozen
    # I don't know why I cannot add '-activebackground plum'. Rozen
    button $f.b -bd 1 -image $image -padx 0 -pady 0 -highlightthickness 0 \
        -text $tpart  -compound left  -relief flat
    bind $f.b <ButtonRelease-1> \
       "vTcl:new_widget \$vTcl(pr,autoplace) $class $f.b \"$cmd_add\""
    bind $f.b <Shift-ButtonRelease-1> \
    "vTcl:new_widget 1 $class $f.b \"$cmd_add\""
    vTcl:set_balloon $f.b $name
    lappend vTcl(tool,list) $f.b
    pack $f.b -side left
    #label $f.l -text $class                ;# Rozen
    #vTcl:set_balloon $f.l $name            ;# Rozen
    #pack $f.l -side left                   ;# Rozen
}

namespace eval ::vTcl {
    proc toolbar_header { band_name title } {
        if {![winfo exists $.vTcl.toolbar]} { vTcl:toolbar_create }
        set base .vTcl.toolbar.sbands
        $base new_frame $band_name $title
    }
}

proc vTclWindow.vTcl.toolbar {args} {
    vTcl:toolbar_reflow
}

proc vTcl:toolbar_reflow {{base .vTcl.toolbar}} {
    # This is where the toolbar is created. It is called from page.tcl.
    # page.tcl also has the deiconify statement which makes the
    # toolbar visible.
    global vTcl
    set existed [winfo exists $base]
    if {!$existed} { vTcl:toolbar_create }
    wm resizable $base 1 1
    update

    vTcl:setup_vTcl:bind $base
}

proc vTcl:config_toolbar_canvas {} {
return
    set canvas .vTcl.toolbar.c.canvas
    set h [winfo height $canvas]
    set w [winfo width $canvas]
    set width [winfo reqwidth $canvas]
    set height [winfo reqheight $canvas]
    $canvas configure -scrollregion "0 0 $w $h"
}


