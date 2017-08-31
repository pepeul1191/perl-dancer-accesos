package MyWeb::Login;
use Dancer2;

get '/' => sub {
	response_header 'X-Powered-By' => 'Perl Dancer 1.3202';
    return 'hola mundo!';
};

true;
