#!/usr/bin/perl -w
use strict;
use warnings;
use XML::Twig;
use Data::Dumper;

my $count = 0;

# path to directory containing consensusXML files
my $dir = '/path/to/directory/containing/consensusXML/data/files.'; 
opendir (DIR, $dir) or die "Cannot open directory $dir: $!";

while (my $file = readdir(DIR)) {

	if (index($file, 'consensusXML') == -1) {
		print "Not a consensusXML file. File not parsed.\n";
		next;
	}
	else {
		print "$file\n";

		$count += 1;
		$dir = './output/';
		my $out=$file;
		$out=~s/\.consensusXML/\.tsv/;
		
		mkdir $dir unless -d $dir;
		open(OUT,">.\\output\\$out") or die $!;
		print OUT "ID\tRTIN\tMz\tIT\t113\t114\t115\t116\t117\t118\t119\t121\n";
		my $t = XML::Twig->new(twig_roots=>{'consensusElementList'=>\&Retrive_consensusXML}); # give the root tag of the file
		$t->parsefile($file) or print("File not found\n");
		$t->purge;
		# $ArrRef=mapcol($OutFile,$ArrRef);
	}
}

sub Retrive_consensusXML
{
	my ($twig,$ele)=@_;
	my $r=$ele;
	my($rt,$mz,$id,$it,$mz_check,$a113,$a114,$a115,$a116,$a117,$a118,$a119,$a121);
	while($r=$r->next_elt())
	{
		if($r->gi eq 'consensusElement')
		{
			$id=$r->{'att'}->{'id'};
			print OUT "$id\t";#<>;
		}
		if($r->gi eq 'centroid')
		{
			$rt=$r->{'att'}->{'rt'};
			$mz=$r->{'att'}->{'mz'};
			$it=$r->{'att'}->{'it'};
							
			print OUT "$rt\t$mz\t$it\t";#<>;
		}
		if($r->gi eq 'element')
		{
			#$mz_check=$r->{'att'}->{'mz'};
			#print "\n:::$mz_check\n";<>;
			if ($r->{'att'}->{'mz'}==113.1078)
			{
				$a113=$r->{'att'}->{'it'};
				print OUT "$a113\t";
			}
			elsif ($r->{'att'}->{'mz'}==114.1112)
			{
				$a114=$r->{'att'}->{'it'};
				print OUT "$a114\t";
				
			}
			elsif ($r->{'att'}->{'mz'}==115.1082)
			{
				$a115=$r->{'att'}->{'it'};
				print OUT "$a115\t";
				
			}
			elsif ($r->{'att'}->{'mz'}==116.1116)
			{
				$a116=$r->{'att'}->{'it'};
				print OUT "$a116\t";
				
			}
			elsif ($r->{'att'}->{'mz'}==117.1149)
			{
				$a117=$r->{'att'}->{'it'};
				print OUT "$a117\t";
				
			}
			elsif ($r->{'att'}->{'mz'}==118.112)
			{
				$a118=$r->{'att'}->{'it'};
				print OUT "$a118\t";
				
			}
			elsif ($r->{'att'}->{'mz'}==119.1153)
			{
				$a119=$r->{'att'}->{'it'};
				print OUT "$a119\t";
				
			}
			elsif ($r->{'att'}->{'mz'}==121.122)
			{
				$a121=$r->{'att'}->{'it'};
				print OUT "$a121\n";
				
			}
			else
			{
				print "area not defined";
			}
			#u need 8 if statements for checking isobaric tag attribute
		}
		#print "$a113\t$a114\t$a115\t$a116\t$a117\t$a118\t$a119\t$a121\n";<>;
	}
}