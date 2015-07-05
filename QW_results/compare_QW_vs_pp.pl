#!/usr/bin/perl -w
use strict;
use warnings;

my $count = 0;
my $pp_dir = 'D:\\ICGEB LAB\\Benchmarking of QW\\protein_pilot_results\\';
my $qw_dir = 'D:\\ICGEB LAB\\Benchmarking of QW\\QW_results\\';

my $dir = 'D:/ICGEB Lab/Benchmarking of QW/QW_results/QW_vs_PP_output/';
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

	# Author - Suruchi Aggarwal, Pragya Jaiswal
	open(IN1,$file_a) or die $!;
	my @pp=<IN1>;
	my $header=shift(@pp);
	my %pp;
	foreach my $line(@pp) {
		chomp $line;
		my @prpi=split/\t/,$line;
		if ($prpi[26] == 1) {
			next;		#26 = decoy
		}
		
		my $rt=sprintf("%.2f",($prpi[23]*60));#converting rt in seconds
		my $mz=sprintf("%.2f",$prpi[17]);
		$pp{$rt}{$mz}=$line;
	}


	open(IN2,$file_b) or die $!;
	my @QW=<IN2>;
	my $header2=shift(@QW);
	my %qw;
	foreach my $line(@QW) {
		chomp $line;
		my @qwl=split/\t/,$line;
		my $mz1=(split/\s+/,$qwl[2])[0]; ##separate mz and base intensity
		my $mz=sprintf("%.2f",$mz1);
		my $RT=sprintf("%.2f",$qwl[1]);
		$qw{$RT}{$mz}=$line;
	}

	
	print OUT "RT\tPP_RT\tQW_RT\tMZ\tPP_MZ\tQW_MZ\tPP_title\tQW_title\t";
	chomp $header2;
	my @QW_head=split/\t/,$header2;
	for(my $i=3;$i<@QW_head;$i++) {
		print OUT "QW_$QW_head[$i]\t";
	}
	chomp $header;
	my @pp_head=split/\t/,$header;
	for(my $i=26;$i<@pp_head-1;$i++) {
		print OUT "PP_$pp_head[$i]\t";
	}

	print OUT "\n";
	foreach my $rt(sort (keys %pp)) {
		if (exists $qw{$rt}) {
			foreach my $mz(sort keys %{$pp{$rt}}) {
				if (exists $qw{$rt}{$mz}) {
					#print "$rt\t$mz\t";<>;
					my @line1=split/\t/,$pp{$rt}{$mz};
					my @line2=split/\t/,$qw{$rt}{$mz};
					print OUT "$rt\t$line1[23]\t$line2[1]\t$mz\t$line1[17]\t$line2[2]\t$line1[22]\t$line2[0]\t";
					for(my $i=3;$i<@line2;$i++) {
						print OUT "$line2[$i]\t";
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
