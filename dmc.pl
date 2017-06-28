#created by Carlos Williamberg 10/06/2017
use strict;
use warnings;

my $data_set = 'iris.data';
my $test_set = 'iris.test';

my %test_classes;
my %centroid_classes;

sub train{

    my $current_class = "";
    my $value;
    my @acumulator;
    my $counter = 0;
    open my $info, $data_set or die  "Could not open the file $data_set";
    #read data set. Note: the data set must be ordered.
    while (<$info>) {
        my ($attributes_string, $class_name) = split(/,I/);
	    $class_name = "I".$class_name;
	    my @attributes = split(/,/, $attributes_string);

	    if ( $current_class ne $class_name ){
	        for(@acumulator){ $_ /= $counter; }
	        $value = join ',', @acumulator[0..$#acumulator];
	        if( @acumulator ){
		    $centroid_classes{$current_class} = $value;
		    $centroid_classes{$current_class."counter"} = $counter;
		}
 	        @acumulator = ();
	        $counter = 0;
	        $current_class = $class_name;
	    }
	    $counter++;
	    for my $i(0..$#attributes){ $acumulator[$i] += $attributes[$i];}
    }
    close $info;
    for(@acumulator){ $_ /= $counter; }
    $value = join ',', @acumulator[0..$#acumulator];
    $centroid_classes{$current_class} = $value;
    $centroid_classes{$current_class."counter"} = $counter;
}

train();
open my $test, $test_set or die  "Could not open the file $test_set";
#read test set.
while (<$test>) {
	my ($attributes, $class_name) = split(/,I/);
	$test_classes {$attributes} = "I".$class_name;
}
close $test;

#subimit the test set to classifier.
for(keys %test_classes){
	update_centroid($test_classes{$_}, $_) if ( $test_classes{$_} eq classify_dmc($_) );
	print "test class: $test_classes{$_}, classify: ", classify_dmc($_), "\n";
}

sub update_centroid{
    my $classe_name = shift;
    my @new_attributes = split(/,/, shift);
    my @old_attributes = split(/,/, $centroid_classes{$classe_name});
    my $n = $centroid_classes{$classe_name."counter"};
    my $learning_factor = 1 /($n + 1);
    foreach my $i(0..$#old_attributes){ 
        $old_attributes[$i] = (1 - $learning_factor) * $old_attributes[$i] + $learning_factor * $new_attributes[$i];
    }
}

sub classify_dmc{
	my ($min_distance, $min_distance_key) = 100;
	for my $key (keys %centroid_classes){
	    my $current_distance = distance($centroid_classes{$key}, @_);
	    if ($current_distance <= $min_distance){
		$min_distance_key = $key;
		$min_distance = $current_distance;
	    }
	}
	return $min_distance_key;
}

sub distance{
	my $result = 0;
	my @attributes0 = split(/,/, shift);
	my @attributes1 = split(/,/, shift);
	for my $i (0..$#attributes0){
		$result += abs $attributes0[$i] - $attributes1[$i];
	}
	return $result;
}
