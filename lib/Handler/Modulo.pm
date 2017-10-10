package Handler::Modulo;
use Dancer2;
use JSON;
use JSON::XS 'decode_json';
use Data::Dumper;
use Try::Tiny;
use strict;
use warnings;
use Model::Modulo;
use utf8;
use Encode qw( encode_utf8 );

get '/listar/:sistema_id' => sub {
    my $sistema_id = param('sistema_id');
    my $model = 'Model::Modulo';
    my $modulos= $model->new();
    try {
       my  @rpta = $modulos->listar($sistema_id);
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

post 'guardar' => sub {
    my $data = decode_json(encode_utf8(param('data')));
    my @nuevos = @{$data->{"nuevos"}};
    my @editados = @{$data->{"editados"}};
    my @eliminados = @{$data->{"eliminados"}};
    my $sistema_id = $data->{"extra"}->{'sistema_id'};
    my @array_nuevos;
    my %rpta = ();

    try {
        for my $nuevo(@nuevos){
           if ($nuevo) {
              my $temp_id = $nuevo->{'id'};
              my $url = $nuevo->{'url'};
              my $nombre = $nuevo->{'nombre'};
              my $id_generado = crear($url, $nombre, $sistema_id);
              my %temp = ();
              $temp{ 'temporal' } = $temp_id;
              $temp{ 'nuevo_id' } = $id_generado;
              push @array_nuevos, {%temp};
            }
        }

        for my $editado(@editados){
            if ($editado) {
              my $id = $editado->{'id'};
              my $url = $editado->{'url'};
              my $nombre = $editado->{'nombre'};
              editar($id, $url, $nombre);
            }
        }

        for my $eliminado(@eliminados){
            eliminar($eliminado);
        }

        $rpta{'tipo_mensaje'} = "success";
        my @temp = ("Se ha registrado los cambios en los modulos", [@array_nuevos]);
        $rpta{'mensaje'} = [@temp];
    } catch {
        #warn "got dbi error: $_";
        $rpta{'tipo_mensaje'} = "error";
        $rpta{'mensaje'} = "Se ha producido un error en guardar la tabla de modulos";
        my @temp = ("Se ha producido un error en guardar la tabla de modulos", "" . $_);
        $rpta{'mensaje'} = [@temp];
    };
    #print("\n");print Dumper(%rpta);print("\n");
    return to_json \%rpta;
};

sub crear {
    my($url, $nombre, $sistema_id) = @_;
    my $model = 'Model::Modulo';
    my $modulos= $model->new();

    return $modulos->crear($url, $nombre, $sistema_id);
}

sub editar {
    my($id, $url, $nombre) = @_;
    my $model = 'Model::Modulo';
    my $modulos= $model->new();
    $modulos->editar($id, $url, $nombre);
}

sub eliminar {
    my($id) = @_;
    my $model = 'Model::Modulo';
    my $modulos= $model->new();
    $modulos->eliminar($id);
}

1;