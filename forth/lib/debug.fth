\ See license at end of file

\ Debugger.  Thanks, Mike Perry, Henry Laxen, Mark Smeder.
\
\ The debugger lets you single step the execution of a high level
\ definition.  To invoke the debugger, type debug xxx where xxx is
\ the name of the word you wish to trace.  When xxx executes, you will
\ get a single step trace showing you the word within xxx that
\ is about to execute, and the contents of the parameter stack.
\ Debugging makes everything run slightly slower, even outside
\ the word being debugged.  see debug-off
\
\ debug name	Mark that word for debugging
\ stepping	Debug in single step mode
\ tracing	Debug in trace mode
\ debug-off	Turn off the debugger (makes the system run fast again)
\ resume	Exit from a pushed interpreter (see the f keystroke)
\
\ Keystroke commands while you're single-stepping:
\   d		go down a level
\   u		go up a level
\   c		continue; trace without single stepping
\   g		go; turn off stepping and continue execution
\   f		push a Forth interpreter;  execute "resume" to get back
\   q		abort back to the top level

only forth also definitions

false value scrolling-debug?

hex
headerless
variable slow-next?  slow-next? off

only forth hidden also forth also definitions
bug also definitions
variable step? step? on
variable res
headers
false value first-time?
d# 10 circular-stack: locations

: (debug)       (s low-adr hi-adr -- )
   unbug   1 cnt !   ip> !   <ip !   pnext
   slow-next? @ 0=  if
      here  low-dictionary-adr  slow-next
      slow-next? on
   then
   step? on
   true is first-time?
;
headerless
: 'unnest   (s pfa -- pfa' )
   begin   dup ta1+  swap  token@ ['] unnest =  until
;
: set-<ip  (s pfa -- )
   <ip !  <ip @  ip> @  u>=  if  <ip @  'unnest  ip> !  then
;

headers
\ Enter and leave the debugger
forth definitions
: defer?  ( acf -- flag )  word-type  ['] key word-type =  ;
: (debug  ( acf -- )
   begin  dup defer?  while  behavior  repeat

   dup colon-cf?  0= abort" Not a colon definition"
   >body dup 'unnest  (debug)
;
\ Debug the caller
: debug-me  (s -- )  ip@ find-cfa (debug  ;
: debug(  (s -- )  ip@ dup 'unnest (debug)  ;
: )debug  (s -- )  ip@ ip> !  ;
: debug-off (s -- )
   unbug  here  low-dictionary-adr  fast-next slow-next? off
;
bug definitions
headerless
\ Go up the return stack until we find the return address left by our caller
: caller-ip  ( rp -- ip )
   begin
      na1+ dup @  dup  in-dictionary?  if    ( rs-adr ip )
         ip>token token@
         dup ['] execute =  over defer? or  swap <ip @ body> =  or
      else
         drop false
      then
   until                                     ( rs-adr )
   @ ip>token
;
: up1  ( rp -- )
   caller-ip
   dup find-cfa   ( ip cfa )
   dup ['] catch = if  2drop exit  then
   cr ." [ Up to " dup .name ." ]" cr  ( ip cfa )
   over token@ .name                   ( ip cfa )
   >body swap 'unnest (debug)
;
defer to-debug-window  ' noop is to-debug-window
defer restore-window   ' noop is restore-window
: .debug-short-help  ( -- )
  ." Stepper keys: <space> Down Up Continue Forth Go Help ? See $tring Quit" cr
;
: .debug-long-help  ( -- )
   ." Key     Action" cr
   ." <space> Execute displayed word" cr
   ." D       Down: Step down into displayed word" cr
   ." U       Up: Finish current definition and step in its caller" cr
   ." C       Continue: trace current definition without stopping" cr
   ." F       Forth: enter a subordinate Forth interpreter" cr
   ." G       Go: resume normal execution (stop debugging)" cr
   ." H       Help: display this message" cr
   ." ?       Display short list of debug commands" cr
   ." R       RSTrace: Show contents of Forth return stack" cr
   ." S       See: Decompile definition being debugged" cr
   ." $       Display top of stack as adr,len text string" cr
   ." \       Display Forth return stack as numbers (like the data stack)" cr
   ." Q       Quit: abandon execution of the debugged word" cr
;
d# 24 constant cmd-column
: to-cmd-column  ( -- )  cmd-column to-column  ;

0 value stack-line
d# 45 constant stack-column
\ 0 0 2value result-loc
0 value result-line
0 value result-col
: to-stack-location  ( -- )  stack-column stack-line at-xy  kill-line  ;
: show-partial-stack  ( -- )
   to-stack-location

   ." \ "
   depth 0<  if  ." Stack Underflow" sp0 @ sp!  exit  then
   depth 0=  if  ." Empty"  exit  then
   depth 4 >  if  ." .. "  then
   depth  depth 5 - 0 max  ?do  depth i - 1- pick n.  loop
;

\ : save-result-loc  ( -- )  #out @ #line @ to result-loc  ;
\ : to-result-loc  ( -- )  result-loc at-xy  ;
: save-result-loc  ( -- )  #out @ to result-col   #line @ to result-line  ;
: to-result-loc  ( -- )  result-col result-line at-xy  ;

0 value rp-mark

\ set-package is a hook for Open Firmware.  When Open Firmware is loaded,
\ set-package should be set to a word that sets the active package to the
\ package corresponding to the current instance.  set-package is called
\ by the "F" key, so the user will see the methods of the current instance.
headers
defer   set-package  ' noop is   set-package
defer unset-package  ' noop is unset-package
headerless

: try  ( n acf -- okay? )
   catch  ?dup if  .error drop false  else  true  then
;
: executer  ( xt -- xt' )
   dup ['] execute =  over ['] catch =  or  if  drop dup  then
;
d# 72 constant /#buf
/#buf buffer: #buf-save
variable hld-save
variable show-rstack  \ Show the return stack along with the data stack?
variable hex-stack    \ Show the data stack in hex?
: save#     ( -- )  #-buf /#buf -  #buf-save  d# 72 move    hld @  hld-save !  ;
: restore#  ( -- )  #buf-save  #-buf /#buf -  d# 72 move    hld-save @  hld !  ;
: (.rs  ( -- )
   show-rstack @ 0=  if  exit  then
   ." return-stack: "
   push-hex
   rp0 @ rp@ - /n /
   6 do   \ It appears that skipping the first 6 entries on the stack skips the debug goo on the rs
      rp@ i /n * + @ .
   loop
   pop-base
;
: (trace  ( -- )
   first-time?  if
      scrolling-debug?  if
         ??cr
         ip@  <ip @ =  if  ." : "  else  ." Inside "  then
         <ip @ find-cfa .name
      else
         page
         d# 78 rmargin !
         ." Callers: "  rp0 @ rp@ na1+ rslist kill-line cr
         \ XXX the following is wrong when popping up
         ip@  <ip @ =  if  
            #line @ is stack-line \ So the initial stack is displayed in the right place
         then
         d# 40 rmargin !
         ip@ debug-see
         cr
\         ip@  <ip @ <>  if  
\            ip@ ip>position  if   ( col row )
\               swap 
\               is stack-line
\            then
\            #line @ is stack-line \ So the initial stack is displayed in the right place
 \        then
      then
      0 show-rstack !
      false is first-time?
      rp@ is rp-mark
   then

   begin
      step? @  if  to-debug-window  then
      save#
      scrolling-debug?  if
         cmd-column 2+ to-column

         hex-stack @  if  push-hex  then
         ." ( " .s    \ Show data stack
         hex-stack @  if  pop-base  then
         show-rstack @  if  (.rs  then   \ Show return stack
         ." )"
         restore#

         cr
         ['] noop is indent
         ip@ .token drop		  \ Show word name
         ['] (indent) is indent
         to-cmd-column
      else
         save-result-loc
         show-partial-stack
        
         ip@ ip-set-cursor
         #line @ to stack-line
      then

      step? @  key? or  if
         step? on  res off
         key dup bl <  if  drop bl  then
         scrolling-debug?  if  dup emit  else  to-result-loc  then  upc
         restore-window
         scrolling-debug?  if  reset-page  then
         case
            ascii D  of  ip@ token@ executer  ['] (debug try endof \ Down
	    ascii U  of  rp@ ['] up1 try                     endof \ Up
            ascii C  of  step? @ 0= step? !           true   endof \ Continue
            ascii F  of
               cr ." Type 'resume' to return to debugger" cr
               set-package  interact  unset-package   false
            endof						   \ Forth
            ascii G  of  debug-off  cr  exit                 endof \ Go
            ascii H  of  cr .debug-long-help          false  endof \ Help
            ascii R  of  cr rp0 @ rp@ na1+ (rstrace   false  endof \ RSTrace
            ascii S  of  cr <ip @ body> (see)         false  endof \ See
            ascii ?  of  cr .debug-short-help	      false  endof \ Short Help
            ascii $  of  space 2dup type cr to-cmd-column false endof \ String
            ascii Q  of  cr ." unbug" abort           true   endof \ Quit
            ascii (  of  ip@ set-<ip                  false  endof
            ascii <  of  ip@ ta1+ set-<ip  1 cnt !    false  endof
            ascii )  of  ip@ ip> !  1 cnt !           false  endof
            ascii *  of  ip@ find-cfa dup <ip !  'unnest ip> !  false  endof
            ascii \  of  show-rstack @ 0= show-rstack ! false endof
            ascii X  of  hex-stack @ 0= hex-stack !   false  endof
            ascii V  of  scrolling-debug? 0= to scrolling-debug?
                         scrolling-debug? 0=  if  true to first-time?  then  false  endof
            ( default )  true swap
         endcase
      else
         true
      then
   until
   restore#
   scrolling-debug? 0=  if  to-result-loc  then
   ip@ token@  dup ['] unnest =  swap ['] exit =  or  if
      cr  true is first-time?
   then
   pnext
;
' (trace  'debug token!

headers

only forth bug also forth definitions

: debug  \ name (s -- )
   '
   .debug-short-help
   (debug
;
: debugging  ( -- )  ' .debug-short-help  dup (debug  execute  ;
: resume    (s -- )  true is exit-interact?  pnext  ;
: stepping  (s -- )  step? on  ;
: tracing   (s -- )  step? off ;

only forth also definitions

\ LICENSE_BEGIN
\ Copyright (c) 2006 FirmWorks
\ 
\ Permission is hereby granted, free of charge, to any person obtaining
\ a copy of this software and associated documentation files (the
\ "Software"), to deal in the Software without restriction, including
\ without limitation the rights to use, copy, modify, merge, publish,
\ distribute, sublicense, and/or sell copies of the Software, and to
\ permit persons to whom the Software is furnished to do so, subject to
\ the following conditions:
\ 
\ The above copyright notice and this permission notice shall be
\ included in all copies or substantial portions of the Software.
\ 
\ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
\ EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
\ MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
\ NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
\ LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
\ OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
\ WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
\
\ LICENSE_END
