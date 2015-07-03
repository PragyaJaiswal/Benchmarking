#!/usr/bin/perl -w
use strict;
use warnings;

my $count = 0;
my $pp_dir = 'D:\\ICGEB LAB\\Benchmarking of Quantwiz\\protein_pilot_results\\';
my $itraq_dir = 'D:\\ICGEB LAB\\Benchmarking of Quantwiz\\iTRAQ_consensus_xml\\output\\';

my @files_in_itraqdir = <$itraq_dir/*>;
my $tot_files_in_itraq = @files_in_itraqdir;
print "Total files in iTRAQ folder: $tot_files_in_itraq";
my @files_in_ppdir = <$pp_dir/*>;
my $tot_files_in_pp = @files_in_ppdir;
print "Total files in PP folder: $tot_files_in_pp";

opendir (PP_DIR, $pp_dir) or die "Cannot open directory $pp_dir: $!";
opendir (iTRAQ_DIR, $itraq_dir) or die "Cannot open directory $itraq_dir: $!";

my $itraq_count = 0;
while (my $itraq_file = readdir(iTRAQ_DIR)) {
	my $pp_count = 0;
	if (index($itraq_file, 'tsv') != -1) {
		$itraq_count += 1;
		print "iTRAQ file: $itraq_file\n";
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
			# if ($pp_count == 5) {
			# 	print "Ending.";
			# 	last;
			# }
			if ($filename eq $comp) {
				print "Same files found.\n";
				compare($pp_file, $itraq_file);
				last;
			}
			else {
				print "Here.\n";
				next;
			}
		}
	}
	print "iTRAQ files processed: $itraq_count of 45.\n";
}

closedir(PP_DIR);
closedir(iTRAQ_DIR);

sub compare {
	my ($file_a, $file_b) = @_;
}