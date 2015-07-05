#!/usr/bin/perl -w
use strict;
use warnings;

my $count = 0;
my $itraq_dir = 'D:\\ICGEB LAB\\Benchmarking of QW\\iTRAQ_consensus_xml\\output\\';
my $qw_dir = 'D:\\ICGEB LAB\\Benchmarking of QW\\QW_results\\';

my $dir = 'D:/ICGEB Lab/Benchmarking of QW/QW_results/QW_vs_iTRAQ_output/';
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

	# Author - Suruchi Aggarwal, Pragya Jaiswal
	open(IN1,$file_a) or die $!;
	my @ia=<IN1>;
	my $header=shift (@ia);
	my %ia;
	foreach my $line(@ia)
	{
		chomp $line;
		my @ial=split/\t/,$line;
		my $mz=sprintf("%.2f",$ial[2]);
		my $RT=sprintf("%.2f",$ial[1]);
		$ia{$RT}{$mz}=$line;
	}


	open(IN2,$file_b) or die $!;
	my @QW=<IN2>;
	my $header2=shift(@QW);
	my %qw;
	foreach my $line(@QW)
	{
		chomp $line;
		my @qwl=split/\t/,$line;
		my $mz1=(split/\s+/,$qwl[2])[0];##separate mz and base intensity
		my $mz=sprintf("%.2f",$mz1);
		my $RT=sprintf("%.2f",$qwl[1]);
		$qw{$RT}{$mz}=$line;
	}

	print OUT "RT\tIA_RT\tQW_RT\tMZ\tIA_MZ\tQW_MZ\tIA_TI\tQW_title\t";
	chomp $header2;
	my @QW_head=split/\t/,$header2;
	for(my $i=3;$i<@QW_head;$i++)
	{
		print OUT "QW_$QW_head[$i]\t";
	}
	chomp $header;
	my @IA_head=split/\t/,$header;
	for(my $i=4;$i<@IA_head;$i++)
	{
		print OUT "IA_$IA_head[$i]\t";
	}
	print OUT "IA_114:113\tIA_115:113\tIA_116:113\tIA_117:113\tIA_118:113\tIA_119:113\tIA_121:113\t";
	print OUT "\n";
	foreach my $rt(sort (keys %ia))
	{
		if (exists $qw{$rt})
		{
			foreach my $mz(sort keys %{$ia{$rt}})
			{
				if (exists $qw{$rt}{$mz})
				{
					#print "$rt\t$mz\t";<>;
					my @line1=split/\t/,$ia{$rt}{$mz};
					my @line2=split/\t/,$qw{$rt}{$mz};
					print OUT "$rt\t$line1[1]\t$line2[1]\t$mz\t$line1[2]\t$line2[2]\t$line1[3]\t$line2[0]\t";
					for(my $i=3;$i<@line2;$i++)
					{
						print OUT "$line2[$i]\t";
					}
					for(my $i=4;$i<@line1;$i++)
					{
						print OUT "$line1[$i]\t";
					}
					for(my $i=5;$i<=$#line1; $i++)
					{
						if ($line1[4]==0)
						{
							if ($line1[$i]==0 || $line1[$i]<0)
							{
								print OUT "0\t";
							}
							if ($line1[$i]>0)
							{
								print OUT "100\t";
							}
							
						}
						elsif($line1[4]>0)
						{
							if ($line1[$i]==0 || $line1[$i]<0)
							{
								print OUT "0.01\t";
							}
							else
							{
								print OUT $line1[$i]/$line1[4],"\t";
							}
						}   
					}
					print OUT "\n";
					}
				
			}
			
		}	
	}
}
