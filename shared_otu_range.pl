#!/usr/bin/perl -w
use strict;
@ARGV == 2 || die "Usage: perl $0 <otu_table> <geom_line> > out.file\n";
my $otu = shift;
my $geom = shift;
my %hash;
open IN,$geom or die $!;
while(<IN>){
	chomp;
	my @ll = split;
	my $key = join("_",@ll[0,1]);
	$hash{$key} = $ll[2];
}
close IN;
open IN,$otu or die $!;
chomp(my $head = <IN>);
my @head = split /\s+/,$head;
while(<IN>){
	chomp;
	my @ll = $_ =~ /\t/? split /\t/,$_ : split /\s+/,$_;
	my @index;
	for my $i(1..$#ll){
		if($ll[$i] != 0){
			push @index,$i;
		}
	}

	if(@index == 2){
		my $sel = join("_",@head[@index]);
		$hash{$sel} && print join("\t",$ll[0],$sel,$hash{$sel}),"\n";
	}
	elsif(@index > 2){
		my ($key,$max) = findmax(@index);
		print join("\t",$ll[0],$key,$max),"\n";
	}
}
sub findmax{
	my @index = @_;
	my $max = 0;
	my $key;
	for my $i(0..$#index - 1){
		for my $j($i..$#index){
			$key = join("_",@head[@index[$i,$j]]);
			$hash{$key} && ($max < $hash{$key}) && ($max = $hash{$key});
		}
	}
	return $key,$max;
}
