# /lib/ku-base/fast_file_fingerprint.pl (perl function)

my $__fast_file_fingerprint_version	= "1.1 (2020/01)";
my $__fast_file_fingerprint_timestamp	= 1575846666;

sub fast_file_fingerprint
{
	my ($IFILE,$bufsize)	= @_;

	if (!defined $IFILE || scalar(@_) > 2) {
		die fast_file_fingerprint_usage();
	}

	return $__fast_file_fingerprint_timestamp	if ($IFILE eq "--timestamp");

	$bufsize	= 1	if (!defined $bufsize);
	$bufsize	*= 1024;

	my $sizelimit	= 3.1 * $bufsize;
	my @stats;
	my $buf;
	my $offset;
	my $cnt;
	my $md5		= new Digest::MD5;

	@stats	= stat( $IFILE );

	open( IFILE, "<$IFILE" ) or return;
	$md5->reset();

	if ($stats[7] < $sizelimit) {
		$md5->addfile(IFILE);
	} else {
		# first $bufsize bytes
		#
		$cnt = read( IFILE, $buf, $bufsize ) or return;
		##printf( STDERR "D#    offset %10d: read %d bytes\n", $offset, $cnt );
		$md5->add($buf);

		# middle
		#
		$offset = ($stats[7] - $bufsize) / 2;
		seek( IFILE, $offset, 0 )		or return;
		$cnt = read( IFILE, $buf, $bufsize )	or return;
		##printf( STDERR "D#    offset %10d: read %d bytes\n", $offset, $cnt );
		$md5->add($buf);

		# at end
		#
		$offset = $bufsize * -1;
		seek( IFILE, $offset, 2 )		or return;
		$cnt = read( IFILE, $buf, $bufsize )	or return;
		##printf( STDERR "D#    offset %10d: read %d bytes\n", $offset, $cnt );
		$md5->add($buf);

		$md5->add($stats[7]);
	}
	close( IFILE ) or return;

	return	$md5->hexdigest();
}


sub fast_file_fingerprint_usage
{
	return "
error, wrong parms

USAGE:

	use Digest::MD5;

	fast_file_fingerprint( inputfile [, bufsize_in_Kb] )
	fast_file_fingerprint( '--timestamp' )

   	print fast_file_fingerprint_help();
";
}

sub fast_file_fingerprint_help
{
	my $version	= "1.0";
	my $date	= "2019/12";

	return "
== fast_file_fingerprint v.$version ($date) ==

computes a \"smart\" md5 fingerprint of a file, using this algo:

to avoid reading the whole file the program reads only 3 blocks of 1Kb,
at beginning, at end, and in the middle, for a total of max 3Kb read
each file

the md5 fingerprint is then generated using the concatenation of the
3 blocks above, plus the file size to add more precision

if the actual filesize is less then the 3 blocks, then the whole file
will be read instead, so the md5 is computed in the usual way

the blocksize can be changed using the second parm, in Kb

this fingerprint is not accurate as the whole file was used, but will
suffice for most applications that needs quick fingerprinting large files

returns undefined if the file does not exists, cannot be read or any
error reading/seeking

to avoid using an old fingerprint (one generated in the past, when
a different fast algo was used, ie by a previous version of this
function) we provide a timestamp (seconds since the epoch) of the
date when this version of this function was released; call this
function with '--timestamp' as filename for it

you can compare your saved fingerprints age (if you have this
option) and invalidate them if needed; ie, if I save a list of
fingerprints in a file, then can compare the last-changed date
of that file:

 my \@stats = stat( \$listfile );
 if (\$stats[9] < fast_file_fingerprint('--timestamp')) {
 	....INVALIDATE...
 }

";
}


