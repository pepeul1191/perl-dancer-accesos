package Handler::Sistema;
use Dancer2;
use JSON;
use JSON::XS 'decode_json';
use Data::Dumper;
use Try::Tiny;
use strict;
use warnings;
use Model::Sistema;

hook before => sub {
    response_header 'X-Powered-By' => 'Perl Dancer 1.3202, Ubuntu';
  };

get '/listar' => sub {
	my $model = 'Model::Sistema';
    my $sistemas= $model->new();
    try {
       my  @rpta = $sistemas->listar();
       return to_json \@rpta;
    }
    catch {
        my %rpta = ();
        $rpta{'tipo_mensaje'} = "error";
        $rpta{'mensaje'} = "Se ha producido un error en guardar la tabla de modulos";
        my @temp = ("Se ha producido un error en guardar la tabla de modulos", "" . $_);
        $rpta{'mensaje'} = [@temp];
        return to_json \%rpta;
    };
};

1;