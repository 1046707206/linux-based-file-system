# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.25

# Default target executed when no arguments are given to make.
default_target: all
.PHONY : default_target

# Allow only one "make -f Makefile2" at a time, but pass parallelism.
.NOTPARALLEL:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/wyx08/file_system

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/wyx08/file_system

#=============================================================================
# Targets provided globally by CMake.

# Special rule for the target edit_cache
edit_cache:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "No interactive CMake dialog available..."
	/usr/bin/cmake -E echo No\ interactive\ CMake\ dialog\ available.
.PHONY : edit_cache

# Special rule for the target edit_cache
edit_cache/fast: edit_cache
.PHONY : edit_cache/fast

# Special rule for the target rebuild_cache
rebuild_cache:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "Running CMake to regenerate build system..."
	/usr/bin/cmake --regenerate-during-build -S$(CMAKE_SOURCE_DIR) -B$(CMAKE_BINARY_DIR)
.PHONY : rebuild_cache

# Special rule for the target rebuild_cache
rebuild_cache/fast: rebuild_cache
.PHONY : rebuild_cache/fast

# The main all target
all: cmake_check_build_system
	$(CMAKE_COMMAND) -E cmake_progress_start /home/wyx08/file_system/CMakeFiles /home/wyx08/file_system//CMakeFiles/progress.marks
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 all
	$(CMAKE_COMMAND) -E cmake_progress_start /home/wyx08/file_system/CMakeFiles 0
.PHONY : all

# The main clean target
clean:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 clean
.PHONY : clean

# The main clean target
clean/fast: clean
.PHONY : clean/fast

# Prepare targets for installation.
preinstall: all
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 preinstall
.PHONY : preinstall

# Prepare targets for installation.
preinstall/fast:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 preinstall
.PHONY : preinstall/fast

# clear depends
depend:
	$(CMAKE_COMMAND) -S$(CMAKE_SOURCE_DIR) -B$(CMAKE_BINARY_DIR) --check-build-system CMakeFiles/Makefile.cmake 1
.PHONY : depend

#=============================================================================
# Target rules for targets named file_system

# Build rule for target.
file_system: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 file_system
.PHONY : file_system

# fast build rule for target.
file_system/fast:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/build
.PHONY : file_system/fast

do_read.o: do_read.c.o
.PHONY : do_read.o

# target to build an object file
do_read.c.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/do_read.c.o
.PHONY : do_read.c.o

do_read.i: do_read.c.i
.PHONY : do_read.i

# target to preprocess a source file
do_read.c.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/do_read.c.i
.PHONY : do_read.c.i

do_read.s: do_read.c.s
.PHONY : do_read.s

# target to generate assembly for a file
do_read.c.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/do_read.c.s
.PHONY : do_read.c.s

do_write.o: do_write.c.o
.PHONY : do_write.o

# target to build an object file
do_write.c.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/do_write.c.o
.PHONY : do_write.c.o

do_write.i: do_write.c.i
.PHONY : do_write.i

# target to preprocess a source file
do_write.c.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/do_write.c.i
.PHONY : do_write.c.i

do_write.s: do_write.c.s
.PHONY : do_write.s

# target to generate assembly for a file
do_write.c.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/do_write.c.s
.PHONY : do_write.c.s

get_free_block.o: get_free_block.c.o
.PHONY : get_free_block.o

# target to build an object file
get_free_block.c.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/get_free_block.c.o
.PHONY : get_free_block.c.o

get_free_block.i: get_free_block.c.i
.PHONY : get_free_block.i

# target to preprocess a source file
get_free_block.c.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/get_free_block.c.i
.PHONY : get_free_block.c.i

get_free_block.s: get_free_block.c.s
.PHONY : get_free_block.s

# target to generate assembly for a file
get_free_block.c.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/get_free_block.c.s
.PHONY : get_free_block.c.s

get_free_openfilelist.o: get_free_openfilelist.c.o
.PHONY : get_free_openfilelist.o

# target to build an object file
get_free_openfilelist.c.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/get_free_openfilelist.c.o
.PHONY : get_free_openfilelist.c.o

get_free_openfilelist.i: get_free_openfilelist.c.i
.PHONY : get_free_openfilelist.i

# target to preprocess a source file
get_free_openfilelist.c.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/get_free_openfilelist.c.i
.PHONY : get_free_openfilelist.c.i

get_free_openfilelist.s: get_free_openfilelist.c.s
.PHONY : get_free_openfilelist.s

# target to generate assembly for a file
get_free_openfilelist.c.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/get_free_openfilelist.c.s
.PHONY : get_free_openfilelist.c.s

head.o: head.c.o
.PHONY : head.o

# target to build an object file
head.c.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/head.c.o
.PHONY : head.c.o

head.i: head.c.i
.PHONY : head.i

# target to preprocess a source file
head.c.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/head.c.i
.PHONY : head.c.i

head.s: head.c.s
.PHONY : head.s

# target to generate assembly for a file
head.c.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/head.c.s
.PHONY : head.c.s

help.o: help.c.o
.PHONY : help.o

# target to build an object file
help.c.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/help.c.o
.PHONY : help.c.o

help.i: help.c.i
.PHONY : help.i

# target to preprocess a source file
help.c.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/help.c.i
.PHONY : help.c.i

help.s: help.c.s
.PHONY : help.s

# target to generate assembly for a file
help.c.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/help.c.s
.PHONY : help.c.s

main.o: main.c.o
.PHONY : main.o

# target to build an object file
main.c.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/main.c.o
.PHONY : main.c.o

main.i: main.c.i
.PHONY : main.i

# target to preprocess a source file
main.c.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/main.c.i
.PHONY : main.c.i

main.s: main.c.s
.PHONY : main.s

# target to generate assembly for a file
main.c.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/main.c.s
.PHONY : main.c.s

my_cd.o: my_cd.c.o
.PHONY : my_cd.o

# target to build an object file
my_cd.c.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_cd.c.o
.PHONY : my_cd.c.o

my_cd.i: my_cd.c.i
.PHONY : my_cd.i

# target to preprocess a source file
my_cd.c.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_cd.c.i
.PHONY : my_cd.c.i

my_cd.s: my_cd.c.s
.PHONY : my_cd.s

# target to generate assembly for a file
my_cd.c.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_cd.c.s
.PHONY : my_cd.c.s

my_close.o: my_close.c.o
.PHONY : my_close.o

# target to build an object file
my_close.c.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_close.c.o
.PHONY : my_close.c.o

my_close.i: my_close.c.i
.PHONY : my_close.i

# target to preprocess a source file
my_close.c.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_close.c.i
.PHONY : my_close.c.i

my_close.s: my_close.c.s
.PHONY : my_close.s

# target to generate assembly for a file
my_close.c.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_close.c.s
.PHONY : my_close.c.s

my_create.o: my_create.c.o
.PHONY : my_create.o

# target to build an object file
my_create.c.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_create.c.o
.PHONY : my_create.c.o

my_create.i: my_create.c.i
.PHONY : my_create.i

# target to preprocess a source file
my_create.c.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_create.c.i
.PHONY : my_create.c.i

my_create.s: my_create.c.s
.PHONY : my_create.s

# target to generate assembly for a file
my_create.c.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_create.c.s
.PHONY : my_create.c.s

my_exit.o: my_exit.c.o
.PHONY : my_exit.o

# target to build an object file
my_exit.c.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_exit.c.o
.PHONY : my_exit.c.o

my_exit.i: my_exit.c.i
.PHONY : my_exit.i

# target to preprocess a source file
my_exit.c.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_exit.c.i
.PHONY : my_exit.c.i

my_exit.s: my_exit.c.s
.PHONY : my_exit.s

# target to generate assembly for a file
my_exit.c.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_exit.c.s
.PHONY : my_exit.c.s

my_format.o: my_format.c.o
.PHONY : my_format.o

# target to build an object file
my_format.c.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_format.c.o
.PHONY : my_format.c.o

my_format.i: my_format.c.i
.PHONY : my_format.i

# target to preprocess a source file
my_format.c.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_format.c.i
.PHONY : my_format.c.i

my_format.s: my_format.c.s
.PHONY : my_format.s

# target to generate assembly for a file
my_format.c.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_format.c.s
.PHONY : my_format.c.s

my_ls.o: my_ls.c.o
.PHONY : my_ls.o

# target to build an object file
my_ls.c.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_ls.c.o
.PHONY : my_ls.c.o

my_ls.i: my_ls.c.i
.PHONY : my_ls.i

# target to preprocess a source file
my_ls.c.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_ls.c.i
.PHONY : my_ls.c.i

my_ls.s: my_ls.c.s
.PHONY : my_ls.s

# target to generate assembly for a file
my_ls.c.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_ls.c.s
.PHONY : my_ls.c.s

my_mkdir.o: my_mkdir.c.o
.PHONY : my_mkdir.o

# target to build an object file
my_mkdir.c.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_mkdir.c.o
.PHONY : my_mkdir.c.o

my_mkdir.i: my_mkdir.c.i
.PHONY : my_mkdir.i

# target to preprocess a source file
my_mkdir.c.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_mkdir.c.i
.PHONY : my_mkdir.c.i

my_mkdir.s: my_mkdir.c.s
.PHONY : my_mkdir.s

# target to generate assembly for a file
my_mkdir.c.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_mkdir.c.s
.PHONY : my_mkdir.c.s

my_open.o: my_open.c.o
.PHONY : my_open.o

# target to build an object file
my_open.c.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_open.c.o
.PHONY : my_open.c.o

my_open.i: my_open.c.i
.PHONY : my_open.i

# target to preprocess a source file
my_open.c.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_open.c.i
.PHONY : my_open.c.i

my_open.s: my_open.c.s
.PHONY : my_open.s

# target to generate assembly for a file
my_open.c.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_open.c.s
.PHONY : my_open.c.s

my_read.o: my_read.c.o
.PHONY : my_read.o

# target to build an object file
my_read.c.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_read.c.o
.PHONY : my_read.c.o

my_read.i: my_read.c.i
.PHONY : my_read.i

# target to preprocess a source file
my_read.c.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_read.c.i
.PHONY : my_read.c.i

my_read.s: my_read.c.s
.PHONY : my_read.s

# target to generate assembly for a file
my_read.c.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_read.c.s
.PHONY : my_read.c.s

my_rm.o: my_rm.c.o
.PHONY : my_rm.o

# target to build an object file
my_rm.c.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_rm.c.o
.PHONY : my_rm.c.o

my_rm.i: my_rm.c.i
.PHONY : my_rm.i

# target to preprocess a source file
my_rm.c.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_rm.c.i
.PHONY : my_rm.c.i

my_rm.s: my_rm.c.s
.PHONY : my_rm.s

# target to generate assembly for a file
my_rm.c.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_rm.c.s
.PHONY : my_rm.c.s

my_rmdir.o: my_rmdir.c.o
.PHONY : my_rmdir.o

# target to build an object file
my_rmdir.c.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_rmdir.c.o
.PHONY : my_rmdir.c.o

my_rmdir.i: my_rmdir.c.i
.PHONY : my_rmdir.i

# target to preprocess a source file
my_rmdir.c.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_rmdir.c.i
.PHONY : my_rmdir.c.i

my_rmdir.s: my_rmdir.c.s
.PHONY : my_rmdir.s

# target to generate assembly for a file
my_rmdir.c.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_rmdir.c.s
.PHONY : my_rmdir.c.s

my_startsys.o: my_startsys.c.o
.PHONY : my_startsys.o

# target to build an object file
my_startsys.c.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_startsys.c.o
.PHONY : my_startsys.c.o

my_startsys.i: my_startsys.c.i
.PHONY : my_startsys.i

# target to preprocess a source file
my_startsys.c.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_startsys.c.i
.PHONY : my_startsys.c.i

my_startsys.s: my_startsys.c.s
.PHONY : my_startsys.s

# target to generate assembly for a file
my_startsys.c.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_startsys.c.s
.PHONY : my_startsys.c.s

my_write.o: my_write.c.o
.PHONY : my_write.o

# target to build an object file
my_write.c.o:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_write.c.o
.PHONY : my_write.c.o

my_write.i: my_write.c.i
.PHONY : my_write.i

# target to preprocess a source file
my_write.c.i:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_write.c.i
.PHONY : my_write.c.i

my_write.s: my_write.c.s
.PHONY : my_write.s

# target to generate assembly for a file
my_write.c.s:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/file_system.dir/build.make CMakeFiles/file_system.dir/my_write.c.s
.PHONY : my_write.c.s

# Help Target
help:
	@echo "The following are some of the valid targets for this Makefile:"
	@echo "... all (the default if no target is provided)"
	@echo "... clean"
	@echo "... depend"
	@echo "... edit_cache"
	@echo "... rebuild_cache"
	@echo "... file_system"
	@echo "... do_read.o"
	@echo "... do_read.i"
	@echo "... do_read.s"
	@echo "... do_write.o"
	@echo "... do_write.i"
	@echo "... do_write.s"
	@echo "... get_free_block.o"
	@echo "... get_free_block.i"
	@echo "... get_free_block.s"
	@echo "... get_free_openfilelist.o"
	@echo "... get_free_openfilelist.i"
	@echo "... get_free_openfilelist.s"
	@echo "... head.o"
	@echo "... head.i"
	@echo "... head.s"
	@echo "... help.o"
	@echo "... help.i"
	@echo "... help.s"
	@echo "... main.o"
	@echo "... main.i"
	@echo "... main.s"
	@echo "... my_cd.o"
	@echo "... my_cd.i"
	@echo "... my_cd.s"
	@echo "... my_close.o"
	@echo "... my_close.i"
	@echo "... my_close.s"
	@echo "... my_create.o"
	@echo "... my_create.i"
	@echo "... my_create.s"
	@echo "... my_exit.o"
	@echo "... my_exit.i"
	@echo "... my_exit.s"
	@echo "... my_format.o"
	@echo "... my_format.i"
	@echo "... my_format.s"
	@echo "... my_ls.o"
	@echo "... my_ls.i"
	@echo "... my_ls.s"
	@echo "... my_mkdir.o"
	@echo "... my_mkdir.i"
	@echo "... my_mkdir.s"
	@echo "... my_open.o"
	@echo "... my_open.i"
	@echo "... my_open.s"
	@echo "... my_read.o"
	@echo "... my_read.i"
	@echo "... my_read.s"
	@echo "... my_rm.o"
	@echo "... my_rm.i"
	@echo "... my_rm.s"
	@echo "... my_rmdir.o"
	@echo "... my_rmdir.i"
	@echo "... my_rmdir.s"
	@echo "... my_startsys.o"
	@echo "... my_startsys.i"
	@echo "... my_startsys.s"
	@echo "... my_write.o"
	@echo "... my_write.i"
	@echo "... my_write.s"
.PHONY : help



#=============================================================================
# Special targets to cleanup operation of make.

# Special rule to run CMake to check the build system integrity.
# No rule that depends on this can have commands that come from listfiles
# because they might be regenerated.
cmake_check_build_system:
	$(CMAKE_COMMAND) -S$(CMAKE_SOURCE_DIR) -B$(CMAKE_BINARY_DIR) --check-build-system CMakeFiles/Makefile.cmake 0
.PHONY : cmake_check_build_system

