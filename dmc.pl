#created by Carlos Williamberg 10/06/2017
use strict;
use warnings;

my $data_set = 'iris.data';
my $test_set = 'iris.test';

my %test_classes;
my %centroid_classes;

open my $test, $test_set or die  "Could not open the file $test_set";
#read test set.
while (<$test>) {
	my ($attributes, $class_name) = split(/,I/);
	$test_classes {$attributes} = "I".$class_name;
}
close $test;

sub train{
    my %item;
    my $current_class;
    my $value;
    my @acumulator;
    my $counter = 0;
    open my $info, $data_set or die  "Could not open the file $data_set";
    #read data set. Note: the data set must be ordered.
    while (<$info>) {
        my ($attribute_array, $class_name) = split(/,I/);
	$class_name = "I".$class_name;
	my @attributes = split(/,/, $attribute_array);
	if ( defined($current_class) && $current_class eq $class_name ){
	    
	}
	else{
	    for(@acumulator){ $_ /= $counter;}
	    $value = join ',', @acumulator[0..$#acumulator];
	    if( @acumulator ){ $centroid_classes{$current_class} = $value; }
 	    @acumulator = ();
	    $counter = 0;
	    $current_class = $class_name;
	}
	$counter++;
	for my $i(0..$#attributes){ $acumulator[$i] += $attributes[$i];}
    }
    close $info;
    $centroid_classes{$current_class} = $value;
    for(keys %centroid_classes){print "key:$_: $centroid_classes{$_}\n";}
   

}

train();

sub average{
	foreach(@_){
		my @attributes0 = split(/,/, $_);
		#print @attributes0;
	}
}

#while(1){
	#print "Enter the attributes separated by , : ";
	#chomp (my $attributes = <STDIN>);
	#print classify_knn($attributes);
	#average(@centroid_classes);
#}
 
#sub classify_knn{
#	my @neighbors;
#	my ($min_distance, $min_distance_key) = 100, 0;
#	for my $key (keys %classes){
#		my $current_distance = distance($key, $_[0]);
#		if ($current_distance <= $min_distance){
#			shift @neighbors if @neighbors == K;
#			push @neighbors, $classes{$key};
#			$min_distance = $current_distance;
#		}
#	}
#	return mode(@neighbors);
#}

sub distance{
	my $result = 0;
	my @attributes0 = split(/,/, shift);
	my @attributes1 = split(/,/, shift);
	for my $i (0..$#attributes0){
		$result += abs $attributes0[$i] - $attributes1[$i];
	}
	return $result;
}

sub mode{
	my %classes_count;
	my ($max, $max_key) = (0, "none");
	foreach(@_){ $classes_count{$_} = $classes_count{$_} ? $classes_count{$_} + 1: 1;}
	while ( my($key, $value) = each %classes_count ){
		 $max_key = $key, $max = $value if $value > $max;
	}
	return $max_key;
}
