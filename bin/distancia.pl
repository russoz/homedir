#!/usr/bin/perl -w
#
# Marcos Roberto Silva (marcos.roberto.silva@uol.com.br)
# http://www.dicas-l.com.br/dicas-l/20090826.php
#
use strict;
use DBI;
use LWP::Simple;

die "Uso: distancia.pl < municipio-uf> < municipio-uf>"
  if ( scalar(@ARGV) != 2 );

my $origem  = shift;
my $destino = shift;

my $site = 'maps.google.com.br';
my $url  = "http://$site/maps?saddr=$origem&daddr=$destino&hl=en&z=1";
my $page = get($url);
my @dados = split( /,distance:"/, $page );
my @dist = split( / km",/, $dados[1] );
$dist[0] =~ s/,//g;
print "Distancia de $origem a $destino = $dist[0] km\n";
