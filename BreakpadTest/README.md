Breakpad Sample Application
---------------------------

This is a simple demo application to test the Breakpad functionality..  It simply allows the end user to specify the crash upload URL and optionally attach log files that will be uploaded with the crash report.

Utilities
=========
In the Utilities folder are the various utiltiis to prep the debug symbols, upload them to a server, and process the received dumps.

dump_syms (OS X 10.6 binary)
    This utility dumps the symbols from the executable in the breakpad format.
    See the Dump Symbols build phase on the main target for how this works
    In general it is dump_syms product > symbolfile
    For OS X there is some extra work to handle the multiple architectures that can be in a dump file

symupload (OS X 10.6 binary)
    This utility uploads symbol files via POST to a url
    This is used to send the dump symbols to the crash report server so it can process the minidumps from the crash reporter.
    Read below about the post structure and how the files should be stored on disk for the minidump_stackwalk utility to proces things

Linux/minidump_stackwalk (ELF32)
    This tool take a minidump file and a directory with the symbol files and symbolocates the minidump into either a human readable format or a machine readable format. (method names, line numbers, etc..)
    It's currently a linux only bin as the stock breakpad Mac project doesn't generate a mac cli tool for this

Web/upload.php
    A sample PHP script to receive the crash report content.

symupload POST
==============
A multipart/form-data encoded POST that has the following keys

os
    The operating system type (e.g. mac, Linux, windows, ios, etc..)
debug_file
    The debug file name
code_file
    The code file name (same as debug_file)
cpu
    The CPU architecture for the debug symbol. (x86, x86_64, ppc, ppc64, etc..)
debug_identifier
    The unique identifier for this debug symbol file
symbol_file
    the actual symbol file post
    you should ignore the filename as it's fixed as minidump.dmp
    this can be quite large depending on the application code size.

Symbol files should be processed into a directory structure like this
${code_file}/${debug_identifier}/${code_file}.sym

When running the minidump_stackwalk utility it will expect files in this structure in order to find them.

crash report POST
=================
A multipart/form-data encoded POST that has the following keys

comments
    These are optional comments from the user (currently enabled via the Info.plist)
email
    An optional email from the user (current enabled via the Info.plist)
ptime
    process uptime in milliseconds
ver
    the product version number
prod
    The product Identifier (name)
guid
    a unique client ID the crash report (will be the same for all reports from the same client & application)
upload_file_minidump
    the actual minidump file of the crash.. note if a crash dump couldn't be grabbed this won't be included (optional)
    you should ignore the filename as it's fixed as minidump.dmp
log
    a tar.bz2 of the tails from the specified log files (at least on OS X, unsure about windows or linux at this time)
    you should ignore the filename as it's fixed as minidump.dmp

Note an application may add custom keys that will also be sent up with the post data.

