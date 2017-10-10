package Handler::Rol;
use Dancer2;
use Model::Rol;
use JSON;
use JSON::XS 'decode_json';
use Data::Dumper;
use Try::Tiny;
use strict;
use warnings;
use utf8;
use Encode qw( encode_utf8 );

get '/listar/:sistema_id' => sub {
    my $model = 'Model::Rol';
    my $sistema_id = param('sistema_id');
    my $roles= $model->new();
    my @rpta = $roles->listar($sistema_id);

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
              my $id_generado = crear($nombre, $sistema_id);
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
              editar($id, $nombre, $sistema_id);
            }
        }

        for my $eliminado(@eliminados){
            eliminar($eliminado);
        }

        $rpta{'tipo_mensaje'} = "success";
        my @temp = ("Se ha registrado los cambios en los roles", [@array_nuevos]);
        $rpta{'mensaje'} = [@temp];
    } catch {
        #warn "got dbi error: $_";
        $rpta{'tipo_mensaje'} = "error";
        $rpta{'mensaje'} = "Se ha producido un error en guardar la tabla de roles";
        my @temp = ("Se ha producido un error en guardar la tabla de roles", "" . $_);
        $rpta{'mensaje'} = [@temp];
    };
    #print("\n");print Dumper(%rpta);print("\n");
    return to_json \%rpta;
};

sub crear {
    my($nombre, $sistema_id) = @_;
    my $model = 'Model::Rol';
    my $roles= $model->new();

    return $roles->crear($nombre, $sistema_id);
}

sub editar {
    my($id, $nombre, $sistema_id) = @_;
    my $model = 'Model::Rol';
    my $roles= $model->new();
    $roles->editar($id, $nombre, $sistema_id);
}

sub eliminar {
    my($id) = @_;
    my $model = 'Model::Rol';
    my $roles= $model->new();
    $roles->eliminar($id);
}

post '/asociar_permisos' => sub {
    my $data = decode_json(encode_utf8(param('data')));
    my @nuevos = @{$data->{"nuevos"}};
    my @editados = @{$data->{"editados"}};
    my @eliminados = @{$data->{"eliminados"}};
    my $rol_id = $data->{"extra"}->{'id_rol'};
    my @array_nuevos;
    my %rpta = ();

    try {
        for my $nuevo(@nuevos){
           if ($nuevo) {
              my $permiso_id = $nuevo->{'id'};
              crear_asociacion($rol_id, $permiso_id);
            }
        }

        for my $permiso_id(@eliminados){
            eliminar_asociacion($rol_id, $permiso_id);
        }

        $rpta{'tipo_mensaje'} = "success";
        my @temp = ("Se ha registrado la asociación/deasociación de los permisos al rol");
        $rpta{'mensaje'} = [@temp];
    } catch {
        #warn "got dbi error: $_";
        $rpta{'tipo_mensaje'} = "error";
        $rpta{'mensaje'} = "Se ha producido un error en asociar/deasociar los permisos al rol";
        my @temp = ("Se ha producido un error en asociar/deasociar los permisos al rol", "" . $_);
        $rpta{'mensaje'} = [@temp];
    };
    #print("\n");print Dumper(%rpta);print("\n");
    return to_json \%rpta;
};

sub crear_asociacion {
    my($rol_id, $permiso_id) = @_;
    my $model = 'Model::Rol';
    my $roles= $model->new();

    return $roles->crear_asociacion($rol_id, $permiso_id);
}

sub eliminar_asociacion {
    my($rol_id, $permiso_id) = @_;
    my $model = 'Model::Rol';
    my $roles= $model->new();

    return $roles->eliminar_asociacion($rol_id, $permiso_id);
}

1;