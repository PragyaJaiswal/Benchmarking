#!/usr/bin/perl -w
use strict;
use warnings;

my $count = 0;
my $itraq_dir = 'D:\\ICGEB LAB\\Benchmarking of Quantwiz\\iTRAQ_consensus_xml\\output\\';
my $qw_dir = 'D:\\ICGEB LAB\\Benchmarking of Quantwiz\\Quantwiz_results\\';

my $dir = 'D:/ICGEB Lab/Benchmarking of Quantwiz/Quantwiz_results/QW_vs_iTRAQ_output/';
mkdir $dir unless -d $dir;

opendir (iTRAQ_DIR, $itraq_dir) or die "Cannot open directory $itraq_dir: $!";
opendir (QW_DIR, $qw_dir) or die "Cannot open directory $qw_dir: $!";

my $qw_count = 0;
my $itraq_count = 0;
my $qw_total_done = 0;

my @qw_files = readdir(QW_DIR);

while (my $itraq_file = readdir(iTRAQ_DIR)) {
	if (index($itraq_file, 'tsv') != -1) {
		$itraq_count += 1;
		print "iTRAQ file: $itraq_file\n";
		my $filename =$itraq_file;
		$filename =~ s/\.tsv//;
		print "iTRAQ filename: $filename\n";
		
		foreach my $qw_file (@qw_files) {
			# print "Protein Pilot file: $pp_file\n";			
			$qw_total_done += 1;
			# print "Number of times PP files encountered: $pp_total_done\n";

			if (index($qw_file, 'basecorrec.tsv') == -1) {
				# print "Not the proper file format. Skipping file.\n";
				# print "File not parsed.\n";
				next;
			}

			my $comp = $qw_file;
			$comp =~ s/basecorrec\.tsv//;
			# print "Protein Pilot filename: $comp\n";
			
			# if ($pp_count == 5) {
			# 	print "Ending.";
			# 	last;
			# }
			if ($filename eq $comp) {
				print "QW file: $qw_file";
				print "Same files found.\n";
				$qw_count += 1;
				compare($itraq_file, $qw_file, $comp);
				print "Number of QuantWiz files processed: $qw_count of 45.\n";
				last;
			}
			else {
				next;
			}
		}
	}
	print "QW files processed: $qw_count of 45.\n";
}

closedir(iTRAQ_DIR);
closedir(QW_DIR);

sub compare {
	my ($file_1, $file_2, $comp) = @_;
	# print "$file_1\n";
	# print "$file_2\n";
	my $file_a = $itraq_dir . $file_1;
	my $file_b = $qw_dir . $file_2;
	# print $file_a;
	# print $file_b;
	my $outfile = $comp . "_comparison";
	open(OUT,">$dir\\$outfile") or die $!;

}