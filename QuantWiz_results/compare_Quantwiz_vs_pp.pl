#!/usr/bin/perl -w
use strict;
use warnings;

my $count = 0;
my $pp_dir = 'D:\\ICGEB LAB\\Benchmarking of Quantwiz\\protein_pilot_results\\';
my $qw_dir = 'D:\\ICGEB LAB\\Benchmarking of Quantwiz\\Quantwiz_results\\';

my $dir = 'D:/ICGEB Lab/Benchmarking of Quantwiz/Quantwiz_results/QW_vs_PP_output/';
mkdir $dir unless -d $dir;

opendir (PP_DIR, $pp_dir) or die "Cannot open directory $pp_dir: $!";
opendir (QW_DIR, $qw_dir) or die "Cannot open directory $qw_dir: $!";

my $qw_count = 0;
my $pp_count = 0;
my $pp_total_done = 0;

my @pp_files = readdir(PP_DIR);

while (my $qw_file = readdir(QW_DIR)) {
	if (index($qw_file, 'tsv') != -1) {
		$qw_count += 1;
		print "QW file: $qw_file\n";
		my $filename =$qw_file;
		$filename =~ s/basecorrec\.tsv//;
		print "QW filename: $filename\n";
		
		# while (my $pp_file = readdir(PP_DIR)) {
		foreach my $pp_file (@pp_files) {
			# print "Protein Pilot file: $pp_file\n";			
			$pp_total_done += 1;
			# print "Number of times PP files encountered: $pp_total_done\n";

			if (index($pp_file, '_SpectrumSummary.txt') == -1) {
				print "Not the proper file format. Skipping file.\n";
				print "File not parsed.\n";
				next;
			}

			my $comp = $pp_file;
			$comp =~ s/_SpectrumSummary\.txt//;
			# print "Protein Pilot filename: $comp\n";
			
			# if ($pp_count == 5) {
			# 	print "Ending.";
			# 	last;
			# }
			if ($filename eq $comp) {
				print "Same files found.\n";
				$pp_count += 1;
				# print "PP file name: $comp";
				compare($pp_file, $qw_file, $comp);
				print "Number of Protein Pilot files processed: $pp_count of 45.\n";
				last;
			}
			else {
				next;
			}
		}
	}
	print "QW files processed: $qw_count of 45.\n";
}

closedir(PP_DIR);
closedir(QW_DIR);

sub compare {
	my ($file_1, $file_2, $comp) = @_;
	# print "$file_1\n";
	# print "$file_2\n";
	my $file_a = $pp_dir . $file_1;
	my $file_b = $qw_dir . $file_2;
	# print $file_a;
	# print $file_b;
	my $outfile = $comp . "_comparison";
	open(OUT,">$dir\\$outfile") or die $!;

}