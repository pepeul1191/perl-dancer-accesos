#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";


# use this block if you don't need middleware, and only have a single target Dancer app to run here
use Handler::App;
use Handler::Login;
use Handler::Distrito;
use Handler::Registro;
use Handler::Sistema;

Handler::App->to_app;

use Plack::Builder;

builder {
    enable 'Deflater';
    Handler::App->to_app;
    mount '/'      => Handler::App->to_app;
    mount '/login'      => Handler::Login->to_app;
    mount '/distrito'      => Handler::Distrito->to_app;
    mount '/registro'      => Handler::Registro->to_app;
     mount '/sistema'      => Handler::Sistema->to_app;
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

