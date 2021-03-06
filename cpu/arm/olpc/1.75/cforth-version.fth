\ This file controls which CForth source version to include in the OFW build
\ and the method for fetching it

\ If CFORTH_VERSION is "modify", the repository will be cloned with git+ssh: so can push changes.
\ You need ssh access to the server.
\ macro: CFORTH_VERSION modify

\ If CFORTH_VERSION is "clone", the repository will be cloned with git:.  You won't be able to
\ push changes, but you will get the full metadata so you can use commands like git grep.
\ You don't need ssh access to the server.
\ macro: CFORTH_VERSION clone

\ Otherwise, the source code will be will be downloaded as a tarball via gitweb.
macro: CFORTH_VERSION d348a968b52746113e6016d741aff214b6cb8fd4

macro: CFORTH_BUILD_DIR cforth/build/arm-xo-1.75
