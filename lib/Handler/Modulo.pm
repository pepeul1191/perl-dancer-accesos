package Handler::Modulo;
use Dancer2;
use JSON;
use JSON::XS 'decode_json';
use Data::Dumper;
use Try::Tiny;
use strict;
use warnings;
use Model::Modulo;

get '/listar/:sistema_id' => sub {
    my $sistema_id = param('sistema_id');
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