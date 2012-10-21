name "cpan_mirror"
description "Runs the rsync::cpan_mirror recipe and passes appropriate attributes."
run_list "rsync", "rsync::cpan_mirror"

# Attributes applied no matter what the node has set already.
override_attributes(
  "rsync" =>
  {
    "name"         => "cpan mirror" ,
    "source"       => "cpan.pair.com::CPAN" ,
    "destination"  => "/mirrors/CPAN" ,
  }
)