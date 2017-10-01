#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";


# use this block if you don't need middleware, and only have a single target Dancer app to run here
use Handler::App;
use Handler::Modulo;
use Handler::Sistema;
use Handler::Subtitulo;
use Handler::Usuario;

Handler::App->to_app;

use Plack::Builder;

builder {
    enable 'Deflater';
    Handler::App->to_app;
    mount '/'      => Handler::App->to_app;
    mount '/modulo'      => Handler::Modulo->to_app;
    mount '/sistema'      => Handler::Sistema->to_app;
    mount '/subtitulo'      => Handler::Subtitulo->to_app;
    mount '/usuario'      => Handler::Usuario->to_app;
}



=begin comment
# use this block if you want to include middleware such as Plack::Middleware::Deflater

use Handler::App;
use Plack::Builder;

builder {
    enable 'Deflater';
    Handler::App->to_app;
}

=end comment

=cut

=begin comment
# use this block if you want to include middleware such as Plack::Middleware::Deflater

use Handler::App;
use Handler::App_admin;

builder {
    mount '/'      => Handler::App->to_app;
    mount '/admin'      => Handler::App_admin->to_app;
}

=end comment

=cut

