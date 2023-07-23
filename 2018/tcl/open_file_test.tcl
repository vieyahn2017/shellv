set v 1
set fh [open "open_test_a.txt" w]
fconfigure $fh -translation crlf

while { $v!=""} {
    puts -nonewline "please input your name:"
    gets stdin v
    puts $fh "your name $v"
}

close $fh
