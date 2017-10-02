package Handler::Item;
use Dancer2;
use JSON;
use JSON::XS 'decode_json';
use Data::Dumper;
use Try::Tiny;
use strict;
use warnings;
use Model::Item;

hook before => sub {
    response_header 'X-Powered-By' => 'Perl Dancer 1.3202, Ubuntu';
};

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
    my $data = decode_json(param('data'));
    my @nuevos = @{$data->{"nuevos"}};
    my @editados = @{$data->{"editados"}};
    my @eliminados = @{$data->{"eliminados"}};
    my $id_modulo = $data->{"extra"}->{'id_modulo'};
    my @array_nuevos;
    my %rpta = ();

    try {
        for my $nuevo(@nuevos){
           if ($nuevo) {
              my $temp_id = $nuevo->{'id'};
              my $nombre = $nuevo->{'nombre'};
              my $id_generado = crear($id_modulo, $nombre);
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
             editar($id, $id_modulo, $nombre);
            }
        }

        for my $eliminado(@eliminados){
           eliminar($eliminado);
        }

        $rpta{'tipo_mensaje'} = "success";
        my @temp = ("Se ha registrado los cambios en los subtitulos", [@array_nuevos]);
        $rpta{'mensaje'} = [@temp];
    } catch {
        #warn "got dbi error: $_";
        $rpta{'tipo_mensaje'} = "error";
        $rpta{'mensaje'} = "Se ha producido un error en guardar la tabla de subtitulos";
        my @temp = ("Se ha producido un error en guardar la tabla de subtitulos", "" . $_);
        $rpta{'mensaje'} = [@temp];
    };
    #print("\n");print Dumper(%rpta);print("\n");
    return to_json \%rpta;
};

sub crear {
    my($self, $id_modulo, $nombre) = @_;
    my $model = 'Model::Item';
    my $items= $model->new();

    return $items->crear($id_modulo, $nombre);
}

sub editar {
    my($self, $id, $id_modulo, $nombre) = @_;
    my $model = 'Model::Item';
    my $items= $model->new();
    $items->editar($id, $id_modulo, $nombre);
}

sub eliminar {
    my($self, $id) = @_;
    my $model = 'Model::Item';
    my $items= $model->new();
    $items->eliminar($id);
}

1;