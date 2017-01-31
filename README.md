# datasig
Generating signature of data structures to check compatibility

The aim is to check for data structure change during compile time to catch incompatible binary changes.

This idea is to use gdb to recursively dump a global structure (mainly offset and size of each fields) and generate checksum of the output.
