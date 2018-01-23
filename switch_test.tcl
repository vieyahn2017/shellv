set c "http://www.microsoft.com"

switch -regexp $c {
    "http://.+"  {puts "$c is a http url"}
    .+@.+        {puts "$c is an email address"}
    ftp://.+     {puts "$c is a ftp url"}
    default      {puts "Other ..."}
}

proc switch_fn {n} {
    switch -regexp $n {
        "http://.+"  {puts "$n is a http url"}
        .+@.+        {puts "$n is an email address"}
        ftp://.+     {puts "$n is a ftp url"}
        default      {puts "Other ..."}
    }
}

set my_email vieyahn@163.com
switch_fn $my_email
