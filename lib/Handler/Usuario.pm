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
    + $r->get('/usuario/listar')->to('usuario#listar');
    + $r->get('/usuario/listar_usuarios')->to('usuario#listar_usuarios');
    $r->get('/usuario/listar_accesos/:usuario_id')->to('usuario#listar_accesos');
    $r->get('/usuario/listar_permisos/:usuario_id')->to('usuario#listar_permisos');
    $r->get('/usuario/listar_roles/:usuario_id')->to('usuario#listar_roles');
    + $r->post('/usuario/validar')->to('usuario#validar');
    $r->post('/usuario/validar_correo_repetido')->to('usuario#validar_correo_repetido');
    $r->post('/usuario/validar_usuario_repetido')->to('usuario#validar_usuario_repetido');
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

1;