package Handler::Sistema;
use Dancer2;
use JSON;
use JSON::XS 'decode_json';
use Data::Dumper;
use Try::Tiny;
use strict;
use warnings;
use Model::Sistema;

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

get '/usuario/:usuario_id' => sub {
    my $model = 'Model::Sistema';
    my $usuario_id = param('usuario_id');
    my $sistemas= $model->new();
    try {
       my  @rpta = $sistemas->usuario($usuario_id);
       return to_json \@rpta;
    }
    catch {
        my %rpta = ();
        $rpta{'tipo_mensaje'} = "error";
        my @temp = ("Se ha producido un error en listar los sistemas asociados a dicho usuario", "" . $_);
        $rpta{'mensaje'} = [@temp];
        return to_json \%rpta;
    };
};

post '/asociar_usuario' => sub {
    my $data = decode_json(encode_utf8(param('data')));
    my @nuevos = @{$data->{"nuevos"}};
    my @editados = @{$data->{"editados"}};
    my @eliminados = @{$data->{"eliminados"}};
    my $usuario_id = $data->{"extra"}->{'usuario_id'};
    my @array_nuevos;
    my %rpta = ();

    try {
        for my $nuevo(@nuevos){
           if ($nuevo) {
              my $sistema_id = $nuevo->{'sistema_id'};
              crear_asociacion($usuario_id, $sistema_id);
            }
        }

        for my $sistema_id(@eliminados){
            eliminar_asociacion($usuario_id, $sistema_id);
        }

        $rpta{'tipo_mensaje'} = "success";
        my @temp = ("Se ha registrado la asociación/deasociación de los usuarios al sistema");
        $rpta{'mensaje'} = [@temp];
    } catch {
        #warn "got dbi error: $_";
        $rpta{'tipo_mensaje'} = "error";
        $rpta{'mensaje'} = "Se ha producido un error en asociar/deasociar los usuarios al sistema";
        my @temp = ("Se ha producido un error en asociar/deasociar los usuarios al sistema", "" . $_);
        $rpta{'mensaje'} = [@temp];
    };
    #print("\n");print Dumper(%rpta);print("\n");
    return to_json \%rpta;
};

sub crear_asociacion {
    my($usuario_id, $sistema_id) = @_;
    my $model = 'Model::Sistema';
    my $sistemas = $model->new();

    return $sistemas->crear_asociacion($usuario_id, $sistema_id);
}

sub eliminar_asociacion {
    my($usuario_id, $sistema_id) = @_;
    my $model = 'Model::Sistema';
    my $sistemas= $model->new();

    return $sistemas->eliminar_asociacion($usuario_id, $sistema_id);
}

post '/guardar' => sub {
    my $data = decode_json(param('data'));
    my @nuevos = @{$data->{"nuevos"}};
    my @editados = @{$data->{"editados"}};
    my @eliminados = @{$data->{"eliminados"}};
    my $id_subtitulo = $data->{"extra"}->{'id_subtitulo'};
    my @array_nuevos;
    my %rpta = ();

    try {
        for my $nuevo(@nuevos){
           if ($nuevo) {
              my $temp_id = $nuevo->{'id'};
              my $nombre = $nuevo->{'nombre'};
              my $version = $nuevo->{'version'};
              my $repositorio = $nuevo->{'repositorio'};
              my $id_generado = crear($nombre, $version, $repositorio);
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
              my $version = $editado->{'version'};
              my $repositorio = $editado->{'repositorio'};
              editar($id, $nombre, $version, $repositorio);
            }
        }

        for my $eliminado(@eliminados){
            eliminar($eliminado);
        }

        $rpta{'tipo_mensaje'} = "success";
        my @temp = ("Se ha registrado los cambios en los sistemas", [@array_nuevos]);
        $rpta{'mensaje'} = [@temp];
    } catch {
        #warn "got dbi error: $_";
        $rpta{'tipo_mensaje'} = "error";
        $rpta{'mensaje'} = "Se ha producido un error en guardar la tabla de sistemas";
        my @temp = ("Se ha producido un error en guardar la tabla de sistemas", "" . $_);
        $rpta{'mensaje'} = [@temp];
    };
    #print("\n");print Dumper(%rpta);print("\n");
    return to_json \%rpta;
};

sub crear {
    my($nombre, $version, $repositorio) = @_;
    my $model = 'Model::Sistema';
    my $sistemas= $model->new();
    return $sistemas->crear($nombre, $version, $repositorio);
}

sub editar {
    my($id, $nombre, $version, $repositorio) = @_;
    my $model = 'Model::Sistema';
    my $sistemas= $model->new();
    $sistemas->editar($id, $nombre, $version, $repositorio);
}

sub eliminar {
    my($id) = @_;
    my $model = 'Model::Sistema';
    my $sistemas= $model->new();
    $sistemas->eliminar($id);
}

1;