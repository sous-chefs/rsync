name "mysql_mirror"
description "Runs the rsync::cpan_mirror recipe and passes appropriate attributes."
run_list "rsync", "rsync::mysql_mirror"

# Attributes applied no matter what the node has set already.
override_attributes(
  "rsync" =>
  {
    "name"         => "mysql mirror" ,
    "source"       => "rsync://mysql.mirrors.pair.com/mysql" ,
    "destination"  => "/mirrors/mysql" ,
  }
)