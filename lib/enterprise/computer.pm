#!/usr/bin/perl -X

package enterprise::computer;
#use strict;
#use warnings;
use Data::Dumper;
use IO::Async::Loop;
use Net::Async::WebSocket::Server;
use JSON::XS;
use Env qw/PWD/;


my @symbols = ();
my $DEBUG = 10;
my $DEBUG_TO_SYSLOG=1;
my $LOGGER_EXE="/usr/bin/logger";
my $PORT = 3001;
my $JSON = {};


sub Dbg {
  my $level=shift @_;
  my $msg = shift @_;
  # If the $DEBUG level exceeds the level at which we log this mess
      my @args=`echo '$0 $msg' | $LOGGER_EXE`;

  return sprintf("\n",$msg);
}



sub printer {
  my ($self,$msg) = @_;
  my $cmd = {};

     $msg = "space" unless($msg);

     `mplayer ~/enterprise-computer/media/acknowledge.ogg &`;
     `mplayer http://ubuntu.hbr1.com:19800/trance.ogg &`;
     
     
     $cmd->{action} = "";
 
     
 
     #+ options to sort. Changed from
     #stop=$(perl -MAI::MicroStructure::WordBlacklist -E  "my \$s=AI::MicroStructure::WordBlacklist::getStopWords('en'); my @s = keys %\$s; print join('|',@s);")


     #sprintf(`perl /home/hagen/myperl/AI-MicroStructure-0.01/teswikilist05.pl $msg | data-freq --limit 100 | egrep ": [a-zA-Z]" | grep -v "#"`);

     $cmd->{action} = [map{my @a= [split(":",$_)]; $a[0][0]=~ s/ //g; $_={neighbour => $a[0][1], spawn => $a[0][0]};}split("\n",$cmd->{action})];

     $cmd->{json} = JSON::XS->new->pretty(0)->encode ({"meta" => {"type" => "json",
                                                                  "payload" => "neighbours"},
                                                      "query" => $msg,
                                                      "callback" => "makeList",
                                                      "responce" => $cmd->{action}});



#      print Dumper [$msg,$cmd];

      return $cmd->{json};

}


my $server = Net::Async::WebSocket::Server->new(
   on_client => sub {
      my ( undef, $client ) = @_;
      my $list;
      $client->configure(
         on_frame => sub {
            my ( $self, $frame ) = @_;
            $self->{frame} = $frame;
            $list = printer($self, $frame);
	    $self->send_frame( $list );
            
         },
      );
   }
);

my $loop = IO::Async::Loop->new;#(max_payload_size=>40000);

$loop->add( $server );

$server->listen(
   family => "inet",
   service => $PORT,
   on_listen => sub { print Dumper "Cannot listen - ",$_[-1];  },
   on_resolve => sub { print Dumper "Cannot resolve - ",$_[-1];},
   on_listen_error => sub { die "Cannot listen - $_[-1]" },
   on_resolve_error => sub { die "Cannot resolve - $_[-1]" },
);

$loop->loop_forever;


