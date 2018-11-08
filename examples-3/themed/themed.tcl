#############################################################################
# Generated by PAGE version 4.8
# in conjunction with Tcl version 8.6
set vTcl(timestamp) ""


set vTcl(actual_gui_bg) wheat
set vTcl(actual_gui_fg) #000000
set vTcl(actual_gui_menu_bg) wheat
set vTcl(actual_gui_menu_fg) #000000
set vTcl(complement_color) #b2c9f4
set vTcl(analog_color_p) #eaf4b2
set vTcl(analog_color_m) #f4bcb2
set vTcl(active_fg) #111111
set vTcl(actual_gui_menu_active_bg)  #d8d8d8
set vTcl(active_menu_fg) #000000
#################################
#LIBRARY PROCEDURES
#


if {[info exists vTcl(sourcing)]} {

proc vTcl:project:info {} {
    set base .top34
    namespace eval ::widgets::$base {
        set dflt,origin 0
        set runvisible 1
    }
    set site_4_0 .top34.tNo43.pg0 
    set site_4_1 .top34.tNo43.pg1 
    set site_4_0 .top34.tPa44.f1 
    set site_4_1 .top34.tPa44.f2 
    set site_4_0 .top34.tPa45.f1 
    set site_4_1 .top34.tPa45.f2 
    set site_3_0 $base.scr50
    set site_3_0 $base.scr51
    set site_3_0 $base.scr52

    #Updating ttreeview attributes
    .top34.scr52.01 configure\
        -columns  Col1\
        -height  4

    #heading options.
    .top34.scr52.01 heading Col1 \
             -text "Col1" \
             -anchor center
    #heading options.
    .top34.scr52.01 heading #0 \
             -text "Tree" \
             -anchor center
    #column options.
    .top34.scr52.01 column Col1 \
             -width 209 \
             -minwidth 20 \
             -stretch 1 \
             -anchor w
    #column options.
    .top34.scr52.01 column #0 \
             -width 209 \
             -minwidth 20 \
             -stretch 1 \
             -anchor w
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
# USER DEFINED PROCEDURES
#

#################################
# GENERATED GUI PROCEDURES
#

proc vTclWindow.top34 {base} {
    if {$base == ""} {
        set base .top34
    }
    if {[winfo exists $base]} {
        wm deiconify $base; return
    }
    set top $base
    ###################
    # CREATING WIDGETS
    ###################
    vTcl::widgets::core::toplevel::createCmd $top -class Toplevel \
        -background wheat -highlightbackground wheat -highlightcolor black 
    wm focusmodel $top passive
    wm geometry $top 600x881+650+150
    update
    # set in toplevel.wgt.
    global vTcl
    set vTcl(save,dflt,origin) 0
    wm maxsize $top 1905 1170
    wm minsize $top 1 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm deiconify $top
    wm title $top "New Toplevel 1"
    vTcl:DefineAlias "$top" "Toplevel1" vTcl:Toplevel:WidgetProc "" 1
    ttk::style configure TButton -background wheat
    ttk::style configure TButton -foreground #000000
    ttk::style configure TButton -font font1
    ttk::style configure TButton -background wheat
    ttk::style configure TButton -foreground #000000
    ttk::style configure TButton -font font1
    ttk::button $top.tBu35 \
        -takefocus {} -text Tbutton 
    vTcl:DefineAlias "$top.tBu35" "TButton1" vTcl:WidgetProc "Toplevel1" 1
    ttk::style configure TCheckbutton -background wheat
    ttk::style configure TCheckbutton -foreground #000000
    ttk::style configure TCheckbutton -font font1
    ttk::checkbutton $top.tCh36 \
        -variable tch36 -takefocus {} -text Tcheck 
    vTcl:DefineAlias "$top.tCh36" "TCheckbutton1" vTcl:WidgetProc "Toplevel1" 1
    ttk::combobox $top.tCo37 \
        -textvariable combobox -foreground {} -background {} -takefocus {} 
    vTcl:DefineAlias "$top.tCo37" "TCombobox1" vTcl:WidgetProc "Toplevel1" 1
    ttk::entry $top.tEn38 \
        -foreground {} -background {} -takefocus {} -cursor xterm 
    vTcl:DefineAlias "$top.tEn38" "TEntry1" vTcl:WidgetProc "Toplevel1" 1
    ttk::style configure TFrame -background wheat
    ttk::frame $top.tFr39 \
        -borderwidth 2 -relief groove -width 125 -height 75 
    vTcl:DefineAlias "$top.tFr39" "TFrame1" vTcl:WidgetProc "Toplevel1" 1
    ttk::style configure TLabelframe.Label -background wheat
    ttk::style configure TLabelframe.Label -foreground #000000
    ttk::style configure TLabelframe.Label -font font1
    ttk::style configure TLabelframe -background wheat
    ttk::labelframe $top.tLa41 \
        -text Tlabelframe -width 150 -height 75 
    vTcl:DefineAlias "$top.tLa41" "TLabelframe1" vTcl:WidgetProc "Toplevel1" 1
    ttk::style configure TNotebook -background wheat
    ttk::style configure TNotebook.Tab -background wheat
    ttk::style configure TNotebook.Tab -foreground #000000
    ttk::style configure TNotebook.Tab -font font1
    ttk::style map TNotebook.Tab -background [list disabled wheat selected #b2c9f4]
    ttk::notebook $top.tNo43 \
        -width 300 -height 200 -takefocus {} 
    vTcl:DefineAlias "$top.tNo43" "TNotebook1" vTcl:WidgetProc "Toplevel1" 1
    frame .top34.tNo43.pg0 -background wheat
    $top.tNo43 add .top34.tNo43.pg0 \
        -padding 0 -sticky nsew -state normal -text {Page 1} -image {} \
        -compound none -underline -1 
    set site_4_0  $top.tNo43.pg0
    frame .top34.tNo43.pg1 -background wheat
    $top.tNo43 add .top34.tNo43.pg1 \
        -padding 0 -sticky nsew -state normal -text {Page 2} -image {} \
        -compound none -underline -1 
    set site_4_1  $top.tNo43.pg1
    ttk::style configure TPanedwindow -background wheat
    ttk::style configure TPanedwindow.Label -background wheat
    ttk::style configure TPanedwindow.Label -foreground #000000
    ttk::style configure TPanedwindow.Label -font font1
    ttk::panedwindow $top.tPa44 \
        -orient horizontal -width 200 -height 200 
    vTcl:DefineAlias "$top.tPa44" "TPanedwindow1" vTcl:WidgetProc "Toplevel1" 1
    ttk::style configure TLabelframe.Label -background wheat
    ttk::style configure TLabelframe.Label -foreground #000000
    ttk::style configure TLabelframe.Label -font font1
    ttk::style configure TLabelframe -background wheat
    ttk::labelframe $top.tPa44.f1 \
        -text {Pane 1} -width 75 -height 200 
    set site_4_0 $top.tPa44.f1
    $top.tPa44 add $top.tPa44.f1 
        
    ttk::style configure TLabelframe.Label -background wheat
    ttk::style configure TLabelframe.Label -foreground #000000
    ttk::style configure TLabelframe.Label -font font1
    ttk::style configure TLabelframe -background wheat
    ttk::labelframe $top.tPa44.f2 \
        -text {Pane 2} -width 125 -height 200 
    set site_4_1 $top.tPa44.f2
    $top.tPa44 add $top.tPa44.f2 
        
    ttk::style configure TPanedwindow -background wheat
    ttk::style configure TPanedwindow.Label -background wheat
    ttk::style configure TPanedwindow.Label -foreground #000000
    ttk::style configure TPanedwindow.Label -font font1
    ttk::panedwindow $top.tPa45 \
        -width 200 -height 200 
    vTcl:DefineAlias "$top.tPa45" "TPanedwindow2" vTcl:WidgetProc "Toplevel1" 1
    ttk::style configure TLabelframe.Label -background wheat
    ttk::style configure TLabelframe.Label -foreground #000000
    ttk::style configure TLabelframe.Label -font font1
    ttk::style configure TLabelframe -background wheat
    ttk::labelframe $top.tPa45.f1 \
        -text {Pane 1} -width 200 -height 75 
    set site_4_0 $top.tPa45.f1
    $top.tPa45 add $top.tPa45.f1 
        
    ttk::style configure TLabelframe.Label -background wheat
    ttk::style configure TLabelframe.Label -foreground #000000
    ttk::style configure TLabelframe.Label -font font1
    ttk::style configure TLabelframe -background wheat
    ttk::labelframe $top.tPa45.f2 \
        -text {Pane 2} -width 200 -height 125 
    set site_4_1 $top.tPa45.f2
    $top.tPa45 add $top.tPa45.f2 
        
    ttk::progressbar $top.tPr46
    vTcl:DefineAlias "$top.tPr46" "TProgressbar1" vTcl:WidgetProc "Toplevel1" 1
    ttk::style configure TRadiobutton -background wheat
    ttk::style configure TRadiobutton -foreground #000000
    ttk::style configure TRadiobutton -font font1
    ttk::radiobutton $top.tRa47 \
        -variable {} -takefocus {} -text TRadio 
    vTcl:DefineAlias "$top.tRa47" "TRadiobutton1" vTcl:WidgetProc "Toplevel1" 1
    ttk::scale $top.tSc48 \
        -orient vertical -takefocus {} 
    vTcl:DefineAlias "$top.tSc48" "TScale1" vTcl:WidgetProc "Toplevel1" 1
    ttk::scale $top.tSc49 \
        -takefocus {} 
    vTcl:DefineAlias "$top.tSc49" "TScale2" vTcl:WidgetProc "Toplevel1" 1
    vTcl::widgets::ttk::scrolledlistbox::CreateCmd $top.scr50 \
        -background {#f5deb3} -height 75 -highlightbackground {#f5deb3} \
        -highlightcolor black -width 125 
    vTcl:DefineAlias "$top.scr50" "Scrolledlistbox1" vTcl:WidgetProc "Toplevel1" 1

    $top.scr50.01 configure -background white \
        -disabledforeground #b8a786 \
        -font font11 \
        -foreground black \
        -height 3 \
        -highlightbackground wheat \
        -highlightcolor wheat \
        -selectbackground #c4c4c4 \
        -selectforeground black \
        -width 10
    vTcl::widgets::ttk::scrolledtext::CreateCmd $top.scr51 \
        -background {#f5deb3} -height 75 -highlightbackground {#f5deb3} \
        -highlightcolor black -width 125 
    vTcl:DefineAlias "$top.scr51" "Scrolledtext1" vTcl:WidgetProc "Toplevel1" 1

    $top.scr51.01 configure -background white \
        -font font10 \
        -foreground black \
        -height 3 \
        -highlightbackground wheat \
        -highlightcolor black \
        -insertbackground black \
        -insertborderwidth 3 \
        -selectbackground #c4c4c4 \
        -selectforeground black \
        -width 10 \
        -wrap none
    ttk::style configure Treeview.Heading -background #b2c9f4
    ttk::style configure Treeview.Heading -font font1
    vTcl::widgets::ttk::scrolledtreeview::CreateCmd $top.scr52 \
        -background {#f5deb3} -height 15 -highlightbackground {#f5deb3} \
        -highlightcolor black -width 30 
    vTcl:DefineAlias "$top.scr52" "Scrolledtreeview1" vTcl:WidgetProc "Toplevel1" 1
    ttk::style configure TSizegrip -background wheat
    vTcl::widgets::ttk::sizegrip::CreateCmd $top.tSi53 \
        -cursor bottom_right_corner 
    vTcl:DefineAlias "$top.tSi53" "TSizegrip1" vTcl:WidgetProc "Toplevel1" 1
    ttk::label $top.tLa34 \
        -background wheat -foreground {#000000} -relief flat -text Tlabel 
    vTcl:DefineAlias "$top.tLa34" "TLabel1" vTcl:WidgetProc "Toplevel1" 1
    ###################
    # SETTING GEOMETRY
    ###################
    place $top.tBu35 \
        -in $top -x 10 -y 20 -anchor nw -bordermode ignore 
    place $top.tCh36 \
        -in $top -x 20 -y 70 -anchor nw -bordermode ignore 
    place $top.tCo37 \
        -in $top -x 20 -y 120 -anchor nw -bordermode ignore 
    place $top.tEn38 \
        -in $top -x 30 -y 170 -anchor nw -bordermode ignore 
    place $top.tFr39 \
        -in $top -x 30 -y 210 -anchor nw -bordermode ignore 
    place $top.tLa41 \
        -in $top -x 30 -y 340 -anchor nw -bordermode ignore 
    place $top.tNo43 \
        -in $top -x 270 -y 70 -anchor nw -bordermode ignore 
    place $top.tPa44 \
        -in $top -x 270 -y 340 -anchor nw -bordermode ignore 
    place $top.tPa45 \
        -in $top -x 30 -y 440 -anchor nw -bordermode ignore 
    place $top.tPr46 \
        -in $top -x 270 -y 560 -anchor nw -bordermode ignore 
    place $top.tRa47 \
        -in $top -x 440 -y 560 -width 96 -relwidth 0 -height 23 -relheight 0 \
        -anchor nw -bordermode ignore 
    place $top.tSc48 \
        -in $top -x 510 -y 360 -anchor nw -bordermode ignore 
    place $top.tSc49 \
        -in $top -x 270 -y 600 -anchor nw -bordermode ignore 
    place $top.scr50 \
        -in $top -x 30 -y 670 -anchor nw -bordermode ignore 
    place $top.scr51 \
        -in $top -x 220 -y 670 -anchor nw -bordermode ignore 
    place $top.scr52 \
        -in $top -x 80 -y 760 -width 420 -anchor nw -bordermode ignore 
    place $top.tSi53 \
        -in $top -x 0 -relx 1 -y 0 -rely 1 -anchor se -bordermode inside 
    place $top.tLa34 \
        -in $top -x 30 -y 300 -anchor nw -bordermode ignore 

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

Window show .
Window show .top34

