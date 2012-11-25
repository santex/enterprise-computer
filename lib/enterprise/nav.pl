#!/usr/bin/perl -W
use strict;
use warnings;
use JSON::XS;
use Data::Dumper;
use AI::MicroStructure;
#use AI::MicroStructure::Ontology;
#use AI::MicroStructure::Fitnes;
#use AI::MicroStructure::Categorizer;
#use AI::MicroStructure::Memorizer;
#use AI::MicroStructure::Tree;
#use AI::MicroStructure::Collection;
use Storable::CouchDB;
my @ARGVX = ();
my @datax;#use IOMicroy;


our $json_main =  {lang=>"C",category=>"no",name=>"santex",size=>1,children=>[]};

@ARGVX=("hagen",
      "",
      "localhost",
      "nav") unless($#ARGVX>2);

my $configure = (
{
  user=>$ARGVX[0],
  pass=>$ARGVX[1],
  dbfile=>sprintf("%s/active-memory/berkeley.dat","/home/hagen"),
  couchhost=>$ARGVX[2],
  cachhost=>"localhost",
  cachhost=>"localhost",
  categories=>undef,
  couchport=>5984,
  couchdbname=>"wikilist",
  cacheport=>22922,
  uri=>"",
  home=>"/home/hagen",
  www=>"/var/www/sections/data/"
});
#vhosts/quantup.com/httpdocs/
$configure->{bookpath}=sprintf("%s/active-memory/test/txt/ok/",
                                $configure->{home});

$configure->{uri} =
    sprintf("http://%s:%s\@%s:%s/",
        $configure->{user},
        $configure->{pass},
        $configure->{couchhost},
        $configure->{couchport});


my $driver = AI::MicroStructure::Driver->new($configure)->{driver};


my $x = AI::MicroStructure->new(
"AI::MicroStructure::Driver"      =>  $driver
);




sub getAll {
  my $key =shift;
    
  require LWP::UserAgent;
  my $ua = LWP::UserAgent->new;
  my ($server,$db) = (sprintf("http://%s:5984",$ARGVX[2]),"wikilist");
  my $res = $ua->get(sprintf('%s/%s/_design/base/_view/instances?reduce=false&start_key=["%s"]&end_key=["%sZZZ"]',
                              $server,
                              $db,
                              $key,
                              $key));


my $content = decode_json($res->content);
my @all;
my @book;

foreach(@{$content->{rows}}){

  if(@{$_->{key}}){
    push @all,grep{!/\W/}@{$_->{key}};
  }
}


return @all;


}




$ARGV[0] = "" unless($ARGV[0]);
my $key = sprintf("%s_%s",join("",@ARGVX),$ARGV[0]);
if(0 && defined(my $list = $driver->{'memcache'}->retrieve($key))){


foreach (@{$list}) {   print $_."\n"; }


}else{

my @datax = getAll($ARGV[0]);

if($#datax){


$driver->{'memcache'}->store($key,@datax) if(@datax);


foreach my $i(0..$#datax) { 

  printf("%s\n",$datax[$i]) unless(!$datax[$i]);
  
}
}
}

1;
#system("echo $list | data-freq --limit 3");
__DATA__


