##############################################################################
# $Id: file.tcl,v 1.1 2013/11/12 18:46:08 rozen Exp rozen $
#
# file.tcl - procedures to open, close and save applications
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
# This file has been modified by:
#   Christian Gavin
#   Damon Courtney
#
##############################################################################

# Rozen.  I want to get rid of the init proc if I can. It will only
# goof up the running of the python program by permitting a clash of
# names. Looking at the generated tcl code, it appears to have no
# function other than providing a place holder for tcl code the user
# may specify. However, I never expect to actually execute the tcl
# version.  This will take a bit of thought and I suspect something of
# a hassle. By the same token, I will also look at "main".

# vTcl:save
# vTcl:save2
# vTcl:save_prefs
# vTcl:borrow
# vTcl:open

proc vTcl:new {} {
    global vTcl
    # if { [vTcl:close] == -1 } { return }

    ## Run through the Project Wizard to setup the new project.
    Window show .vTcl.newProjectWizard

    tkwait variable ::NewWizard::Done

    set vTcl(mode) EDIT

    vTcl:setup_bind_tree .
    vTcl:update_top_list
    vTcl:update_proc_list

    if {[lempty $::NewWizard::ProjectFile]} {
        set vTcl(project,name) "unknown.tcl"
    } else {
        set vTcl(project,name) \
            [file join $::NewWizard::ProjectFolder $::NewWizard::ProjectFile]
        set vTcl(project,file) $vTcl(project,name)
    }

    wm title $vTcl(gui,main) "PAGE - $vTcl(project,name)"

    set w [vTcl:auto_place_widget Toplevel]
    if {$w != ""} { wm geometry $w $vTcl(pr,geom_new) }
}

proc vTcl:file_source {} {
    global vTcl
    set file [vTcl:get_file open "Source File"]
    if {$file != ""} {
        vTcl:source $file newprocs
        vTcl:list add $newprocs vTcl(procs)
        vTcl:update_proc_list
    }
}

proc vTcl:is_vtcl_prj {file} {
    global vTcl

    set fileID [open $file r]
    set contents [read $fileID]
    close $fileID

    set found 0
    set vmajor ""
    set vminor ""

    foreach line [split $contents \n] {
        if [regexp {# Generated by PAGE version} $line] {
            set found 1
        }
    }
    # Rozen. I am leaving the follwing loop to allow older files to be
    # used along with those generated by the newest version, 3.5. I
    # should remove this later. Will NEEDS WORK.
    foreach line [split $contents \n] {
    if [regexp {# Visual Tcl v(.?)\.(.?.?) Project} $line \
        matchAll vmajor vminor] {
        set found 1
    }
    }
    if !$found {
    ::vTcl::MessageBox -title "Error loading file" \
                  -message "This is not a vTcl project!" \
                  -icon error \
                  -type ok
    return 0
    }

    set versions [split $vTcl(version) .]
    set actual_major [lindex $versions 0]
    set actual_minor [lindex $versions 1]

    if {$vmajor != "" && $vminor != ""} {

        if {$vmajor > $actual_major ||
            ($vmajor == $actual_major && $vminor > $actual_minor)} {
        ::vTcl::MessageBox -title "Error loading file" \
                      -message "You are trying to load a project created using Visual Tcl v$vmajor.$vminor\n\nPlease update to vTcl $vmajor.$vminor and try again." \
                  -icon error \
                  -type ok

            return 0
        }
    }

    # all right, it's a vtcl project
    return 1
}

proc vTcl:source {file newprocs} {
    global vTcl
    set vTcl(sourcing) 1
    vTcl:statbar 15
    set op ""
    upvar $newprocs np
    foreach context [vTcl:namespace_tree] {
        # Hack for Tcl/Tk 8.5
        # Tristan 2008-05-13
        catch { set cop [namespace eval $context {info procs}] }

        foreach procname $cop {
            if {$context == "::"} {
               lappend op $procname
            } else {
               lappend op ${context}::$procname
            }
        }
    }

    vTcl:statbar 20
#    if [catch {uplevel #0 [list source $file]} err] {
#        ::vTcl::MessageBox -icon error -message "Error Sourcing Project\n$err" \
#            -title "File Error!"
#    global errorInfo
#    }
uplevel #0 [list source $file]  ;# Rozen to see trace back.
    vTcl:statbar 35

    # kc: ignore global procs like "tixSelect"
    set np ""
    foreach context [vTcl:namespace_tree] {
if {$context == "::tcl::dict"} { continue }  ;# Rozen cause 8.4 does not have dict command

        # Hack for Tcl/Tk 8.5
        # Tristan 2008-05-13
        catch { set cop [namespace eval $context {info procs}] }

        foreach procname $cop {
            if {[vTcl:ignore_procname_when_sourcing $procname] == 0 &&
                [vTcl:ignore_procname_when_sourcing ${context}::$procname] == 0} {
               if {$context == "::"} {
                   lappend np $procname
               } else {
                   lappend np ${context}::$procname
               }
            }
       }
    }

    set np [vTcl:diff_list $op $np]
    vTcl:statbar 45
    set vTcl(tops) [vTcl:find_new_tops $np];     vTcl:statbar 0
    set vTcl(sourcing) 0
}

proc vTcl:open {{file ""} {title "Open Project"}} {
    global vTcl argc argv
    set vTcl(save_as) 0
    if {$file == ""} {
        # set file [vTcl:get_file open "Open Project"]
        set file [vTcl:get_file open $title]
    } else {
        if ![file exists $file] {return}
    }
    if {![info exists vTcl(rcFiles)]} { set vTcl(rcFiles) {} }

    if {[lempty $file]} { return }
    # Test for changed project
    if {$vTcl(change) && !$vTcl(borrow)} {
        set question \
            "Existing GUI will be replaced. Do you want to Cancel or Proceed?"
        set choice [tk_dialog .foo "Warning" $question \
                         question 1 "Cancel" "Proceed"]
        if {$choice == 0} {
            return
        }
    }
    if {!$vTcl(borrow)} {
       if { [vTcl:close] == -1 } { return }
    }
    set vTcl(sourcing) 1
    # only open a Visual Tcl project and nothing else
    # Rozen. Check for the famous comment.
    if ![vTcl:is_vtcl_prj $file] {return}
    vTcl:addRcFile $file
    set vTcl(file,mode) ""
    vTcl:load_lib vtclib.tcl;            vTcl:statbar 10
    if {!$vTcl(borrow)} {          ;# Rozen 11/19/17
        set vTcl(tops) ""
        # FIXME: following line
        set vTcl(btop) ""
    }
    set vTcl(vars) ""
    set vTcl(procs) ""
    proc vTcl:project:info {} {}

    vTcl:status "Loading Project"
    vTcl:source $file newprocs;          vTcl:statbar 55
    # make sure the 'Window' procedure is the latest
    vTcl:load_lib vtclib.tcl;            vTcl:statbar 60
    vTcl:status "Updating top list"
    vTcl:update_top_list;                vTcl:statbar 68

    ## convert older projects
    vTcl:convert_tops

    vTcl:status "Updating aliases"
    vTcl:update_aliases;                 vTcl:statbar 75

    vTcl:status "Loading Project Info";  vTcl:statbar 80

    if {!$vTcl(borrow)} {
        set vTcl(project,file) $file
        set vTcl(project,name) [file tail $file]
    }
    set vTcl(project_specified) 1            ;# Rozen 12/22/15

    ## Determine if there is a multifile project file and source it.
    ## Rozen. I don't expect to find one!
    set basedir [file dir $file]
    set multidir [vTcl:dump:get_multifile_project_dir $vTcl(project,name)]
    set file [file root $vTcl(project,name)].vtp
    if {[file exists [file join $basedir $file]]} {
        source [file join $basedir $file]
    } elseif {[file exists [file join $basedir $multidir $file]]} {
        source [file join $basedir $multidir $file]
    }

    ## If there are project settings, load them

    if {![lempty [info proc vTcl:project:info]]} {
        vTcl:project:info
    }

    ## Setup the bind tree after we have loaded project info, so
    ## that registration of children in childsites works OK
    vTcl:status "Setting up bind tree"
    vTcl:setup_bind_tree .;              vTcl:statbar 85

    vTcl:status "Registering widgets"
    vTcl:widget:register_all_widgets;    vTcl:statbar 90

    vTcl:status "Updating proc list"
    if {$::vTcl::modules::main::procs != ""} {
        vTcl:list add $::vTcl::modules::main::procs vTcl(procs)
    } else {
        #vTcl:list add "init main" vTcl(procs)  Rozen
        if {!$vTcl(borrow)} {
            vTcl:list add vTcl(procs)
            vTcl:list add $newprocs   vTcl(procs)
        }
    }
    vTcl:update_proc_list;               vTcl:statbar 95
    vTcl:bind_tops;                      vTcl:statbar 98

    ## The "single file" or "multiple files" option is now saved with each
    ## project, and defaults to the current preference if not saved into the
    ## project file. This is an intermediate step toward module oriented projects.
    set vTcl(pr,projecttype) $::vTcl::modules::main::projectType

    #wm title .vTcl "Visual Tcl - $vTcl(project,name)"
    wm title .vTcl "PAGE - $vTcl(project,name)"
    vTcl:status "Done Loading"
    vTcl:statbar 0
    set vTcl(newtops) [expr [llength $vTcl(tops)] + 1]

    unset vTcl(sourcing)

    ## show all toplevels for editing
    ::vTcl:::tops::handleRunvisible deiconify
    ## refresh widget tree automatically after File Open...
    ## refresh image manager and font manager
    ## refresh user compounds menu
    after idle {
        vTcl:init_wtree
        vTcl:image:refresh_manager
        vTcl:font:refresh_manager

        #vTcl:cmp_user_menu   Since I am not using the compound menu.
    }
    set top [lrange $vTcl(tops) 0 0]
    set vTcl(real_top) $top
    set vTcl(top_geometry) [wm geometry $top]
}

proc vTcl:close { } {
    global vTcl
    if {$vTcl(change) > 0} {
        set result [::vTcl::MessageBox -default no -icon question -message \
            "Your application has unsaved changes. Do you wish to save?" \
                        -title "Save Changes?" -type yesnocancel]
        switch $result {
            yes {
                # @@ Nelson 20030409 if project is named just save it.
                #if {[vTcl:save_as] == -1} { return -1 }
                if {[vTcl:save] == -1} { return -1 }
            }
            cancel {
                return -1
            }
        }
    }
    set tops $vTcl(tops)
    foreach i $tops {
        if {$i != ".vTcl" && $i != ".__tk_filedialog"} {
            # list widget tree without including $i (it's why the "0" parameter)
            foreach child [vTcl:widget_tree $i 0] {
                vTcl:unset_alias $child
                vTcl:setup_unbind $child
            }
            vTcl:unset_alias $i
            destroy $i

            # this is clean up for leftover widget commands
            set _cmds [info commands $i.*]
            foreach _cmd $_cmds {catch {rename $_cmd ""}}
        }

        ## Destroy the widget namespace, as well as the namespaces of
        ## all it's subwidgets
        set namespaces [vTcl:namespace_tree ::widgets]
        foreach namespace $namespaces {
            if {[string match ::widgets::$i* $namespace]} {
                catch {namespace delete $namespace} error
            }
        }
    }

    set vTcl(tops) ""
    set vTcl(newtops) 1
    vTcl:update_top_list
    foreach i $vTcl(vars) {
        # don't erase aliases, they should be erased when
        # closing the toplevels
        if {$i == "widget"} continue
        catch {global $i; unset $i}
    }
    set vTcl(vars) ""
    foreach i $vTcl(procs) {
        catch {rename $i {}}
    }
    proc exit {args} {}
    proc init {argc argv} {}
    proc main {argc argv} {}
    #set vTcl(procs) "init main" Rozen
    set vTcl(procs) ""
    vTcl:update_proc_list
    set vTcl(project,file) ""
    set vTcl(project,name) ""
    set vTcl(w,widget) ""
    set vTcl(w,save) ""
    wm title $vTcl(gui,main) "PAGE"
    set vTcl(change) 0
    set vTcl(quit) 0

    # refresh widget tree automatically after File Close
    # delete user images (e.g. per project images)
    # delete user fonts (e.g. per project fonts)

    vTcl:image:remove_user_images
    vTcl:font:remove_user_fonts
    vTcl:prop:clear
    ::widgets_bindings::init
    ::menu_edit::close_all_editors
    ::vTcl::project::closeCompounds main
    #vTcl:cmp_user_menu   Rozen
    ::vTcl::project::initModule main

    ::vTcl::notify::publish closed_project

    after idle {vTcl:init_wtree}
}

proc vTcl:get_project_name {} {
    global vTcl
    if {$vTcl(project,file) == ""} {
        set vTcl(project,file) [vTcl:get_file name "Project File"]
        set vTcl(project,name) [file tail $vTcl(project,file)]
    }
}

proc vTcl:save {} {
    global vTcl
    set vTcl(save) all
    set vTcl(w,save) $vTcl(w,widget)
    set vTcl(save2_running) 1
    set vTcl(save_as) 0
    vTcl:get_project_name
    vTcl:save2 $vTcl(project,file)
    # if {$vTcl(project,file) == ""} {
    #     set file [vTcl:get_file save "Save Project"]
    #     vTcl:save2 $file
    # } else {
    #     vTcl:save2 $vTcl(project,file)
    # }
    set vTcl(save2_running) 0
    wm title .vTcl "PAGE - $vTcl(project,name)"
}

proc vTcl:save_as {} {
    # Only called from File menu.  If "Save As" was selected we
    # definitely want to save change or no change.
    global vTcl
    set vTcl(save) all
    set vTcl(w,save) $vTcl(w,widget)
    set file [vTcl:get_file save "Save As Project"]
    set vTcl(save2_running) 1
    set vTcl(save_as) 1
    vTcl:save2 $file
    set vTcl(save2_running) 0
    set vTcl(save_as) 0
    wm title .vTcl "PAGE - $vTcl(project,name)"
}

proc vTcl:borrow {} {
    global vTcl
    set vTcl(borrow) 1
    vTcl:open "" "Borrow From Project"
}

proc vTcl:save2 {file} {
    global vTcl env
    global tcl_platform
    # # Want to be sure that the set_sash list we use will be a fresh one.
    # if {[info exists vTcl(set_sash)]} {
    #     unset vTcl(set_sash)
    # }
    if {$file == ""} {
        return -1
    }
    # Rozen.  This was added 11/19/14 and probably obviates the need
    # to check if the temp file is different from any existing
    # files. The main check vTcl(change) but that does not seem to
    # catch the case where the toplevel is moved or resized, hense the
    # need for the variable vTcl(top_geometry) which is checked and
    # keep up to date here. It is also set when a project file is
    # imported.
    set top [lrange $vTcl(tops) 0 0]
    if {$vTcl(tops) == ""} {
        ::vTcl::MessageBox -title "Error saving project" \
            -message \
          "You are trying to save a void project; there is no top level widget" \
                  -icon error \
                  -type ok
        return -1
    }
    if {!$vTcl(save_as) &&
        !$vTcl(change) &&
        $vTcl(top_geometry) == [wm geometry $top] &&
        [file exists $file]} {
        return -1
    }
    vTcl:set_timestamp            ;# In misc.tcl
    vTcl:destroy_handles
    vTcl:setup_bind_tree .


    set vTcl(project,name) [lindex [file split $file] end]
    set vTcl(project,file) $file

    set tmp_name ${file}.tmp
    # Catch for errors during the saving operations.
    set output ""

    # Rozen for debugging I want to see the error track, etc. So I comment
# out the next line and the block at about line 715.
#   if {[catch {
        set output [open $tmp_name w]
        ## Gather information about the widgets.
        vTcl:dump:gather_widget_info

        ## Project header
        puts $output "[subst $vTcl(head,proj)]\n"
        ## Save compounds (if any)
        puts $output [vTcl::project::saveCompounds main]
        ## Code to load images
        #vTcl:image:generate_image_stock $output
        vTcl:image:generate_image_user  $output
        ## Rozen.  Code to bring in the default colors and fonts.
    puts $output "if {!\$vTcl(borrow)} {\n"
        vTcl:font:generate_default_fonts $output  ;# In font.tcl
        vTcl:set_GUI_color_defaults $output        ;# In color.tcl
    puts $output "}\n"
        ## Code to load fonts
        vTcl:font:generate_font_stock   $output
        vTcl:font:generate_font_user    $output
        # moved init proc after user procs so that the init
        # proc can call any user proc
        ::vTcl:::tops::handleRunvisible withdraw
        if {$vTcl(save) == "all"} {
            puts $output $vTcl(head,exports)
            puts $output [vTcl:export_procs]
            puts $output [vTcl:dump:project_info \
                [file dirname $file] $vTcl(project,name)]
            #puts $output $vTcl(head,procs)
            #puts $output [vTcl:save_procs]

            puts $output $vTcl(head,gui)
            puts $output [vTcl:save_tree . \
                              [file dirname $file] $vTcl(project,name)]
            #puts $output "main \$argc \$argv"  ;# Rozen
        } else {
            puts $output [vTcl:save_tree $vTcl(w,widget)]
        }
        ::vTcl:::tops::handleRunvisible deiconify
        vTcl:addRcFile $file

        close $output
        set vTcl(project_specified) 1

      vTcl:status "Done Saving"
      set vTcl(file,mode) ""

      if {$vTcl(w,save) != ""} {
            if {$vTcl(w,widget) != $vTcl(w,save)} {
                vTcl:active_widget $vTcl(w,save)
            }
            vTcl:create_handles $vTcl(w,save)
      }


        # The catch ends below.
   # }
   #    errResult]} {
   #     # End the catch and give feedback here if things went wrong.
   #     ::vTcl::MessageBox -icon error -message \
   #          "An error occured during the save operation:\n\n$errResu        lt" \
   #          -title "Save Error!" -type ok

   #     # Move the original file back and do not mess with the .bak file.
   #     # First of all, close the messed up and uncompletely saved file.
   #     if {$output != ""} {
   #         close $output
   #     }
   #     if {[file exists ${file}.tmp]} {
   #          file rename -force ${file}.tmp ${file}
   #     }
   # } else {
        # if {[vTcl::project::isMultipleFileProject]} {
        #     ## If we get here then we are testing to see that the
        #     ## files associated with the multifile project all dumped
        #     ## to .bak files ok. If any ${file}.tmp files with the
        #     ## project exist then we do not want to finish the dump
        #     ## with the project file.
        #     set tops ". $vTcl(tops)"
        #     ## The tmpSentry will come out 0 still if all the .tmp
        #     ## files for the project are gone.
        #     set tmpSentry 0
        #     foreach i $tops {
    #         if {[file exists [file joins [file dirname $file]
        #              [vTcl:dump:get_multifile_project_dir $vTcl(project,name)]
        #                           f$i.tcl.tmp]]} {
        #             set tmpSentry 1
        #         }
        #     }
        #     if {!$tmpSentry} {
        #         ## All well if we get here and we need to move the ${file}.tmp to ${fiel}.bak
        #         if {[file exists ${file}.tmp]} {
        #             file rename -force ${file}.tmp ${file}.bak
        #         }
        #         set vTcl(change) 0
        #         wm title $vTcl(gui,main) "Visual Tcl - $vTcl(project,name)"
        #     } else {
        #         ## The backup has failed to move the original main file back.
        #         if {[file exists ${file}.tmp]} {
        #             file rename -force ${file}.tmp ${file}
        #         }
        #         ## Let the user know that all the associated files for the project did not backup correct.
        #         ## Advise them to choose save as.
        #         ::vTcl::MessageBox -icon error -message \
        #          "An error occured during the multifile backup operation:\n\nPlease choose Save As and save in a new location!" \
        #          -title "Save Error!" -type ok
        #     }
        # } else {
# NEEDS WORK - Replace following block of code.
            ## All well if we get here and we need to move the
            ## ${file}.tmp to ${file}.bak
            # if {[file exists ${file}.tmp]} {
            #    file rename -force ${file}.tmp ${file}.bak
            # }

    # Here I copy increment any existing backup files to the next one down.
    foreach n {4 3 2 1} {
        set n_plus_1 [expr $n + 1]
        catch {
            [file copy -force $file.bak$n $file.bak$n_plus_1]
        }
    }
    catch {[file copy -force $file $file.bak1]}

    # Finally rename the backup file to desired name.
    file rename -force $tmp_name $file
    # reset the stuff for the next save.
    set vTcl(top_geometry) [wm geometry $top]
    set vTcl(change) 0

       # }
# Rozen part of the error catch
    # }
    # @@end_change 20030409 Nelson bug 415090
}

proc vTcl:quit {} {
    global vTcl
    set vTcl(quit) 1
    ## If the project has changed, close it before exiting.
    if {$vTcl(change)} {
        if {[vTcl:close] == -1} { return }
    }

    if {[winfo exists .vTcl.tip]} {
       eval [wm protocol .vTcl.tip WM_DELETE_WINDOW]
    }

    # Rozen. I think that this was removed but not replaced
    # anyhere. So I put the call in the preference window so that when
    # the window is is 'checked' it is also saved.

    # Changed by Tristan 2008-06-26
    #vTcl:save_prefs
    # Rozen. I think the system is better saving the preferences
    vTcl:save_prefs
    vTcl:exit
}


proc vTcl:save_prefs {} {
    global vTcl
    set w $vTcl(gui,main)
    set pos [vTcl:get_win_position $w]
    vTcl:set_timestamp            ;# In misc.tcl
    append output "# Saved $vTcl(timestamp)\n"
    append output "set vTcl(geometry,$w) $vTcl(pr,geom_vTcl)$pos\n"
    set showlist ""

    ## If the window exists but is not visible, we still want to save its
    ## geometry, just not add it to the showlist.

    foreach i $vTcl(windows) {
#        if {[string first "console" $i] > -1} {
#            # window is a console.
#        }


        # This routine is called while .vTcl.prefs is still open, so I
        # don't want it automatically opened when next we start the
        # program.
        if {$i == ".vTcl.prefs"} continue
        #        if {$i == ".vTcl.callback"} continue  ;# NEEDS WORK
        if {[winfo exists $i]} {

# dmsg a $i
# set geom [wm geometry $i]
# set sp  [split $geom "x+"]
# dpr sp
# set screenx [lindex [split $geom "x+"] 0]
# dpr screenx
# if {$screenx > $s_width || $screenx < 0} {
#     set geom [lindex sp 0]x[lindex sp 0]$vTcl(default, $i)
# }
            append output "set vTcl(geometry,${i}) [wm geometry $i]\n"
            if {[vTcl:streq [wm state $i] "normal"]} {
                lappend showlist $i
            }
        } else {
            catch {
                # If it isn't open save the default geometry.
                append output "set vTcl(geometry,${i}) $vTcl(geometry,${i})\n"
            }
        }
        if {$i == ".vTcl.gcon" } {

            if {[winfo exists $i]} {
                # I want to save the sash location of the paned window.
                set sash [.vTcl.gui_console.tPa42 sashpos 0]
                append output "set vTcl(gui_sash) $sash\n"
            } else {
                catch {append output "set vTcl(gui_sash) $sash\n"}
            }
        }
        if {$i == ".vTcl.scon" } {

            if {[winfo exists $i]} {
                # I want to save the sash location of the paned window.
                set sash [.vTcl.supp_console.tPa42 sashpos 0]
                append output "set vTcl(supp_sash) $sash\n"
            } else {
                catch {append output "set vTcl(supp_sash) $sash\n"}
            }
        }
    }
    append output "set vTcl(gui,showlist) \"$showlist\"\n"
    # Rozen. My attempt to save the gepmetry settings of the menu editor.
    if {[info exists vTcl(geometry,menu_editor)]} {
        append output \
            "set vTcl(geometry,menu_editor) $vTcl(geometry,menu_editor)\n"
    }
    foreach i [array names vTcl pr,*] {
#        if {$i == "pr,initialdir"} continue                  ;# Rozen
        append output "set vTcl($i) [list $vTcl($i)]\n"
    }
    append output "set vTcl(grid,x) [list $vTcl(grid,x)]\n" ;# Rozen
    append output "set vTcl(grid,y) [list $vTcl(grid,y)]\n" ;# Rozen
    append output "set vTcl(tab_width) [list $vTcl(tab_width)]\n" ;# Rozen
    append output "set vTcl(ide_cmd) [list $vTcl(ide_cmd)]\n" ;# Rozen


    if {![info exists vTcl(rcFiles)]} { set vTcl(rcFiles) {} }
    append output "set vTcl(rcFiles) \[list $vTcl(rcFiles)\]\n"
    catch {
        set file [open $vTcl(CONF_FILE) "w"]
        puts $file $output
        close $file
    }
}

proc vTcl:find_files {base pattern} {
    global vTcl
    set dirs ""
    set match ""
    set files [lsort [glob -nocomplain [file join $base *]]]
    if {$pattern == ""} {set pattern "*"}
    foreach i $files {
        if {[file isdir $i]} {
            lappend dirs $i
        } elseif {[string match $pattern $i]} {
            lappend match $i
        }
    }
    return "$dirs $match"
}

proc vTcl:get_file {mode {title File} {ext .tcl}} {
    global vTcl tk_version tcl_platform tcl_version tk_strictMotif
    if {![info exists vTcl(initialdir)]} {
        set vTcl(initialdir) [pwd]
    }
    # if {[string tolower $mode] == "open"} {
    #     set vTcl(file,mode) "Open"
    # } else {
    #     set vTcl(file,mode) "Save"
    # }
    set mode [string tolower $mode]
    set types { {{Tcl Files} {*.tcl}}
                {{All}       {*}} }
    switch $mode {
        open { set vTcl(file,mode) "Open" }
        save { set vTcl(file,mode) "Save" }
        print { set vTcl(file,mode) "Print"
            set types { {{Tcl Files} {*.tre}}
                {{All}       {*}}
            }
            set ext .tre
            set title Print
        }
        callback { set vTcl(file,mode) "Callback"
            set types { {{Tcl Files} {*.cbl}}
                {{All}       {*}}
            }
            set ext .cbl
            set title "Save Callbacks"
        }
        name { set vTcl(file,mode) "Project"
            set title "Project File"
        }
    }
    set tk_strictMotif 0
    option add *foreground black  ;# Rozen So one can see filenames with dark bg
    switch $mode {
        open {
            set file [tk_getOpenFile -defaultextension $ext -title $title \
                -initialdir $vTcl(initialdir) -filetypes $types]
        }
        save {
            set initname [file tail $vTcl(project,file)]
            if {$initname == ""} {
                set initname "unknown.tcl"
            }
            if {$tcl_platform(platform) == "macintosh"} then {
                set file [tk_getSaveFile -defaultextension $ext -title $title \
                    -initialdir $vTcl(initialdir) -initialfile $initname]
            } else {
                set file [tk_getSaveFile -defaultextension $ext -title $title \
                    -initialdir $vTcl(initialdir) -filetypes $types \
                    -initialfile $initname]
            }
            set rname [file tail [file rootname $file]]
            if {![vTcl:isident $rname]} {
                ::vTcl::MessageBox -icon error  \
                       -message "Illegal file name -\"$file\"" \
                         -title "Syntax Error"
                update idletasks
                return
            }
        }
        print {
            set initname [file tail $vTcl(project,file)]
            if {$initname == ""} {
                set initname "unknown.tre"
            }
            set initname [file rootname $initname].tre
            if {$tcl_platform(platform) == "macintosh"} then {
                set file [tk_getSaveFile -defaultextension $ext -title $title \
                    -initialdir $vTcl(initialdir) -initialfile $initname]
            } else {
                set file [tk_getSaveFile -defaultextension $ext -title $title \
                    -initialdir $vTcl(initialdir) -filetypes $types \
                    -initialfile $initname]
            }
            set rname [file tail [file rootname $file]]
            if {![vTcl:isident $rname]} {
                ::vTcl::MessageBox -icon error  \
                       -message "Illegal file name -\"$file\"" \
                         -title "Syntax Error"
                update idletasks
                return
            }
        }
        callback {
            set initname [file tail $vTcl(project,file)]
            if {$initname == ""} {
                set initname "unknown.clb"
            }
            set initname [file rootname $initname].cbl
            if {$tcl_platform(platform) == "macintosh"} then {
                set file [tk_getSaveFile -defaultextension $ext -title $title \
                    -initialdir $vTcl(initialdir) -initialfile $initname]
            } else {
                set file [tk_getSaveFile -defaultextension $ext -title $title \
                    -initialdir $vTcl(initialdir) -filetypes $types \
                    -initialfile $initname]
            }
            set rname [file tail [file rootname $file]]
            if {![vTcl:isident $rname]} {
                ::vTcl::MessageBox -icon error  \
                       -message "Illegal file name -\"$file\"" \
                         -title "Syntax Error"
                update idletasks
                return
            }
        }
        name {
           set initname [file tail $vTcl(project,file)]
            if {$initname == ""} {
                set initname "unknown.tcl"
            }
            if {$tcl_platform(platform) == "macintosh"} then {
                set file [tk_getSaveFile -defaultextension $ext -title $title \
                    -initialdir $vTcl(initialdir) -initialfile $initname]
            } else {
                set file [tk_getSaveFile -defaultextension $ext -title $title \
                    -initialdir $vTcl(initialdir) -filetypes $types \
                    -initialfile $initname]
            }
            set rname [file tail [file rootname $file]]
            if {![vTcl:isident $rname]} {
                ::vTcl::MessageBox -icon error  \
                       -message "Illegal file name -\"$file\"" \
                         -title "Syntax Error"
                update idletasks
                return
            }
        }
    }
    option add *vTcl*foreground $vTcl(pr,fgcolor)  ;# Rozen
    set tk_strictMotif 1
    if {$file != ""} {
        set vTcl(initialdir) [file dirname $file]
    }
    catch {cd [file dirname $file]}
    return $file
}

proc vTcl:restore {} {
    global vTcl

    set file $vTcl(project,file)

    if {[lempty $file]} { return }
    set bakFile $file.bak
    if {![file exists $bakFile]} {
        ## change by Nelson 20030227
        ## Provides the user feedback about no $file.bak existance
        ## and potential reason why one might not exist.

        ::vTcl::MessageBox -icon error -message \
         "A backup file $bakFile does not exist! Backup files are only created upon save operations beyond the original creation of the file." \
         -title "Restore Error!" -type ok

    return
    }

    if {[vTcl::project::isMultipleFileProject]} {
        ## If we get here then it is a multi file project. So lets try to restore from each backup file.
        set restoreProject $vTcl(project,name)
        set tops ". $vTcl(tops)"
        vTcl:close
        foreach i $tops {
            set multiFile [file join [file dirname $file] [vTcl:dump:get_multifile_project_dir $restoreProject] f$i.tcl]
            set bakMultiFile [file join [file dirname $file] [vTcl:dump:get_multifile_project_dir $restoreProject] $multiFile.bak]
            if {[file exists $bakMultiFile ]} {
                file copy -force -- $bakMultiFile $multiFile
            } else {
                ::vTcl::MessageBox -icon error -message \
                 "A backup file $bakMultiFile does not exist!\n $tops \n Backup files are only created upon save operations beyond the original creation of the file." \
                 -title "Restore Error!" -type ok
            }
        }
        file copy -force -- $bakFile $file
        update idletasks
        vTcl:open $file

    } else {
        ## If we are here then it is a single file backup.
        #vTcl:close
        file copy -force -- $bakFile $file
        vTcl:open $file
    }
}

namespace eval vTcl::project {

    proc isMultipleFileProject {} {
        return [expr {$::vTcl(pr,projecttype) == "multiple"}]
    }

    proc initModule {moduleName} {
        namespace eval ::vTcl::modules::${moduleName} {
            variable procs
            set procs ""
            variable compounds
            set compounds ""
            ## TODO: this will probably be discarded once we have real modules
            ##       where any object (toplevel, procedure, image, font, ...) can
            ##       be contained and saved into a particular module
            variable projectType
            set projectType $::vTcl(pr,projecttype)
        }
    }

    proc addCompound {moduleName type compoundName} {
        upvar ::vTcl::modules::${moduleName}::compounds compounds
        set compound $type
        lappend compounds [list $type $compoundName]
        set compounds [lsort -unique $compounds]
    }

    proc saveCompounds {moduleName} {
        upvar ::vTcl::modules::${moduleName}::compounds compounds

        set output ""
        foreach compound $compounds {
            set type         [lindex $compound 0]
            set compoundName [lindex $compound 1]
            append output {#############################################################################}
            append output \n
            append output {## Compound: }
            append output "$type / $compoundName\n"
            append output [vTcl:dump_namespace vTcl::compounds::${type}::[list $compoundName]]
        }

        return $output
    }

    proc getCompounds {moduleName} {
        return [vTcl:at ::vTcl::modules::${moduleName}::compounds]
    }

    proc closeCompounds {moduleName} {
        upvar ::vTcl::modules::${moduleName}::compounds compounds

        foreach compound $compounds {
            closeCompound $compound
        }
        set compounds ""
    }

    proc closeCompound {compound} {
        set type         [lindex $compound 0]
        set compoundName [lindex $compound 1]
        vTcl::compounds::deleteCompound $type $compoundName
    }

    ## returns the required libraries for the inserted compounds
    proc requiredLibraries {moduleName} {
        upvar ::vTcl::modules::${moduleName}::compounds compounds

        set result "core"
        foreach compound $compounds {
            set type         [lindex $compound 0]
            set compoundName [lindex $compound 1]
            set result [concat $result [vTcl::compounds::getLibraries $type $compoundName]]
        }

        return [lsort -unique $result]
    }

    ## returns the list of requested libraries
    proc getLibrariesToLoad {} {
        set ::vTcl::toload ""
        # Since these are the one I want to use.  Rozen
        #set ::vTcl(pr,loadlibs) {lib_core.tcl lib_user.tcl lib_bwidget.tcl lib_vtcl.tcl}
        #set ::vTcl(pr,loadlibs) {lib_core.tcl lib_user.tcl}
#NEEDS WORK - Remove line below for debugging.
        #        set ::vTcl(pr,loadlibs) {lib_core.tcl lib_ttk.tcl}  ;# Rozen
        if {[info exists ::vTcl(pr,loadlibs)]} {
            foreach lib $::vTcl(pr,loadlibs) {
                lappend ::vTcl::toload [file join $::vTcl(LIB_DIR) $lib]
            }
        } else {
            set ::vTcl::toload $::vTcl(LIB_WIDG)
        }

        return $::vTcl::toload
    }

    ## sets the list of request libraries (each lib is filename without path)
    proc setLibrariesToLoad {libs} {
        set ::vTcl(pr,loadlibs) $libs
        global vTcl
        set vTcl(pr,loadlibs) $libs
    }
}
