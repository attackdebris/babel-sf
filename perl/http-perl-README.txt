It is possible that http-perl.pl requires extra perl dependancies, namely IO::All.
IO::All combines all of the best Perl IO modules into a single object.

Thus, All.tgz is included in the babel-sf download for when you really need this functionality!
Once extracted the contents of the file should be dropped into your local perl path.

For example:

On Ubuntu 12.04 the 'All' directory and 'All.pm' were dropped into /usr/share/perl/5.14/IO/
On Debian the 'All' directory and 'All.pm' were dropped to /usr/share/perl5/IO/