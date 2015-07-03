#!/usr/bin/perl -w
use strict;
use warnings;

my $count = 0;
my $pp_dir = 'D:\\ICGEB LAB\\Benchmarking of Quantwiz\\protein_pilot_results\\';
my $itraq_dir = 'D:\\ICGEB LAB\\Benchmarking of Quantwiz\\iTRAQ_consensus_xml\\output\\';

opendir (PP_DIR, $pp_dir) or die "Cannot open directory $pp_dir: $!";
opendir (iTRAQ_DIR, $itraq_dir) or die "Cannot open directory $itraq_dir: $!";


while (my $itraq_file = readdir(iTRAQ_DIR)) {
	my $filename =$itraq_file;
	if (index($itraq_file, 'tsv') != -1) {
		$filename =~ s/\.tsv//;
		print "$filename 1st print\n";
		
		while (my $pp_file = readdir(PP_DIR)) {
			print "$pp_file 2nd print\n";
			print "$itraq_file 3rd print\n";
			
			my $comp = $pp_file;
			$comp =~ s/\.tsv//;
			# print "$comp\n";
			if ($filename eq $comp) {
				print "Hi\n";
				print "$comp 4th print\n";
				# compare($pp_file, itraq_file);
			}
			else {
				print "Here.";
				next;
			}
		}
	}
}