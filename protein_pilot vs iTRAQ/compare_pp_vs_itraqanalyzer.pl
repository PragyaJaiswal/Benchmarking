#!/usr/bin/perl -w
use strict;
use warnings;

my $count = 0;
my $pp_dir = 'D:\\ICGEB LAB\\Benchmarking of Quantwiz\\protein_pilot_results\\';
my $itraq_dir = 'D:\\ICGEB LAB\\Benchmarking of Quantwiz\\iTRAQ_consensus_xml\\output\\';

opendir (PP_DIR, $pp_dir) or die "Cannot open directory $pp_dir: $!";
opendir (iTRAQ_DIR, $itraq_dir) or die "Cannot open directory $itraq_dir: $!";

my $itraq_count = 0;
while (my $itraq_file = readdir(iTRAQ_DIR)) {
	my $pp_count = 0;
	$itraq_count += 1;
	if (index($itraq_file, 'tsv') != -1) {
		# print "iTRAQ file: $itraq_file\n";
		my $filename =$itraq_file;
		$filename =~ s/\.tsv//;
		print "iTRAQ filename: $filename\n";
		
		while (my $pp_file = readdir(PP_DIR)) {
			# print "Protein Pilot file: $pp_file\n";
			$pp_count += 1;
			if (index($pp_file, '_SpectrumSummary.txt') == -1) {
				print "Not the proper file format. File not parsed.\n";
				next;
			}

			my $comp = $pp_file;
			$comp =~ s/\_SpectrumSummary.txt//;
			print "Protein Pilot filename: $comp\n";
			# if ($pp_count == 3) {
			# 	print "Ending.";
			# 	last;
			# }
			if ($filename eq $comp) {
				print "Same files found.\n";
				# compare($pp_file, itraq_file);
				last;
			}
			else {
				print "Here.\n";
				next;
			}
		}
	}
}