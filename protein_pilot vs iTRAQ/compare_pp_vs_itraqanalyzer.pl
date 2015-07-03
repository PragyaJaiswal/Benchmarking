#!/usr/bin/perl -w
use strict;
use warnings;

my $count = 0;
my $pp_dir = 'D:\\ICGEB LAB\\Benchmarking of Quantwiz\\protein_pilot_results\\';
my $itraq_dir = 'D:\\ICGEB LAB\\Benchmarking of Quantwiz\\iTRAQ_consensus_xml\\output\\';

$dir = './output/';
mkdir $dir unless -d $dir;

opendir (PP_DIR, $pp_dir) or die "Cannot open directory $pp_dir: $!";
opendir (iTRAQ_DIR, $itraq_dir) or die "Cannot open directory $itraq_dir: $!";

my $itraq_count = 0;
my $pp_count = 0;
my $pp_total_done = 0;

my @pp_files = readdir(PP_DIR);

while (my $itraq_file = readdir(iTRAQ_DIR)) {
	if (index($itraq_file, 'tsv') != -1) {
		$itraq_count += 1;
		print "iTRAQ file: $itraq_file\n";
		my $filename =$itraq_file;
		$filename =~ s/\.tsv//;
		print "iTRAQ filename: $filename\n";
		
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
			$comp =~ s/\_SpectrumSummary.txt//;
			# print "Protein Pilot filename: $comp\n";
			
			# if ($pp_count == 5) {
			# 	print "Ending.";
			# 	last;
			# }
			if ($filename eq $comp) {
				print "Same files found.\n";
				$pp_count += 1;
				compare($pp_file, $itraq_file, $comp);
				print "Number of Protein Pilot files processed: $pp_count of 45.\n";
				last;
			}
			else {
				next;
			}
		}
	}
	print "iTRAQ files processed: $itraq_count of 45.\n";
}

closedir(PP_DIR);
closedir(iTRAQ_DIR);

sub compare {
	my ($file_1, $file_2, $comp) = @_;
	print "$file_1\n";
	print "$file_2\n";
	my $file_a = $pp_dir . $file_1;
	my $file_b = $itraq_dir . $file_2;
	my $outfile = $comp . "_comparison";
	open(IN1, $file_a) or die $!;
	open(IN2, $file_b) or die $!;
	print "IN1";
	print "IN2";
	open(OUT,">.\\output\\outfile") or die $!;
	print OUT "RTIN\tRTINPP\tRTIN_itaz\tMZ_itrq\tMZitaz\ttittle_itrq\ttotal_it_itaz\t113_itaz\t114\t115\t116\t117\t118\t119\t121\t114:113\t115:113\t116:113\t117:113\t118:113\t119:113\t121:113\tdecoy\n";
	my @arr1=<IN1>;#pp
	shift @arr1;
	while (<IN2>)
	{
		chomp $_;
		if ($_=~m/^ID/) {
			
		}
		else {
			my @line2=split/\t/,$_;
			foreach my $lane(@arr1) {
				chomp $lane;
				my @line1=split/\t/,$lane;
				my $t1=$line1[23]*60;
				my $RT1=sprintf("%.2f",$t1);
				my $RT2=sprintf("%.2f",$line2[1]);
				my $mz=$line1[17];
				# print "$line2[1]\t$line1[2]\t$mz";<>;
				my $mz1=sprintf("%.2f",$mz);
				my $mz2=sprintf("%.2f",$line2[2]);
				if ( $RT1== $RT2 && $mz1 == $mz2) {
					print OUT "$RT1\t$line1[23]\t$line2[1]\t$mz\t$line2[2]\t$line1[22]\t$line2[3]\t".$line2[4]."\t".$line2[5]."\t".$line2[6]."\t".$line2[7]."\t".$line2[8]."\t".$line2[9]."\t".$line2[10]."\t".$line2[11]."\t";
				   
					for(my $i=5;$i<=$#line2; $i++) {
						if ($line2[4]==0) {
							if ($line2[$i]==0 || $line2[$i]<0) {
									print OUT "0\t";
							}
							if ($line2[$i]>0) {
							 print OUT "100\t";
							}
						}
						elsif($line2[4]>0) {
							if ($line2[$i]==0 || $line2[$i]<0) {
								print OUT "0.01\t";
							}
							else {
							print OUT $line2[$i]/$line2[4],"\t";
						   }
						}
					}
					for(my $i=26; $i<@line1-1;$i++) {
						print OUT "$line1[$i]\t";
					}
					print OUT "\n";	
				}
			}
		}
	}
}