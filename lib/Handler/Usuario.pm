package Handler::Usuario;
use Dancer2;
use JSON;
use Data::Dumper;
use Try::Tiny;
use strict;
use warnings;
use Model::Usuario;
use Model::Acceso;
use utf8;
use Encode qw( encode_utf8 );

get '/listar' => sub {
    my $model = 'Model::Usuario';
    my $usuarios= $model->new();
    my @rpta = $usuarios->listar();

    return to_json \@rpta;
};

get '/listar_usuarios' => sub {
    my $model = 'Model::Usuario';
    my $usuarios= $model->new();
    my @rpta = $usuarios->listar_usuarios();

    return to_json \@rpta;
};

post '/validar' => sub {
    my $usuario =query_parameters->get('usuario');
    my $contrasenia =query_parameters->get('contrasenia');
    $contrasenia =~ tr/ /+/;
    my $model = 'Model::Usuario';
    my $usuarios= $model->new();
    my $rpta = $usuarios->validar($usuario, $contrasenia);
    if($rpta == 1){
        my @usuario = $usuarios->obtener_id($usuario, $contrasenia);
        my $model2 = 'Model::Acceso';
        my $accesos= $model2->new();
        $accesos->crear(@usuario[0]->{"id"});
    }
    
    return $rpta;
};

get '/listar_accesos/:usuario_id' => sub {
    my $usuario_id = param('usuario_id');
    my $model = 'Model::Acceso';
    my $accesos= $model->new();
    my @rpta = $accesos->listar_accesos($usuario_id);

    return to_json \@rpta;
};

post '/nombre_repetido' => sub {
    my $data = decode_json(encode_utf8(param('data')));
    my $usuario_id= $data->{"id"};
    my $usuario = $data->{"usuario"};
    my $model = 'Model::Usuario';
    my $accesos= $model->new();
    my $rpta = 0;
    
    if($usuario_id == 'E'){
        #estamos hablando de un usuario nuevo, no tiene que repetirse el nombre
        $rpta = $accesos->validar_usuario_repetido($usuario);
    }else{
        #estamos hablando de un usuario a ediatr, no tiene que repetirse el nombre a menos que estemo
        $rpta = $accesos->validar_usuario_repetido_editado($usuario_id, $usuario);
        if($rpta == 1){
            $rpta = 0;
        }else{
            $rpta = $accesos->validar_usuario_repetido($usuario);
        }
    }
    
    return $rpta;
};

post '/correo_repetido' => sub {
    my $data = decode_json(encode_utf8(param('data')));
    my $usuario_id= $data->{"id"};
    my $correo = $data->{"correo"};
    my $model = 'Model::Usuario';
    my $accesos= $model->new();
    my $rpta = 0;
    
    if($usuario_id == 'E'){
        #estamos hablando de un usuario nuevo, no tiene que repetirse el correo
        $rpta = $accesos->validar_correo_repetido($correo);
    }else{
        #estamos hablando de un usuario a ediatr, no tiene que repetirse el nombre a menos que estemo
        $rpta = $accesos->validar_correo_repetido_editado($usuario_id, $correo);
        if($rpta == 1){
            $rpta = 0;
        }else{
            $rpta = $accesos->validar_correo_repetido($correo);
        }
    }
    
    return $rpta;
};

post '/contrasenia_repetida' => sub {
    my $data = decode_json(encode_utf8(param('data')));
    my $usuario_id= $data->{"id"};
    my $contrasenia = $data->{"contrasenia"};
    my $model = 'Model::Usuario';
    my $accesos= $model->new();
    my $rpta = 0;
    
    $rpta = $accesos->validar_contrasenia_repetida($usuario_id, $contrasenia);
    
    return $rpta;
};

get '/usuario_correo/:usuario_id' => sub {
    my $usuario_id = param('usuario_id');
    my $model = 'Model::Usuario';
    my $usuarios= $model->new();
    my $rpta = $usuarios->obtener_usuario_correo($usuario_id);
    if (defined $rpta){
        return to_json $rpta;
    }else{
        return 'null';
    }
};

post '/guardar_usuario_correo' => sub {
    my $usuario_json = decode_json(encode_utf8(param('usuario')));
    my $usuario_id= $usuario_json->{"id"};
    my $usuario= $usuario_json->{"usuario"};
    my $correo = $usuario_json->{"correo"};
    my %rpta = ();
    
    try {
        my $model = 'Model::Usuario';
        my $usuarios= $model->new();
        $usuarios->guardar_usuario_correo($usuario_id, $usuario, $correo);
        $rpta{'tipo_mensaje'} = "success";
        my @temp = ("Se ha registrado los cambios en los datos generales del usuario");
        $rpta{'mensaje'} = [@temp];
    } catch {
        #warn "got dbi error: $_";
        $rpta{'tipo_mensaje'} = "error";
        my @temp = ("Se ha producido un error en guardar los datos generales del usuario", "" . $_);
        $rpta{'mensaje'} = [@temp];
    };
    
    return to_json \%rpta;
};

post '/guardar_contrasenia' => sub {
    my $usuario_json = decode_json(encode_utf8(param('contrasenia')));
    my $usuario_id= $usuario_json->{"id"};
    my $contrasenia= $usuario_json->{"contrasenia"};
    my %rpta = ();
    
    try {
        my $model = 'Model::Usuario';
        my $usuarios= $model->new();
        $usuarios->guardar_contrasenia($usuario_id, $contrasenia);
        $rpta{'tipo_mensaje'} = "success";
        my @temp = ("Se ha actualizado la contrasenia del usuario");
        $rpta{'mensaje'} = [@temp];
    } catch {
        #warn "got dbi error: $_";
        $rpta{'tipo_mensaje'} = "error";
        my @temp = ("Se ha producido un error en guardar los datos generales del usuario", "" . $_);
        $rpta{'mensaje'} = [@temp];
    };
    
    return to_json \%rpta;
};

get '/listar_permisos/:sistema_id/:usuario_id' => sub {
    my $sistema_id = param('sistema_id');
    my $usuario_id = param('usuario_id');
    my $model = 'Model::Usuario';
    my $usuarios= $model->new();
    my @rpta = $usuarios->listar_permisos($sistema_id, $usuario_id);
    
    return to_json \@rpta;
};

post '/asociar_permisos' => sub {
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
              my $permiso_id = $nuevo->{'id'};
              crear_asociacion_permiso($usuario_id, $permiso_id);
            }
        }

        for my $permiso_id(@eliminados){
            eliminar_asociacion_permiso($usuario_id, $permiso_id);
        }

        $rpta{'tipo_mensaje'} = "success";
        my @temp = ("Se ha registrado la asociación/deasociación de los permisos al usuario");
        $rpta{'mensaje'} = [@temp];
    } catch {
        #warn "got dbi error: $_";
        $rpta{'tipo_mensaje'} = "error";
        $rpta{'mensaje'} = "Se ha producido un error en asociar/deasociar los permisos al usuario";
        my @temp = ("Se ha producido un error en asociar/deasociar los permisos al usuario", "" . $_);
        $rpta{'mensaje'} = [@temp];
    };
    #print("\n");print Dumper(%rpta);print("\n");
    return to_json \%rpta;
};

sub crear_asociacion_permiso {
    my($usuario_id, $permiso_id) = @_;
    my $model = 'Model::Usuario';
    my $roles= $model->new();

    return $roles->asociar_permiso($usuario_id, $permiso_id);
}

sub eliminar_asociacion_permiso {
    my($usuario_id, $permiso_id) = @_;
    my $model = 'Model::Usuario';
    my $roles= $model->new();

    return $roles->desasociar_permiso($usuario_id, $permiso_id);
}

get '/listar_roles/:sistema_id/:usuario_id' => sub {
    my $sistema_id = param('sistema_id');
    my $usuario_id = param('usuario_id');
    my $model = 'Model::Usuario';
    my $usuarios= $model->new();
    my @rpta = $usuarios->listar_roles($sistema_id, $usuario_id);
    
    return to_json \@rpta;
};

post '/asociar_roles' => sub {
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
              my $rol_id = $nuevo->{'id'};
              crear_asociacion_rol($usuario_id, $rol_id);
            }
        }

        for my $rol_id(@eliminados){
            eliminar_asociacion_rol($usuario_id, $rol_id);
        }

        $rpta{'tipo_mensaje'} = "success";
        my @temp = ("Se ha registrado la asociación/deasociación de los roles al usuario");
        $rpta{'mensaje'} = [@temp];
    } catch {
        #warn "got dbi error: $_";
        $rpta{'tipo_mensaje'} = "error";
        $rpta{'mensaje'} = "Se ha producido un error en asociar/deasociar los roles al usuario";
        my @temp = ("Se ha producido un error en asociar/deasociar los roles al usuario", "" . $_);
        $rpta{'mensaje'} = [@temp];
    };
    #print("\n");print Dumper(%rpta);print("\n");
    return to_json \%rpta;
};

sub crear_asociacion_rol {
    my($usuario_id, $rol_id) = @_;
    my $model = 'Model::Usuario';
    my $roles= $model->new();

    return $roles->asociar_rol($usuario_id, $rol_id);
}

sub eliminar_asociacion_rol {
    my($usuario_id, $rol_id) = @_;
    my $model = 'Model::Usuario';
    my $roles= $model->new();

    return $roles->desasociar_rol($usuario_id, $rol_id);
}

1;