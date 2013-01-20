#! /usr/bin/perl

use strict;
use warnings;
use Mojo::UserAgent;
use Data::Printer;
use feature "say";

my $ua = Mojo::UserAgent->new;
my $dom = $ua->get( 'http://www.trekcore.com/audio/' )->res->dom;
my %treksounds = ();
for my $category ($dom->find('img')->each) {
    next if $category->attrs('alt') eq "";
    $_ = $category->attrs('alt');
    s/ /_/g;
    $treksounds{$_} => ();
    my $p = $category->parent->parent;
    for my $k ($p->find('a')->each) {
        push @{$treksounds{$_}}, $k->attrs('href') if $k;
    }
}
for my $key (keys %treksounds) {
    mkdir $key unless -d $key;
    for (@{$treksounds{$key}}) {
        s#^(?:(?:[^/]+)/)+(.*\.mp3$)#$1#g;
        my $mp = $ua->get( "http://www.trekcoure.com/audio/$_" );
        $mp->res->content->asset->move_to("./$key/$_");
    }
}
