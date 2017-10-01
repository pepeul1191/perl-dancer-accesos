package Handler::Modulo;
use Dancer2;
use JSON;
use JSON::XS 'decode_json';
use Data::Dumper;
use Try::Tiny;
use strict;
use warnings;
use Model::Modulo;

hook before => sub {
    response_header 'X-Powered-By' => 'Perl Dancer 1.3202, Ubuntu';
};

get '/listar/:modulo_id' => sub {
    my $modulo_id = param('modulo_id');
	my $model = 'Model::Modulo';
    my $modulos= $model->new();
    try {
       my  @rpta = $modulos->listar();
       return to_json \@rpta;
    }
    catch {
        my %rpta = ();
        $rpta{'tipo_mensaje'} = "error";
        $rpta{'mensaje'} = "Se ha producido un error en cargar la lista de modulos";
        my @temp = ("Se ha producido un error en carga la lista de modulos", "" . $_);
        $rpta{'mensaje'} = [@temp];
        return to_json \%rpta;
    };
};

1;