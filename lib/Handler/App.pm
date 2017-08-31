package Handler::App;
use Dancer2;

our $VERSION = '0.1';

get '/' => sub {
    template 'index' => { 'title' => 'Perl Dancer2 ????' };
};

get '/hola' => sub {
	response_header 'X-Powered-By' => 'Perl Dancer 1.3202';
    return 'hola mundo!';
};

#get  '/login'        => \&Handler::Login::index;

true;
