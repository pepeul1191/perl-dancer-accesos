package Handler::Permiso;
use Dancer2;
use Model::Permiso;
use JSON;
use JSON::XS 'decode_json';
use Data::Dumper;
use Try::Tiny;
use strict;
use warnings;
use utf8;
use Encode qw( encode_utf8 );

get '/listar/:sistema_id' => sub {
    my $sistema_id = param('sistema_id');
    my $model = 'Model::Permiso';
    my $permisos= $model->new();
    my @rpta = $permisos->listar($sistema_id);

    return to_json \@rpta;
};

post '/guardar' => sub {
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
              my $nombre = $nuevo->{'nombre'};
              my $llave = $nuevo->{'llave'};
              my $id_generado = crear($nombre, $llave, $sistema_id);
              my %temp = ();
              $temp{ 'temporal' } = $temp_id;
              $temp{ 'nuevo_id' } = $id_generado;
              push @array_nuevos, {%temp};
            }
        }

        for my $editado(@editados){
            if ($editado) {
              my $id = $editado->{'id'};
              my $nombre = $editado->{'nombre'};
              my $llave = $editado->{'llave'};
              editar($id, $nombre, $llave, $sistema_id);
            }
        }

        for my $eliminado(@eliminados){
            eliminar($eliminado);
        }

        $rpta{'tipo_mensaje'} = "success";
        my @temp = ("Se ha registrado los cambios en los permisos", [@array_nuevos]);
        $rpta{'mensaje'} = [@temp];
    } catch {
        #warn "got dbi error: $_";
        $rpta{'tipo_mensaje'} = "error";
        $rpta{'mensaje'} = "Se ha producido un error en guardar la tabla de permisos";
        my @temp = ("Se ha producido un error en guardar la tabla de permisos", "" . $_);
        $rpta{'mensaje'} = [@temp];
    };
    #print("\n");print Dumper(%rpta);print("\n");
    return to_json \%rpta;
};

sub crear {
    my($nombre, $llave, $sistema_id) = @_;
    my $model = 'Model::Permiso';
    my $permisos= $model->new();

    return $permisos->crear($nombre, $llave, $sistema_id);
}

sub editar {
    my($id, $nombre, $llave, $sistema_id) = @_;
    my $model = 'Model::Permiso';
    my $permisos= $model->new();
    $permisos->editar($id, $nombre, $llave, $sistema_id);
}

sub eliminar {
    my($id) = @_;
    my $model = 'Model::Permiso';
    my $permisos= $model->new();
    $permisos->eliminar($id);
}

get '/listar_asociados/:sistema_id/:rol_id' => sub {
    my $sistema_id = param('sistema_id');
    my $rol_id = param('rol_id');
    my $model = 'Model::Permiso';
    my $permisos= $model->new();
    my @rpta = $permisos->listar_asociados($sistema_id, $rol_id);
    
    return to_json \@rpta;
};

1;