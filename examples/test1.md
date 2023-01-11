---
title: Test Markdown witch embedded Tcl code.
author: Detlef Groth
date: 2023-01-11
---

## Header

This is some text.

```{.tcl}
set x 1
set x
```

Here some inline Tcl expression x is now `tcl set x`. 

This document was compiled at `tcl clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S"` CET.
