package Handler::Item;
use Dancer2;
use JSON;
use JSON::XS 'decode_json';
use Data::Dumper;
use Try::Tiny;
use strict;
use warnings;
use Model::Item;
use utf8;
use Encode qw( encode_utf8 );

get '/listar/:modulo_id' => sub {
    my $modulo_id = param('modulo_id');
    my $model= 'Model::Item';
    my $items= $model->new();
    
    try {
       my  @rpta = $items->listar($modulo_id);
       return to_json \@rpta;
    }
    catch {
        my %rpta = ();
        $rpta{'tipo_mensaje'} = "error";
        $rpta{'mensaje'} = "Se ha producido un error en listar la tabla de items";
        my @temp = ("Se ha producido un error en listar la tabla de items", "" . $_);
        $rpta{'mensaje'} = [@temp];
        return to_json \%rpta;
    };
};

post '/guardar' => sub {
    my $data = decode_json(encode_utf8(param('data')));
    my @nuevos = @{$data->{"nuevos"}};
    my @editados = @{$data->{"editados"}};
    my @eliminados = @{$data->{"eliminados"}};
    my $subtitulo_id = $data->{"extra"}->{'id_subtitulo'};
    my @array_nuevos;
    my %rpta = ();

    try {
        for my $nuevo(@nuevos){
           if ($nuevo) {
              my $temp_id = $nuevo->{'id'};
              my $nombre = $nuevo->{'nombre'};
              my $url = $nuevo->{'url'};
              my $id_generado = crear($subtitulo_id, $nombre, $url);
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
              my $url = $editado->{'url'};
             editar($id, $subtitulo_id, $nombre, $url);
            }
        }

        for my $eliminado(@eliminados){
           eliminar($eliminado);
        }

        $rpta{'tipo_mensaje'} = "success";
        my @temp = ("Se ha registrado los cambios en los items", [@array_nuevos]);
        $rpta{'mensaje'} = [@temp];
    } catch {
        #warn "got dbi error: $_";
        $rpta{'tipo_mensaje'} = "error";
        $rpta{'mensaje'} = "Se ha producido un error en guardar la tabla de items";
        my @temp = ("Se ha producido un error en guardar la tabla de items", "" . $_);
        $rpta{'mensaje'} = [@temp];
    };
    #print("\n");print Dumper(%rpta);print("\n");
    return to_json \%rpta;
};

sub crear {
    my($subtitulo_id, $nombre, $url) = @_;
    my $model = 'Model::Item';
    my $items= $model->new();

    return $items->crear($subtitulo_id, $nombre, $url);
}

sub editar {
    my($id, $subtitulo_id, $nombre, $url) = @_;
    my $model = 'Model::Item';
    my $items= $model->new();
    $items->editar($id, $subtitulo_id, $nombre, $url);
}

sub eliminar {
    my($id) = @_;
    my $model = 'Model::Item';
    my $items= $model->new();
    $items->eliminar($id);
}

1;