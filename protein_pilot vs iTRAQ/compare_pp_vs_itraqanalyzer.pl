#!/usr/bin/perl -w
use strict;
use warnings;

my $count = 0;
my $pp_dir = 'D:\\ICGEB LAB\\Benchmarking of Quantwiz\\protein_pilot_results\\';
my $itraq_dir = 'D:\\ICGEB LAB\\Benchmarking of Quantwiz\\iTRAQ_consensus_xml\\output\\';

my $dir = 'D:/ICGEB Lab/Benchmarking of Quantwiz/protein_pilot_results/output/';
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
	# print "$file_1\n";
	# print "$file_2\n";
	my $file_a = $pp_dir . $file_1;
	my $file_b = $itraq_dir . $file_2;
	# print $file_a;
	# print $file_b;
	my $outfile = $comp . "_comparison";
	open(IN1, "$file_a") or die $!;
	# open(IN2, "$file_b") or die $!;
	open(OUT,">$dir\\$outfile") or die $!;
	
	my @pp=<IN1>;
	my $header=shift(@pp);
	my %pp;
	foreach my $line(@pp) {
		chomp $line;
		my @prpi=split/\t/,$line;
		if ($prpi[26] == 1) {
				next;		#26 = decoy
		}
		my $rt=sprintf("%.2f",($prpi[23]*60));	# Converting rt in seconds
		my $mz=sprintf("%.2f",$prpi[17]);
		$pp{$rt}{$mz}=$line;
	}
	
	# Author - Suruchi Aggarwal, Pragya Jaiswal
	########################################################################################################
	open(IN2,"$file_b") or die $!;
	my @ia=<IN2>;
	my $header2=shift (@ia);
	my %ia;
	foreach my $line(@ia) {
		chomp $line;
		my @ial=split/\t/,$line;
		my $mz=sprintf("%.2f",$ial[2]);
		my $RT=sprintf("%.2f",$ial[1]);
		$ia{$RT}{$mz}=$line;
	}
	
	#########################################################################################################
	print OUT "RT\tPP_RT\tIA_RT\tMZ\tPP_MZ\tIA_MZ\tPP_tittle\tTI_IA\t";
	chomp $header2;
	my @IA_head=split/\t/,$header2;
	for(my $i=4; $i<@IA_head; $i++) {
		print OUT "IA_$IA_head[$i]\t";
	}
	print OUT "IA_114:113\tIA_115:113\tIA_116:113\tIA_117:113\tIA_118:113\tIA_119:113\tIA_121:113\t";
	chomp $header;
	my @pp_head=split/\t/,$header;
	for(my $i=26;$i<@pp_head-1;$i++) {
		print OUT "PP_$pp_head[$i]\t";
	}
	print OUT "\n";
	foreach my $rt(sort (keys %pp)) {
		if (exists $ia{$rt}) {
			foreach my $mz(sort keys %{$pp{$rt}}) {
				if (exists $ia{$rt}{$mz}) {
					#print "$rt\t$mz\t";<>;
					my @line1=split/\t/,$pp{$rt}{$mz};
					my @line2=split/\t/,$ia{$rt}{$mz};
					print OUT "$rt\t$line1[23]\t$line2[1]\t$mz\t$line1[17]\t$line2[2]\t$line1[22]\t$line2[3]\t".$line2[4]."\t".$line2[5]."\t".$line2[6]."\t".$line2[7]."\t".$line2[8]."\t".$line2[9]."\t".$line2[10]."\t".$line2[11]."\t";
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
							if ($line2[$i] == 0 || $line2[$i] < 0) {
								print OUT "0.01\t";
							}
							else {
								print OUT $line2[$i]/$line2[4],"\t";
							}
						}
					}
					for(my $i = 26; $i < @line1-1; $i++) {
						print OUT "$line1[$i]\t";
					}
					print OUT "\n";
				}	
			}	
		}
	}
}