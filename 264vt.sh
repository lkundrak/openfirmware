set -e
set -x

toke -Idev/video -dxpression -dtiny -o tiny-264vt.fc 264vt.fs
toke -Idev/video -dxpression -dno-driver -o medium-264vt.fc 264vt.fs
toke -Idev/video -dxpression -dno-driver -ddebug -o debug-264vt.fc 264vt.fs
toke -Idev/video -dxpression -o 264vt.fc 264vt.fs

wc -c 264vt.fc debug-264vt.fc medium-264vt.fc tiny-264vt.fc

:<<:
[lkundrak@bzdocha grub-ofw]$ toke -ab
Welcome to toke - FCode tokenizer v1.0.3
(C) Copyright 2001-2010 Stefan Reinauer.
(C) Copyright 2006 coresystems GmbH
(C) Copyright 2005 IBM Corporation.  All Rights Reserved.
This program is free software; you may redistribute it under the terms of
the GNU General Public License v2. This program has absolutely no warranty.

toke: invalid option -- 'a'
toke: invalid option -- 'b'
Segmentation fault (core dumped)
[lkundrak@bzdocha grub-ofw]$
:
