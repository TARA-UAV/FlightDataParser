###############
# FILE: dataparse.pl
# DESCRIPTION: Filters flight data for plotting in Matlab
# CREATED: 2013-03-25 SNR
################

use strict;
use warnings;

#--------
# Set parsing variables
my $infile = my $outfile = $ARGV[0]; #'alpha_171.txt'; #input file
my $numelements = 12; #number of variables per line
#---------

my $newline;
my $linecount=0;
my $keepcount=0;

# define output filename (input_foo.txt -> output_foo.txt)
$outfile =~ s/^.+_/output_/;

# Try to open the input file
open( ORIGINAL, "< $infile" ) or die "Can't open $infile : $!";
# Try to create the output file for writing
open( PARSED, "> $outfile" ) or die "Can't open $outfile : $!";


# Read through file
while(my $line = <ORIGINAL>){
	
	$linecount++;
	
	my $keep = 0;

 	chomp($line);
 	#print "$line\n";
 
 	my @values = split(',', $line);
 	
 	# Line contains correct number of elements
 	if (@values == $numelements) {
 		if (($values[0]>=400) && ($values[0]<=700)){
 			$keep = 1;
 			$newline = $line;
 		}	
 	}
 	
 	# Line contains more than the correct number of elements
 	if (@values > $numelements){
 		@values = splice(@values,@values-$numelements);
 		$newline = join(",",@values);
		$keep = 1;
 	}
 	
 	# Add good line to output file
 	if ($keep){
 		print PARSED $newline;
 		# Note: Windows new line uses \r\n; file displays incorrectly in Notepad
 		$keepcount++;
 	}
 	
 }
 
print "*** Parsing complete ***\n";
print "Lines in original file $infile: $linecount\n";
print "Lines in parsed file $outfile: $keepcount\n";
close ORIGINAL;
close PARSED;