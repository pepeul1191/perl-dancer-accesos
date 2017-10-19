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

=pod
    $r->post('/usuario/asociar_permisos')->to('usuario#asociar_permisos');
    $r->post('/usuario/asociar_roles')->to('usuario#asociar_roles');
=cut

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

get '/listar_roles/:sistema_id/:usuario_id' => sub {
    my $sistema_id = param('sistema_id');
    my $usuario_id = param('usuario_id');
    my $model = 'Model::Usuario';
    my $usuarios= $model->new();
    my @rpta = $usuarios->listar_roles($sistema_id, $usuario_id);
    
    return to_json \@rpta;
};

1;