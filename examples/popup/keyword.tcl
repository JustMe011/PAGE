#############################################################################
# Generated by PAGE version 4.18b
#  in conjunction with Tcl version 8.6
#  Oct 03, 2018 10:20:53 AM PDT  platform: Linux
set vTcl(timestamp) ""


if {!$vTcl(borrow)} {

vTcl:font:add_GUI_font font10 \
"-family {DejaVu Sans} -size 14 -weight normal -slant roman -underline 0 -overstrike 0"
vTcl:font:add_GUI_font font9 \
"-family {DejaVu Sans Mono} -size 14 -weight normal -slant roman -underline 0 -overstrike 0"
set vTcl(actual_gui_bg) wheat
set vTcl(actual_gui_fg) #000000
set vTcl(actual_gui_menu_bg) wheat
set vTcl(actual_gui_menu_fg) #000000
set vTcl(complement_color) #b2c9f4
set vTcl(analog_color_p) #eaf4b2
set vTcl(analog_color_m) #f4bcb2
set vTcl(active_fg) #111111
set vTcl(actual_gui_menu_active_bg)  #f4bcb2
set vTcl(active_menu_fg) #000000
}

#############################################################################
# vTcl Code to Load User Fonts

vTcl:font:add_font \
    "-family {DejaVu Sans} -size 16 -weight normal -slant roman -underline 0 -overstrike 0" \
    user \
    vTcl:font11
vTcl:font:add_font \
    "-family {DejaVu Sans} -size 12 -weight normal -slant roman -underline 0 -overstrike 0" \
    user \
    vTcl:font12
#################################
#LIBRARY PROCEDURES
#


if {[info exists vTcl(sourcing)]} {

proc vTcl:project:info {} {
    set base .top36
    global vTcl
    set base $vTcl(btop)
    if {$base == ""} {
        set base .top36
    }
    namespace eval ::widgets::$base {
        set dflt,origin 0
        set runvisible 1
    }
    namespace eval ::widgets_bindings {
        set tagslist _TopLevel
    }
    namespace eval ::vTcl::modules::main {
        set procs {
        }
        set compounds {
        }
        set projectType single
    }
}
}

#################################
# GENERATED GUI PROCEDURES
#
    ttk::style configure Menu -background wheat
    ttk::style configure Menu -foreground #000000
    ttk::style configure Menu -font font9
    menu .pop39 \
        -activebackground {#ffffcd} -activeforeground black \
        -background {#dda0dd} -font TkMenuFont -foreground black -tearoff 1 
    vTcl:DefineAlias ".pop39" "Popupmenu1" vTcl:WidgetProc "" 1
    .pop39 add command \
        -activebackground {#f4bcb2} -activeforeground {#000000} \
        -background wheat -command this \
        -font [vTcl:font:getFontFromDescr "-family {DejaVu Sans} -size 12 -weight normal -slant roman -underline 0 -overstrike 0"] \
        -foreground {#000000} -label This 
    .pop39 add command \
        -activebackground {#f4bcb2} -activeforeground {#000000} \
        -background wheat -command that \
        -font [vTcl:font:getFontFromDescr "-family {DejaVu Sans} -size 12 -weight normal -slant roman -underline 0 -overstrike 0"] \
        -foreground {#000000} -label That 
    .pop39 add separator \
        -background wheat 
    .pop39 add cascade \
        -menu .pop39.men40 -activebackground {#f4bcb2} \
        -activeforeground {#111111} -background wheat \
        -font [vTcl:font:getFontFromDescr "-family {DejaVu Sans} -size 12 -weight normal -slant roman -underline 0 -overstrike 0"] \
        -foreground {#000000} -label Also 
    set site_2_0 "."
    menu .pop39.men40 \
        -activebackground {#ffffcd} -activeforeground black -background wheat \
        -font TkMenuFont -foreground black -tearoff 0 
    .pop39.men40 add command \
        -activebackground {#f4bcb2} -activeforeground {#000000} \
        -background wheat -command then \
        -font [vTcl:font:getFontFromDescr "-family {DejaVu Sans} -size 12 -weight normal -slant roman -underline 0 -overstrike 0"] \
        -foreground {#000000} -label Then 
    .pop39.men40 add command \
        -activebackground {#f4bcb2} -activeforeground {#000000} \
        -background wheat -command there \
        -font [vTcl:font:getFontFromDescr "-family {DejaVu Sans} -size 12 -weight normal -slant roman -underline 0 -overstrike 0"] \
        -foreground {#000000} -label There 
    .pop39 add command \
        -activebackground {#f4bcb2} -activeforeground {#000000} \
        -background wheat -command {#lambda: which(kwargs['which'])} \
        -font [vTcl:font:getFontFromDescr "-family {DejaVu Sans} -size 14 -weight normal -slant roman -underline 0 -overstrike 0"] \
        -foreground {#000000} -label Which 
    menu .pop36 \
        -activebackground {#ffffcd} -activeforeground black -background wheat \
        -font TkMenuFont -foreground black -tearoff 1 
    vTcl:DefineAlias ".pop36" "Popupmenu2" vTcl:WidgetProc "" 1
    .pop36 add command \
        -activebackground {#f4bcb2} -activeforeground {#000000} \
        -background plum -command how \
        -font [vTcl:font:getFontFromDescr "-family {DejaVu Sans Mono} -size 14 -weight normal -slant roman -underline 0 -overstrike 0"] \
        -foreground {#000000} -label How 
    .pop36 add command \
        -activebackground {#f4bcb2} -activeforeground {#000000} \
        -background plum -command now \
        -font [vTcl:font:getFontFromDescr "-family {DejaVu Sans Mono} -size 14 -weight normal -slant roman -underline 0 -overstrike 0"] \
        -foreground {#000000} -label Now 
    .pop36 add separator \
        -background plum 
    .pop36 add cascade \
        -menu .pop36.men37 -activebackground {#f4bcb2} \
        -activeforeground {#111111} -background plum \
        -font [vTcl:font:getFontFromDescr "-family {DejaVu Sans Mono} -size 14 -weight normal -slant roman -underline 0 -overstrike 0"] \
        -foreground {#000000} -label BrownCow 
    set site_2_0 "."
    menu .pop36.men37 \
        -activebackground {#ffffcd} -activeforeground black -background wheat \
        -font TkMenuFont -foreground black -tearoff 0 
    .pop36.men37 add command \
        -activebackground {#f4bcb2} -activeforeground {#000000} \
        -background plum -command moo \
        -font [vTcl:font:getFontFromDescr "-family {DejaVu Sans Mono} -size 14 -weight normal -slant roman -underline 0 -overstrike 0"] \
        -foreground {#000000} -label Moo 

proc vTclWindow.top36 {base} {
    if {$base == ""} {
        set base .top36
    }
    if {[winfo exists $base]} {
        wm deiconify $base; return
    }
    set top $base
    ###################
    # CREATING WIDGETS
    ###################
    vTcl::widgets::core::toplevel::createCmd $top -class Toplevel \
        -menu "$top.m37" -background wheat -highlightbackground wheat \
        -highlightcolor black 
    wm focusmodel $top passive
    wm geometry $top 600x450+650+150
    update
    # set in toplevel.wgt.
    global vTcl
    global img_list
    set vTcl(save,dflt,origin) 0
    wm maxsize $top 1905 1170
    wm minsize $top 1 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm deiconify $top
    wm title $top "Keyword Parameters"
    vTcl:DefineAlias "$top" "Toplevel1" vTcl:Toplevel:WidgetProc "" 1
    button $top.but37 \
        -activebackground {#f4bcb2} -activeforeground black -background wheat \
        -disabledforeground {#b8a786} -font $::vTcl(fonts,vTcl:font12,object) \
        -foreground {#000000} -highlightbackground wheat \
        -highlightcolor black -text Button1 
    vTcl:DefineAlias "$top.but37" "Button1" vTcl:WidgetProc "Toplevel1" 1
    bind $top.but37 <Button-3> {
        lambda e: popup1(e,which=1)
    }
    button $top.but38 \
        -activebackground {#f4bcb2} -activeforeground black -background wheat \
        -disabledforeground {#b8a786} -font $::vTcl(fonts,vTcl:font12,object) \
        -foreground {#000000} -highlightbackground wheat \
        -highlightcolor black -text Button2 
    vTcl:DefineAlias "$top.but38" "Button2" vTcl:WidgetProc "Toplevel1" 1
    bind $top.but38 <Button-3> {
        lambda e: popup2(e)
    }
    set site_3_0 $top.m37
    menu $site_3_0 \
        -activebackground {#f4bcb2} -activeforeground {#000000} \
        -background wheat -font $::vTcl(fonts,vTcl:font11,object) \
        -foreground {#000000} -tearoff 0 
    $site_3_0 add command \
        -activebackground {#f4bcb2} -activeforeground {#000000} \
        -background wheat -command {#quit} \
        -font [vTcl:font:getFontFromDescr "-family {DejaVu Sans} -size 16 -weight normal -slant roman -underline 0 -overstrike 0"] \
        -foreground {#000000} -label Quit 
    ###################
    # SETTING GEOMETRY
    ###################
    place $top.but37 \
        -in $top -x 140 -y 170 -anchor nw -bordermode ignore 
    place $top.but38 \
        -in $top -x 410 -y 170 -anchor nw -bordermode ignore 

    vTcl:FireEvent $base <<Ready>>
}

#############################################################################
## Binding tag:  _TopLevel

bind "_TopLevel" <<Create>> {
    if {![info exists _topcount]} {set _topcount 0}; incr _topcount
}
bind "_TopLevel" <<DeleteWindow>> {
    if {[set ::%W::_modal]} {
                vTcl:Toplevel:WidgetProc %W endmodal
            } else {
                destroy %W; if {$_topcount == 0} {exit}
            }
}
bind "_TopLevel" <Destroy> {
    if {[winfo toplevel %W] == "%W"} {incr _topcount -1}
}

set btop ""
if {$vTcl(borrow)} {
    set btop .bor[expr int([expr rand() * 100])]
    while {[lsearch $btop $vTcl(tops)] != -1} {
        set btop .bor[expr int([expr rand() * 100])]
    }
}
set vTcl(btop) $btop
Window show .
Window show .top36 $btop
if {$vTcl(borrow)} {
    $btop configure -background plum
}

